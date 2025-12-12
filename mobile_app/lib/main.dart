import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/router/app_router.dart';
import 'core/di/injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize dependencies
  await di.init();

  runApp(const LettersApp());
}

class LettersApp extends StatelessWidget {
  const LettersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(di.sl()),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(
                  create: (_) =>
                      di.sl<AuthBloc>()..add(CheckAuthStatusEvent())),
              BlocProvider<DashboardBloc>(
                  create: (_) => di.sl<DashboardBloc>()),
            ],
            child: MaterialApp.router(
              title: AppConfig.appName,
              debugShowCheckedModeBanner: false,

              // Theme with Dark Mode Support
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.themeMode,

              // Localization - Arabic RTL
              locale: const Locale('ar', 'SA'),
              supportedLocales: const [
                Locale('ar', 'SA'),
              ],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],

              // Router
              routerConfig: AppRouter.router,
            ),
          );
        },
      ),
    );
  }
}
