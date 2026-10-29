import 'package:flutter/material.dart';
import '../features/routes/presentation/pages/trayek_page.dart';

enum AppPage { beranda, profil, favorit, sekitar, trayek, laporan, edukasi }

/// Aksi yang bisa dipanggil dari widget Beranda.
class AppShellActions {
  const AppShellActions({
    required this.openRoutes,
    required this.openJourney,
    required this.openAngkotSekitar,
    required this.loginRequired,
    required this.openEducation,
    required this.openMenu,
  });

  final VoidCallback openRoutes;
  final VoidCallback openJourney;
  final VoidCallback openAngkotSekitar;
  final VoidCallback loginRequired;
  final VoidCallback openEducation;
  final VoidCallback openMenu;
}

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.homePageBuilder,
    required this.profilePage,
    required this.themeMode,
    required this.onThemeChanged,
  });

  final Widget Function(AppShellActions actions) homePageBuilder;
  final Widget profilePage;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppPage _selectedPage = AppPage.beranda;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool get _isTabletOrLarger => MediaQuery.sizeOf(context).width >= 600;

  static const _blue = Color(0xFF2563EB);

  static const _serviceItems = <({AppPage page, IconData icon, String label})>[
    (
      page: AppPage.favorit,
      icon: Icons.favorite_border_rounded,
      label: 'Rute favorit',
    ),
    (
      page: AppPage.sekitar,
      icon: Icons.location_on_outlined,
      label: 'Angkot sekitar',
    ),
    (
      page: AppPage.trayek,
      icon: Icons.alt_route_rounded,
      label: 'Lihat trayek',
    ),
    (
      page: AppPage.laporan,
      icon: Icons.report_problem_outlined,
      label: 'Laporan saya',
    ),
    (
      page: AppPage.edukasi,
      icon: Icons.menu_book_outlined,
      label: 'Edukasi',
    ),
  ];

  AppShellActions get _homeActions => AppShellActions(
        openRoutes: () => _selectPage(AppPage.trayek),
        openJourney: () => _showMessage('Fitur navigasi sedang disiapkan.'),
        openAngkotSekitar: () => _selectPage(AppPage.sekitar),
        loginRequired: _showLoginDialog,
        openEducation: () => _selectPage(AppPage.edukasi),
        openMenu: _openDrawer,
      );

  void _openDrawer() {
    if (!_isTabletOrLarger) {
      _scaffoldKey.currentState?.openDrawer();
    }
  }

  void _selectPage(AppPage page) {
    if (page == AppPage.favorit || page == AppPage.laporan) {
      _showLoginDialog();
      _closeDrawerIfNeeded();
      return;
    }

    if (page == AppPage.sekitar) {
      _showMessage('Fitur angkot sekitar akan hadir.');
      _closeDrawerIfNeeded();
      return;
    }

    if (page == AppPage.edukasi) {
      _showMessage('Panduan aplikasi dan tips menaiki angkot.');
      _closeDrawerIfNeeded();
      return;
    }

    setState(() => _selectedPage = page);
    _closeDrawerIfNeeded();
  }

  void _closeDrawerIfNeeded() {
    if (!_isTabletOrLarger &&
        _scaffoldKey.currentState?.isDrawerOpen == true) {
      _scaffoldKey.currentState?.closeDrawer();
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _showLoginDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Login diperlukan'),
        content: const Text('Silakan login untuk menggunakan fitur ini.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Nanti'),
          ),
        ],
      ),
    );
  }

  Widget _currentPage() {
    switch (_selectedPage) {
      case AppPage.beranda:
        return widget.homePageBuilder(_homeActions);
      case AppPage.profil:
        return widget.profilePage;
      case AppPage.trayek:
        return const TrayekPage();
      case AppPage.favorit:
      case AppPage.sekitar:
      case AppPage.laporan:
      case AppPage.edukasi:
        return widget.homePageBuilder(_homeActions);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isTabletOrLarger) {
      return Scaffold(
        body: Row(
          children: [
            SizedBox(width: 88, child: _buildRail()),
            const VerticalDivider(width: 1),
            Expanded(child: _currentPage()),
          ],
        ),
      );
    }

    final hideGlobalAppBar =
        _selectedPage == AppPage.beranda || _selectedPage == AppPage.trayek;

    return Scaffold(
      key: _scaffoldKey,
      appBar: hideGlobalAppBar
          ? null
          : AppBar(
              title: const Text(
                'ngangkot',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
      drawer: Drawer(
        child: SafeArea(
          child: _buildDrawer(),
        ),
      ),
      body: _currentPage(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedPage == AppPage.profil ? 1 : 0,
        onDestinationSelected: (index) {
          _selectPage(index == 0 ? AppPage.beranda : AppPage.profil);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Column(
      children: [
        _accountHeader(compact: false),
        const Divider(height: 1),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: _serviceItems.map((item) {
              return ListTile(
                leading: Icon(item.icon),
                title: Text(item.label),
                selected: _selectedPage == item.page,
                selectedColor: _blue,
                selectedTileColor: const Color(0xFFDBEAFE),
                onTap: () => _selectPage(item.page),
              );
            }).toList(),
          ),
        ),
        const Divider(height: 1),
        _themeControl(compact: false),
      ],
    );
  }

  Widget _buildRail() {
    final selectedIndex = _serviceItems.indexWhere(
      (item) => item.page == _selectedPage,
    );

    return Column(
      children: [
        _accountHeader(compact: true),
        const Divider(height: 1),
        Expanded(
          child: NavigationRail(
            minWidth: 86,
            extended: false,
            labelType: NavigationRailLabelType.all,
            selectedIndex: selectedIndex < 0 ? null : selectedIndex,
            onDestinationSelected: (index) {
              _selectPage(_serviceItems[index].page);
            },
            destinations: _serviceItems.map((item) {
              return NavigationRailDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.icon),
                label: Text(
                  item.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 9),
                ),
              );
            }).toList(),
          ),
        ),
        const Divider(height: 1),
        IconButton(
          tooltip: widget.themeMode == ThemeMode.dark
              ? 'Mode terang'
              : 'Mode gelap',
          onPressed: () {
            widget.onThemeChanged(
              widget.themeMode == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark,
            );
          },
          icon: Icon(
            widget.themeMode == ThemeMode.dark
                ? Icons.dark_mode_rounded
                : Icons.light_mode_rounded,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _accountHeader({required bool compact}) {
    return Material(
      color: _blue,
      child: InkWell(
        onTap: () => _selectPage(AppPage.profil),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 8 : 20,
            vertical: compact ? 14 : 20,
          ),
          child: compact
              ? const Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: _blue),
                  ),
                )
              : const Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: _blue),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Wargi Bandung',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'guest@ngangkot.com',
                            style: TextStyle(
                              color: Color(0xFFDBEAFE),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _themeControl({required bool compact}) {
    final isDark = widget.themeMode == ThemeMode.dark;

    if (compact) {
      return const SizedBox.shrink();
    }

    return SwitchListTile(
      secondary: Icon(
        isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
      ),
      title: const Text('Mode gelap'),
      value: isDark,
      onChanged: (enabled) {
        widget.onThemeChanged(enabled ? ThemeMode.dark : ThemeMode.light);
      },
    );
  }
}