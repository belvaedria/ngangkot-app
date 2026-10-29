
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app_shell.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/bloc/theme_bloc.dart';
import 'core/theme/bloc/theme_event.dart';
import 'core/theme/bloc/theme_state.dart';
import 'features/routes/presentation/bloc/last_viewed_trayek_bloc.dart';
import 'features/routes/presentation/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NgangkotApp());
}

class NgangkotApp extends StatelessWidget {
  const NgangkotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LastViewedTrayekBloc>(
          create: (_) => LastViewedTrayekBloc(),
        ),
        BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
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
            themeMode: state.themeMode,
            home: AppShell(
              homePageBuilder: (actions) => HomePage(
                onOpenRoutes: actions.openRoutes,
                onOpenJourney: actions.openJourney,
                onOpenAngkotSekitar: actions.openAngkotSekitar,
                onLoginRequired: actions.loginRequired,
                onOpenEducation: actions.openEducation,
                onOpenMenu: actions.openMenu,
              ),
              profilePage: const _ProfilePlaceholder(),
              themeMode: state.themeMode,
              onThemeChanged: (mode) {
                context.read<ThemeBloc>().add(
                  ThemeModeChanged(mode),
                );
              },
            ),
          );
        },
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
