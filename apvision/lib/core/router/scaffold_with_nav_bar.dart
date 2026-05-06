import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/utils/responsive.dart';
import '../../shared/providers/screening_state_provider.dart';
import '../../shared/providers/emr_state_provider.dart';

class ScaffoldWithNavBar extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  void _onItemTapped(int index, WidgetRef ref) {
    // Reset internal states of tabs to their root views when switching
    if (index == 2) {
      ref.read(screeningStateProvider.notifier).reset();
    } else if (index == 3) {
      ref.read(emrStateProvider.notifier).reset();
    }
    
    navigationShell.goBranch(
      index,
      initialLocation: true,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = Responsive.isMobile(context);

    // If it's desktop/tablet, we don't show the bottom nav bar.
    // The drawer is handled inside the DashboardScreen currently,
    // or we could put the drawer here. But for now, just the bottom bar for mobile.
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: isMobile
          ? NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              backgroundColor: Colors.white,
              indicatorColor: const Color(0xFF173F45).withValues(alpha: 0.12),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              onDestinationSelected: (index) => _onItemTapped(index, ref),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_add_outlined),
                  selectedIcon: Icon(Icons.person_add),
                  label: 'Patients',
                ),
                NavigationDestination(
                  icon: Icon(Icons.health_and_safety_outlined),
                  selectedIcon: Icon(Icons.health_and_safety),
                  label: 'Screening',
                ),
                NavigationDestination(
                  icon: Icon(Icons.history_outlined),
                  selectedIcon: Icon(Icons.history),
                  label: 'EMR',
                ),
                NavigationDestination(
                  icon: Icon(Icons.remove_red_eye_outlined),
                  selectedIcon: Icon(Icons.remove_red_eye),
                  label: 'Spectacles',
                ),
              ],
            )
          : null,
    );
  }
}
