import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_client.dart';
import '../../data/models/trayek_model.dart';
import '../../data/repositories/trayek_repository.dart';
import '../bloc/last_viewed_trayek_bloc.dart';
import '../bloc/last_viewed_trayek_event.dart';
import '../maps/route_map_view.dart';

class TrayekDetailPage extends StatefulWidget {
  final TrayekModel initialTrayek;

  const TrayekDetailPage({super.key, required this.initialTrayek});

  @override
  State<TrayekDetailPage> createState() => _TrayekDetailPageState();
}

class _TrayekDetailPageState extends State<TrayekDetailPage> {
  late final TrayekRepository _repository;
  late TrayekModel _activeTrayek;

  bool _isLoadingReturn = false;
  String? _returnError;

  @override
  void initState() {
    super.initState();

    _repository = TrayekRepository(apiClient: ApiClient());
    _activeTrayek = widget.initialTrayek;

    context.read<LastViewedTrayekBloc>().add(
      LastViewedTrayekUpdated(_activeTrayek),
    );
  }

  Future<void> _switchDirection() async {
    final kodeBalik = _activeTrayek.kodeBalik;

    if (kodeBalik == null || kodeBalik.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data trayek balik belum tersedia.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoadingReturn = true;
      _returnError = null;
    });

    try {
      final trayekBalik = await _repository.getTrayekByKode(kodeBalik);

      if (!mounted) return;

      setState(() {
        _activeTrayek = trayekBalik;
        _isLoadingReturn = false;
      });

      context.read<LastViewedTrayekBloc>().add(
        LastViewedTrayekUpdated(_activeTrayek),
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoadingReturn = false;
        _returnError = 'Gagal memuat trayek arah balik.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final trayek = _activeTrayek;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: RouteMapView(
              key: ValueKey(trayek.kodeTrayek),
              trayek: trayek,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topLeft,
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 3,
                  child: IconButton(
                    tooltip: 'Kembali',
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.48,
            minChildSize: 0.20,
            maxChildSize: 0.88,
            snap: true,
            snapSizes: const [0.48, 0.88],
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 12,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      trayek.namaTrayek,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _buildEndpoint(
                                icon: Icons.trip_origin,
                                label: 'TITIK AWAL',
                                value: trayek.namaTrayek.split(' - ').first,
                                color: const Color(0xFF2563EB),
                              ),
                              const SizedBox(height: 20),
                              _buildEndpoint(
                                icon: Icons.location_on,
                                label: 'TITIK AKHIR',
                                value: trayek.namaTrayek.split(' - ').last,
                                color: const Color(0xFFDC6474),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          children: [
                            IconButton.filledTonal(
                              tooltip: 'Ganti arah trayek',
                              onPressed: _isLoadingReturn
                                  ? null
                                  : _switchDirection,
                              icon: _isLoadingReturn
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.swap_vert),
                            ),
                            const Text(
                              'Pulang-pergi',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (_returnError != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _returnError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Icon(Icons.route, color: Color(0xFF2563EB)),
                        SizedBox(width: 8),
                        Text(
                          'Jalan yang dilalui',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (trayek.daftarJalan.isEmpty)
                      const Text('Daftar jalan belum tersedia.')
                    else
                      ...trayek.daftarJalan.asMap().entries.map((entry) {
                        final index = entry.key;
                        final jalan = entry.value;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: const Color(0xFFEFF6FF),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Color(0xFF2563EB),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(jalan),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/${trayek.kodeTrayek}.png',
                          width: 100,
                          height: 70,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              width: 100,
                              height: 70,
                              child: Icon(
                                Icons.directions_bus,
                                size: 44,
                                color: Color(0xFF2563EB),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Angkot trayek ini',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                trayek.kodeTrayek,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEndpoint({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}