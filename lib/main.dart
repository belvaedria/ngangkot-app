
import 'package:flutter/material.dart';

import 'app/app_shell.dart';
import 'core/theme/app_theme.dart';
import 'features/routes/presentation/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NgangkotApp());
}

class NgangkotApp extends StatefulWidget {
  const NgangkotApp({super.key});

  @override
  State<NgangkotApp> createState() => _NgangkotAppState();
}

class _NgangkotAppState extends State<NgangkotApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ngangkot',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _themeMode,
      home: AppShell(
        homePageBuilder: (actions) => HomePage(
          onOpenRoutes: actions.openRoutes,
          onOpenJourney: actions.openJourney,
          onOpenAngkotSekitar: actions.openAngkotSekitar,
          onLoginRequired: actions.loginRequired,
          onOpenEducation: actions.openEducation,
        ),
        profilePage: const _ProfilePlaceholder(),
        themeMode: _themeMode,
        onThemeChanged: _changeTheme,
      ),
    );
  }
}

class _ProfilePlaceholder extends StatelessWidget {
  const _ProfilePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Profil'),
      ),
    );
  }
}
