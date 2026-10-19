import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/models/trayek_model.dart';
import '../bloc/last_viewed_trayek_bloc.dart';
import '../bloc/last_viewed_trayek_state.dart';
import 'trayek_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.onOpenRoutes,
    required this.onOpenJourney,
    required this.onOpenAngkotSekitar,
    required this.onLoginRequired,
    required this.onOpenEducation,
  });

  final VoidCallback onOpenRoutes;
  final VoidCallback onOpenJourney;
  final VoidCallback onOpenAngkotSekitar;
  final VoidCallback onLoginRequired;
  final VoidCallback onOpenEducation;

  static const Color _ink = Color(0xFF102A43);
  static const Color _muted = Color(0xFF667B91);
  static const Color _blue = Color(0xFF1769E0);
  static const Color _line = Color(0xFFDCE7F4);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _WelcomeSection(),
            const SizedBox(height: 16),
            _SearchButton(onTap: onOpenJourney),
            const SizedBox(height: 16),
            _MapPreview(onTap: onOpenAngkotSekitar),
            const SizedBox(height: 12),
            const _LastViewedTrayekCard(),
            const SizedBox(height: 22),
            _QuickAccessSection(
              onOpenRoutes: onOpenRoutes,
              onOpenJourney: onOpenJourney,
              onLoginRequired: onLoginRequired,
              onOpenEducation: onOpenEducation,
            ),
            const SizedBox(height: 22),
            _EducationCard(onTap: onOpenEducation),
          ],
        ),
      ),
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(2, 4, 2, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WILUJENG SUMPING, USER!',
            style: TextStyle(
              color: HomePage._blue,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
          SizedBox(height: 7),
          Text(
            'Mau ke mana hari ini?',
            style: TextStyle(
              color: HomePage._ink,
              fontSize: 28,
              height: 1.12,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 54),
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: HomePage._line),
            borderRadius: BorderRadius.circular(17),
          ),
          child: const Row(
            children: [
              Icon(Icons.search_rounded, color: HomePage._blue, size: 22),
              SizedBox(width: 11),
              Expanded(
                child: Text(
                  'Cari lokasi, jalan, dan lainnya',
                  style: TextStyle(
                    color: HomePage._muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapPreview extends StatelessWidget {
  const _MapPreview({required this.onTap});

  final VoidCallback onTap;

  static const LatLng _bandung = LatLng(-6.914744, 107.609810);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(23),
      child: SizedBox(
        width: double.infinity,
        height: 210,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _bandung,
                zoom: 12.8,
              ),
              mapType: MapType.normal,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              scrollGesturesEnabled: false,
              zoomGesturesEnabled: false,
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: Material(
                color: Colors.white.withValues(alpha: 0.96),
                borderRadius: BorderRadius.circular(12),
                elevation: 2,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(12),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 9,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          color: HomePage._blue,
                          size: 17,
                        ),
                        SizedBox(width: 7),
                        Text(
                          'Lihat angkot sekitar',
                          style: TextStyle(
                            color: HomePage._ink,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LastViewedTrayekCard extends StatelessWidget {
  const _LastViewedTrayekCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LastViewedTrayekBloc, LastViewedTrayekState>(
      builder: (context, state) {
        final trayek = state is LastViewedTrayekLoaded
            ? state.trayek
            : null;

        return Material(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: trayek == null
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => TrayekDetailPage(
                          initialTrayek: trayek,
                        ),
                      ),
                    );
                  },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: HomePage._line),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.history_rounded,
                    color: HomePage._blue,
                    size: 19,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: trayek == null
                        ? const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Trayek terakhir dilihat',
                                style: TextStyle(
                                  color: HomePage._ink,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Belum ada trayek yang dilihat',
                                style: TextStyle(
                                  color: HomePage._muted,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          )
                        : _LastViewedTrayekInfo(trayek: trayek),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: trayek == null
                        ? HomePage._muted
                        : HomePage._blue,
                    size: 21,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LastViewedTrayekInfo extends StatelessWidget {
  const _LastViewedTrayekInfo({required this.trayek});

  final TrayekModel trayek;

  Color _parseTrayekColor(String value) {
    try {
      var hex = value.trim().replaceFirst('#', '');
      if (hex.startsWith('0x') || hex.startsWith('0X')) {
        hex = hex.substring(2);
      }

      if (hex.length == 6) {
        hex = 'FF$hex';
      }

      if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (_) {
      // Gunakan warna default jika format warna API tidak valid.
    }

    return const Color(0xFF2563EB);
  }

  @override
  Widget build(BuildContext context) {
    final badgeColor = _parseTrayekColor(trayek.warnaAngkot);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Trayek terakhir dilihat',
          style: TextStyle(
            color: HomePage._muted,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                trayek.kodeTrayek,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                trayek.namaTrayek,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: HomePage._ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAccessSection extends StatelessWidget {
  const _QuickAccessSection({
    required this.onOpenRoutes,
    required this.onOpenJourney,
    required this.onLoginRequired,
    required this.onOpenEducation,
  });

  final VoidCallback onOpenRoutes;
  final VoidCallback onOpenJourney;
  final VoidCallback onLoginRequired;
  final VoidCallback onOpenEducation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Akses layanan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: HomePage._ink,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
              ),
            ),
            TextButton(
              onPressed: onOpenRoutes,
              style: TextButton.styleFrom(
                foregroundColor: HomePage._blue,
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
              child: const Text(
                'Lihat semua',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _QuickAction(
                icon: Icons.map_outlined,
                label: 'Navigasi',
                background: const Color(0xFFFFF0B8),
                foreground: const Color(0xFF8B6510),
                onTap: onOpenJourney,
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _QuickAction(
                icon: Icons.alt_route_rounded,
                label: 'Trayek',
                background: const Color(0xFFDCEEFF),
                foreground: const Color(0xFF1769A8),
                onTap: onOpenRoutes,
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _QuickAction(
                icon: Icons.flag_outlined,
                label: 'Laporan',
                background: const Color(0xFFFDE0DA),
                foreground: const Color(0xFFAD4938),
                onTap: onLoginRequired,
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _QuickAction(
                icon: Icons.shield_outlined,
                label: 'Edukasi',
                background: const Color(0xFFE9E0FA),
                foreground: const Color(0xFF6244A0),
                onTap: onOpenEducation,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 13,
            horizontal: 2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: foreground, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EducationCard extends StatelessWidget {
  const _EducationCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFEAF3FF),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFFB9D7FF),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Color(0xFF174F97),
                  size: 27,
                ),
              ),
              const SizedBox(width: 13),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KENALI NGANGKOT',
                      style: TextStyle(
                        color: HomePage._blue,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.7,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tips nyaman naik angkot',
                      style: TextStyle(
                        color: HomePage._ink,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Kenali panduan dan informasi perjalananmu.',
                      style: TextStyle(
                        color: HomePage._muted,
                        fontSize: 10,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.chevron_right_rounded,
                color: HomePage._blue,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}