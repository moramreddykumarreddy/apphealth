import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/patient/presentation/screens/patient_list_screen.dart';
import '../../features/patient/presentation/screens/registration_screen.dart';
import '../../features/screening/presentation/screens/screening_screen.dart';
import '../../features/emr/presentation/screens/emr_screen.dart';
import '../../features/screening/presentation/screens/spectacles_screen.dart';
import '../../features/reports/presentation/screens/reports_screen.dart';
import 'scaffold_with_nav_bar.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/dashboard'),
              child: const Text('Back to Dashboard'),
            ),
          ],
        ),
      ),
    ),
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/dashboard',
              name: 'dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/registration',
              name: 'registration',
              builder: (context, state) => const PatientListScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  name: 'new-registration',
                  builder: (context, state) => const RegistrationScreen(),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/screening',
              name: 'screening',
              builder: (context, state) => const ScreeningScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/emr',
              name: 'emr',
              builder: (context, state) => const EmrScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/spectacles',
              name: 'spectacles',
              builder: (context, state) => const SpectaclesScreen(),
            ),
          ]),
        ],
      ),
      GoRoute(
        path: '/reports',
        name: 'reports',
        builder: (context, state) => const ReportsScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: const Center(child: Text('Settings coming soon')),
        ),
      ),
    ],
  );
});
