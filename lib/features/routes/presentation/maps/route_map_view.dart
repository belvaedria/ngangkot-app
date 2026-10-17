import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/models/trayek_model.dart';
import '../../data/models/route_geometry_parser.dart';

class RouteMapView extends StatefulWidget {
  final TrayekModel trayek;

  const RouteMapView({
    super.key,
    required this.trayek,
  });

  @override
  State<RouteMapView> createState() => _RouteMapViewState();
}

class _RouteMapViewState extends State<RouteMapView> {
  GoogleMapController? _mapController;

  late List<LatLng> _coordinates;

  @override
  void initState() {
    super.initState();
    _parseCoordinates();
  }

  void _parseCoordinates() {
    final points = RouteGeometryParser.parse(
      widget.trayek.ruteJson,
    );

    _coordinates = points
        .map(
          (point) => LatLng(
            point.latitude,
            point.longitude,
          ),
        )
        .toList();
  }

  @override
  void didUpdateWidget(covariant RouteMapView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.trayek.kodeTrayek !=
        widget.trayek.kodeTrayek) {
      _parseCoordinates();
      _fitRoute();
    }
  }

  Future<void> _fitRoute() async {
    final controller = _mapController;

    if (controller == null || _coordinates.isEmpty) {
      return;
    }

    if (_coordinates.length == 1) {
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(_coordinates.first, 15),
      );
      return;
    }

    double minLat = _coordinates.first.latitude;
    double maxLat = minLat;
    double minLng = _coordinates.first.longitude;
    double maxLng = minLng;

    for (final point in _coordinates) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 64),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_coordinates.isEmpty) {
      return const Center(
        child: Text('Geometri rute belum tersedia.'),
      );
    }

    final firstPoint = _coordinates.first;
    final lastPoint = _coordinates.last;

    final parsedColor = int.tryParse(
      widget.trayek.warnaAngkot.replaceFirst('#', ''),
      radix: 16,
    );

    final routeColor = Color(
      0xFF000000 | (parsedColor ?? 0x002563EB),
    );

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: firstPoint,
        zoom: 14,
      ),
      onMapCreated: (controller) {
        _mapController = controller;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _fitRoute();
        });
      },
      polylines: {
        if (_coordinates.length >= 2)
          Polyline(
            polylineId: PolylineId(
              'trayek-${widget.trayek.kodeTrayek}',
            ),
            points: _coordinates,
            color: routeColor,
            width: 5,
          ),
      },
      markers: {
        Marker(
          markerId: MarkerId(
            'asal-${widget.trayek.kodeTrayek}',
          ),
          position: firstPoint,
          infoWindow: const InfoWindow(
            title: 'Titik awal',
          ),
        ),
        if (_coordinates.length >= 2)
          Marker(
            markerId: MarkerId(
              'tujuan-${widget.trayek.kodeTrayek}',
            ),
            position: lastPoint,
            infoWindow: const InfoWindow(
              title: 'Titik akhir',
            ),
          ),
      },
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}