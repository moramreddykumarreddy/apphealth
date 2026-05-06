import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:apvision/shared/utils/responsive.dart';
import 'package:apvision/shared/providers/patient_provider.dart';
import '../widgets/kpi_card.dart';
import '../widgets/charts_widget.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final patients = ref.watch(patientProvider);
    
    final kpis = [
      _KPIData('Total Screenings', patients.length.toString(), Icons.people, Colors.blue),
      _KPIData('Spectacles Delivered', patients.where((p) => p.status.contains('Spectacles')).length.toString(), Icons.remove_red_eye, const Color(0xFF00897B)),
      _KPIData('Referrals', patients.where((p) => p.status.contains('Referred')).length.toString(), Icons.local_hospital, Colors.orange),
      _KPIData('District Coverage', '100%', Icons.map, Colors.purple),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF173F45),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'AP Vision Outreach',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Profile Options',
            onSelected: (value) {
              if (value == 'logout') {
                context.go('/login');
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Logout', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: isMobile || Responsive.isTablet(context) ? _buildDrawer(context) : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isDesktop(context))
            SizedBox(width: 250, child: _buildDrawer(context)),
          Expanded(child: _buildBody(context, kpis)),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF173F45), Color(0xFF2A5C63)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.remove_red_eye, color: Colors.white, size: 42),
                SizedBox(height: 12),
                Text(
                  'AP Vision Outreach',
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('Field Health Application', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _drawerItem(context, Icons.dashboard, 'Dashboard', '/dashboard', go: true),
                _drawerItem(context, Icons.person_add, 'Patient Registration', '/registration'),
                _drawerItem(context, Icons.medical_services, 'Eye Screening', '/screening'),
                _drawerItem(context, Icons.remove_red_eye, 'Spectacle Distribution', '/spectacles'),
                _drawerItem(context, Icons.history, 'EMR / History', '/emr'),
                _drawerItem(context, Icons.bar_chart, 'Reports', '/reports'),
                const Divider(height: 32),
                _drawerItem(context, Icons.settings, 'Settings', '/settings'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String label, String route, {bool go = false}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF173F45)),
      title: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      onTap: () {
        if (Responsive.isMobile(context)) Navigator.pop(context);
        go ? context.go(route) : context.push(route);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }

  Widget _buildBody(BuildContext context, List<_KPIData> kpis) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Good Morning! 👋',
            style: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
          ),
          const SizedBox(height: 4),
          Text(
            'Overview',
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E)),
          ),
          const SizedBox(height: 20),



          // KPI Cards
          _buildKPISection(context, kpis),
          const SizedBox(height: 28),

          // Charts
          Text(
            'Analytics',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E)),
          ),
          const SizedBox(height: 16),
          const ChartsWidget(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildKPISection(BuildContext context, List<_KPIData> kpis) {
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);

    // Mobile: vertical list of cards
    if (!isTablet && !isDesktop) {
      return Column(
        children: kpis.map((k) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: KPICard(title: k.title, value: k.value, icon: k.icon, color: k.color),
        )).toList(),
      );
    }

    // Tablet: 2-col grid, Desktop: 4-col grid
    final cols = isDesktop ? 4 : 2;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: isDesktop ? 2.2 : 2.5,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, i) {
        final k = kpis[i];
        return KPICard(title: k.title, value: k.value, icon: k.icon, color: k.color);
      },
    );
  }
}

class _KPIData {
  final String title, value;
  final IconData icon;
  final Color color;
  const _KPIData(this.title, this.value, this.icon, this.color);
}

