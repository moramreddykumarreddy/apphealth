import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Weekly';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _dailyReports = [
    {'date': '2026-05-05 (Mon)', 'screenings': 45, 'spectacles': 12, 'referrals': 4, 'camp': 'Tenali Camp'},
    {'date': '2026-05-04 (Sun)', 'screenings': 32, 'spectacles': 8, 'referrals': 2, 'camp': 'Bapatla PHC'},
    {'date': '2026-05-03 (Sat)', 'screenings': 67, 'spectacles': 20, 'referrals': 7, 'camp': 'Guntur Urban'},
    {'date': '2026-05-02 (Fri)', 'screenings': 53, 'spectacles': 14, 'referrals': 5, 'camp': 'Narasaraopet'},
    {'date': '2026-05-01 (Thu)', 'screenings': 41, 'spectacles': 9, 'referrals': 3, 'camp': 'Palnadu PHC'},
    {'date': '2026-04-30 (Wed)', 'screenings': 58, 'spectacles': 16, 'referrals': 6, 'camp': 'Mangalagiri'},
    {'date': '2026-04-29 (Tue)', 'screenings': 39, 'spectacles': 11, 'referrals': 3, 'camp': 'Macherla'},
  ];

  final List<Map<String, dynamic>> _weeklyReports = [
    {'week': 'Week 1 (Apr 1–7)', 'screenings': 280, 'spectacles': 72, 'referrals': 22, 'camps': 6},
    {'week': 'Week 2 (Apr 8–14)', 'screenings': 315, 'spectacles': 88, 'referrals': 28, 'camps': 7},
    {'week': 'Week 3 (Apr 15–21)', 'screenings': 290, 'spectacles': 65, 'referrals': 19, 'camps': 6},
    {'week': 'Week 4 (Apr 22–28)', 'screenings': 340, 'spectacles': 95, 'referrals': 31, 'camps': 8},
    {'week': 'Week 5 (Apr 29–May 5)', 'screenings': 335, 'spectacles': 90, 'referrals': 30, 'camps': 7},
  ];

  final List<Map<String, dynamic>> _monthlyReports = [
    {'month': 'January 2026', 'screenings': 1240, 'spectacles': 320, 'referrals': 95, 'camps': 28},
    {'month': 'February 2026', 'screenings': 1180, 'spectacles': 290, 'referrals': 88, 'camps': 26},
    {'month': 'March 2026', 'screenings': 1380, 'spectacles': 360, 'referrals': 110, 'camps': 31},
    {'month': 'April 2026', 'screenings': 1560, 'spectacles': 410, 'referrals': 130, 'camps': 34},
    {'month': 'May 2026 (partial)', 'screenings': 335, 'spectacles': 90, 'referrals': 30, 'camps': 7},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Daily'),
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Summary banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFF173F45).withValues(alpha: 0.05),
            child: Row(
              children: [
                _summaryChip('12,450', 'Total Screenings', Colors.blue),
                _summaryChip('3,210', 'Spectacles', Colors.green),
                _summaryChip('480', 'Referrals', Colors.orange),
                _summaryChip('26', 'Districts', Colors.purple),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDailyTab(),
                _buildWeeklyTab(),
                _buildMonthlyTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Report exported as PDF!')),
          );
        },
        icon: const Icon(Icons.download),
        label: const Text('Export PDF'),
        backgroundColor: const Color(0xFF173F45),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _summaryChip(String value, String label, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color)),
            Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionHeader('Daily Screening Reports', 'Last 7 Days'),
          ..._dailyReports.map((r) => _buildDailyCard(r)),
        ],
      ),
    );
  }

  Widget _buildDailyCard(Map<String, dynamic> r) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(r['date'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text(r['camp'] as String, style: const TextStyle(fontSize: 11, color: Colors.blue, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(children: [
              _statBadge('${r['screenings']}', 'Screened', Colors.blue),
              _statBadge('${r['spectacles']}', 'Spectacles', Colors.green),
              _statBadge('${r['referrals']}', 'Referred', Colors.orange),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionHeader('Weekly Summary', 'April – May 2026'),
          ..._weeklyReports.map((r) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(r['week'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('${r['camps']} Camps', style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.w600, fontSize: 12)),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    _statBadge('${r['screenings']}', 'Screened', Colors.blue),
                    _statBadge('${r['spectacles']}', 'Spectacles', Colors.green),
                    _statBadge('${r['referrals']}', 'Referred', Colors.orange),
                  ]),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (r['screenings'] as int) / 400,
                      backgroundColor: Colors.grey.shade200,
                      color: const Color(0xFF173F45),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildMonthlyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionHeader('Monthly Performance', 'Jan – May 2026'),
          ..._monthlyReports.map((r) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(r['month'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text('${r['camps']} Camps', style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.w600, fontSize: 12)),
                  ]),
                  const SizedBox(height: 12),
                  _statRow('Screenings', '${r['screenings']}', Colors.blue, (r['screenings'] as int) / 1600),
                  const SizedBox(height: 6),
                  _statRow('Spectacles', '${r['spectacles']}', Colors.green, (r['spectacles'] as int) / 450),
                  const SizedBox(height: 6),
                  _statRow('Referrals', '${r['referrals']}', Colors.orange, (r['referrals'] as int) / 140),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.filter_list, size: 14),
            label: const Text('Filter', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _statBadge(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value, Color color, double progress) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13)),
        const SizedBox(width: 10),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey.shade200,
              color: color,
              minHeight: 6,
            ),
          ),
        ),
      ],
    );
  }
}
