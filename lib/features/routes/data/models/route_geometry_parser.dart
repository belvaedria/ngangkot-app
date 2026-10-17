import 'dart:convert';

import 'route_point.dart';

class RouteGeometryParser {
  static List<RoutePoint> parse(String? ruteJson) {
    if (ruteJson == null || ruteJson.trim().isEmpty) {
      return const [];
    }

    try {
      final decoded = jsonDecode(ruteJson);

      if (decoded is! Map<String, dynamic>) {
        return const [];
      }

      final features = decoded['features'];

      if (features is! List) {
        return const [];
      }

      final points = <RoutePoint>[];

      for (final feature in features) {
        if (feature is! Map) continue;

        final geometry = feature['geometry'];
        if (geometry is! Map) continue;

        final coordinates = geometry['coordinates'];
        if (coordinates is! List) continue;

        for (final coordinate in coordinates) {
          if (coordinate is! List ||
              coordinate.length < 2) {
            continue;
          }

          final longitude =
              (coordinate[0] as num).toDouble();
          final latitude =
              (coordinate[1] as num).toDouble();

          points.add(
            RoutePoint(
              latitude: latitude,
              longitude: longitude,
            ),
          );
        }
      }

      return points;
    } on FormatException {
      return const [];
    } on TypeError {
      return const [];
    }
  }
}