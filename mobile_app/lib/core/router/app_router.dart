import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/letters/presentation/pages/letters_page.dart';
import '../../features/letters/presentation/pages/letter_create_page.dart';
import '../../features/letters/presentation/pages/letter_details_page.dart';
import '../../features/templates/presentation/pages/templates_page.dart';
import '../../features/company/presentation/pages/company_settings_page.dart';
import '../../features/company/presentation/pages/company_setup_page.dart';
import '../../features/company/presentation/pages/letterhead_onboarding_page.dart';
import '../../features/subscriptions/presentation/pages/subscriptions_page.dart';
import '../../features/recipients/presentation/pages/recipients_page.dart';
import '../../features/organizations/presentation/pages/organizations_page.dart';
import '../../features/recipient_titles/presentation/pages/recipient_titles_page.dart';
import '../../features/letter_subjects/presentation/pages/letter_subjects_page.dart';
import '../../features/main/presentation/pages/main_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

/// مسارات التطبيق
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String main = '/main';
  static const String dashboard = '/dashboard';
  static const String letters = '/letters';
  static const String letterCreate = '/letters/create';
  static const String letterDetails = '/letters/:id';
  static const String templates = '/templates';
  static const String companySettings = '/company/settings';
  static const String companySetup = '/company/setup';
  static const String letterheadOnboarding = '/company/letterhead-onboarding';
  static const String subscriptions = '/subscriptions';
  static const String recipients = '/recipients';
  static const String organizations = '/organizations';
  static const String recipientTitles = '/recipient-titles';
  static const String letterSubjects = '/letter-subjects';
  static const String settings = '/settings';
}

/// Router Configuration
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final isLoggedIn = authState is AuthAuthenticated;
      final isLoggingIn = state.matchedLocation == AppRoutes.login;
      final isSplash = state.matchedLocation == AppRoutes.splash;

      // إذا كان في صفحة Splash، لا تعيد التوجيه
      if (isSplash) return null;

      // إذا لم يكن مسجل دخول وليس في صفحة تسجيل الدخول
      if (!isLoggedIn && !isLoggingIn) {
        return AppRoutes.login;
      }

      // إذا كان مسجل دخول وفي صفحة تسجيل الدخول
      if (isLoggedIn && isLoggingIn) {
        return AppRoutes.main;
      }

      return null;
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),

      // Login
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // Main Shell (with Bottom Navigation)
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainPage(child: child),
        routes: [
          // Dashboard
          GoRoute(
            path: AppRoutes.main,
            pageBuilder: (context, state) =>
                _buildPageWithAnimation(state, const DashboardPage()),
          ),

          // Letters List
          GoRoute(
            path: AppRoutes.letters,
            pageBuilder: (context, state) =>
                _buildPageWithAnimation(state, const LettersPage()),
          ),

          // Templates
          GoRoute(
            path: AppRoutes.templates,
            pageBuilder: (context, state) =>
                _buildPageWithAnimation(state, const TemplatesPage()),
          ),

          // Company Settings
          GoRoute(
            path: AppRoutes.companySettings,
            pageBuilder: (context, state) =>
                _buildPageWithAnimation(state, const CompanySettingsPage()),
          ),

          // Subscriptions
          GoRoute(
            path: AppRoutes.subscriptions,
            pageBuilder: (context, state) =>
                _buildPageWithAnimation(state, const SubscriptionsPage()),
          ),

          // Recipients
          GoRoute(
            path: AppRoutes.recipients,
            pageBuilder: (context, state) =>
                _buildPageWithAnimation(state, const RecipientsPage()),
          ),

          // Organizations
          GoRoute(
            path: AppRoutes.organizations,
            pageBuilder: (context, state) =>
                _buildPageWithAnimation(state, const OrganizationsPage()),
          ),

          // Recipient Titles
          GoRoute(
            path: AppRoutes.recipientTitles,
            pageBuilder: (context, state) =>
                _buildPageWithAnimation(state, const RecipientTitlesPage()),
          ),

          // Letter Subjects
          GoRoute(
            path: AppRoutes.letterSubjects,
            pageBuilder: (context, state) =>
                _buildPageWithAnimation(state, const LetterSubjectsPage()),
          ),

          // Settings
          GoRoute(
            path: AppRoutes.settings,
            pageBuilder: (context, state) =>
                _buildPageWithAnimation(state, const SettingsPage()),
          ),
        ],
      ),

      // Company Setup (Full Screen)
      GoRoute(
        path: AppRoutes.companySetup,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const CompanySetupPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: child,
            );
          },
        ),
      ),

      // Letterhead Onboarding (Full Screen)
      GoRoute(
        path: AppRoutes.letterheadOnboarding,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LetterheadOnboardingPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: child,
            );
          },
        ),
      ),

      // Letter Create (Full Screen)
      GoRoute(
        path: AppRoutes.letterCreate,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LetterCreatePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: child,
            );
          },
        ),
      ),

      // Letter Details (Full Screen)
      GoRoute(
        path: AppRoutes.letterDetails,
        pageBuilder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return CustomTransitionPage(
            key: state.pageKey,
            child: LetterDetailsPage(letterId: id),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: child,
              );
            },
          );
        },
      ),
    ],
  );

  /// بناء صفحة مع Animation
  static CustomTransitionPage _buildPageWithAnimation(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child,
        );
      },
    );
  }
}
