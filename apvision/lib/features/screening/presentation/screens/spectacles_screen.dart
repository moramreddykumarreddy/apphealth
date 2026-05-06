import 'package:flutter/material.dart';

class SpectaclesScreen extends StatefulWidget {
  const SpectaclesScreen({super.key});

  @override
  State<SpectaclesScreen> createState() => _SpectaclesScreenState();
}

class _SpectaclesScreenState extends State<SpectaclesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedFilter = 0;

  final List<String> _filters = ['All', 'Prescribed', 'Manufacturing', 'Dispatched', 'Delivered'];

  final List<Map<String, dynamic>> _spectacles = [
    {
      'patientId': 'APV-A1B2C3',
      'name': 'Ravi Kumar',
      'age': 58,
      'prescribedDate': '2026-04-10',
      'type': 'Bifocal',
      'od': 'SPH: +2.00, CYL: -0.50, AXIS: 90',
      'os': 'SPH: +1.75, CYL: -0.25, AXIS: 85',
      'status': 'Delivered',
      'statusStep': 3,
      'dispatchDate': '2026-04-22',
      'deliveredDate': '2026-04-28',
    },
    {
      'patientId': 'APV-D4E5F6',
      'name': 'Lakshmi Devi',
      'age': 45,
      'prescribedDate': '2026-05-03',
      'type': 'Single Vision',
      'od': 'SPH: -1.50, CYL: -0.75, AXIS: 180',
      'os': 'SPH: -1.25, CYL: -0.50, AXIS: 175',
      'status': 'Delivered',
      'statusStep': 3,
      'dispatchDate': '2026-05-08',
      'deliveredDate': '2026-05-10',
    },
    {
      'patientId': 'APV-M4N5O6',
      'name': 'Srinivas Rao',
      'age': 61,
      'prescribedDate': '2026-05-01',
      'type': 'Bifocal',
      'od': 'SPH: +3.00, CYL: -1.00, AXIS: 95',
      'os': 'SPH: +2.75, CYL: -0.75, AXIS: 88',
      'status': 'Dispatched',
      'statusStep': 2,
      'dispatchDate': '2026-05-05',
      'deliveredDate': null,
    },
    {
      'patientId': 'APV-P7Q8R9',
      'name': 'Anitha Kumari',
      'age': 38,
      'prescribedDate': '2026-05-02',
      'type': 'Single Vision',
      'od': 'SPH: -2.00, CYL: 0.00, AXIS: 0',
      'os': 'SPH: -2.25, CYL: -0.25, AXIS: 170',
      'status': 'Manufacturing',
      'statusStep': 1,
      'dispatchDate': null,
      'deliveredDate': null,
    },
    {
      'patientId': 'APV-S1T2U3',
      'name': 'Narasimha Rao',
      'age': 72,
      'prescribedDate': '2026-05-05',
      'type': 'Reading Glasses',
      'od': 'SPH: +2.50, CYL: 0.00, AXIS: 0',
      'os': 'SPH: +2.50, CYL: 0.00, AXIS: 0',
      'status': 'Prescribed',
      'statusStep': 0,
      'dispatchDate': null,
      'deliveredDate': null,
    },
    {
      'patientId': 'APV-V4W5X6',
      'name': 'Sarada Devi',
      'age': 55,
      'prescribedDate': '2026-04-25',
      'type': 'Progressive',
      'od': 'SPH: +1.50, CYL: -0.50, AXIS: 90, ADD: +2.00',
      'os': 'SPH: +1.25, CYL: -0.25, AXIS: 85, ADD: +2.00',
      'status': 'Dispatched',
      'statusStep': 2,
      'dispatchDate': '2026-05-04',
      'deliveredDate': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    if (_selectedFilter == 0) return _spectacles;
    final status = _filters[_selectedFilter];
    return _spectacles.where((s) => s['status'] == status).toList();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Prescribed': return Colors.blue;
      case 'Manufacturing': return Colors.orange;
      case 'Dispatched': return Colors.purple;
      case 'Delivered': return Colors.green;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final counts = {
      'Prescribed': _spectacles.where((s) => s['status'] == 'Prescribed').length,
      'Manufacturing': _spectacles.where((s) => s['status'] == 'Manufacturing').length,
      'Dispatched': _spectacles.where((s) => s['status'] == 'Dispatched').length,
      'Delivered': _spectacles.where((s) => s['status'] == 'Delivered').length,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Spectacle Distribution Tracker')),
      body: Column(
        children: [
          // Stats bar
          Container(
            color: const Color(0xFF173F45).withValues(alpha: 0.04),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: counts.entries.map((e) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _statusColor(e.key).withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        Text('${e.value}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _statusColor(e.key))),
                        Text(e.key, style: const TextStyle(fontSize: 9, color: Colors.grey), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Filter chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final selected = _selectedFilter == i;
                return FilterChip(
                  label: Text(_filters[i]),
                  selected: selected,
                  selectedColor: const Color(0xFF173F45).withValues(alpha: 0.15),
                  checkmarkColor: const Color(0xFF173F45),
                  onSelected: (_) => setState(() => _selectedFilter = i),
                );
              },
            ),
          ),

          // List
          Expanded(
            child: _filtered.isEmpty
                ? const Center(child: Text('No records found.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _filtered.length,
                    itemBuilder: (context, i) => _buildCard(_filtered[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('New Order'),
        backgroundColor: const Color(0xFF173F45),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> s) {
    final status = s['status'] as String;
    final step = s['statusStep'] as int;
    final stages = ['Prescribed', 'Manufacturing', 'Dispatched', 'Delivered'];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _statusColor(status).withValues(alpha: 0.12),
          child: Icon(Icons.remove_red_eye, color: _statusColor(status), size: 20),
        ),
        title: Text(s['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text('${s['patientId']} • ${s['type']} • Prescribed: ${s['prescribedDate']}',
            style: const TextStyle(fontSize: 12)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _statusColor(status).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(status, style: TextStyle(fontSize: 11, color: _statusColor(status), fontWeight: FontWeight.bold)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress tracker
                Row(
                  children: List.generate(stages.length, (i) {
                    final done = i <= step;
                    return Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              if (i > 0) Expanded(child: Container(height: 2, color: i <= step ? const Color(0xFF173F45) : Colors.grey.shade200)),
                              Container(
                                width: 28, height: 28,
                                decoration: BoxDecoration(
                                  color: done ? const Color(0xFF173F45) : Colors.grey.shade200,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(done ? Icons.check : Icons.circle, color: done ? Colors.white : Colors.grey, size: 14),
                              ),
                              if (i < stages.length - 1) Expanded(child: Container(height: 2, color: i < step ? const Color(0xFF173F45) : Colors.grey.shade200)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(stages[i], style: TextStyle(fontSize: 9, color: done ? const Color(0xFF173F45) : Colors.grey, fontWeight: done ? FontWeight.bold : FontWeight.normal), textAlign: TextAlign.center),
                        ],
                      ),
                    );
                  }),
                ),
                const Divider(height: 20),
                Text('OD: ${s['od']}', style: const TextStyle(fontSize: 12, fontFamily: 'monospace')),
                const SizedBox(height: 4),
                Text('OS: ${s['os']}', style: const TextStyle(fontSize: 12, fontFamily: 'monospace')),
                if (s['dispatchDate'] != null) ...[
                  const SizedBox(height: 8),
                  Text('Dispatched: ${s['dispatchDate']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
                if (s['deliveredDate'] != null) ...[
                  const SizedBox(height: 4),
                  Text('Delivered: ${s['deliveredDate']}', style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
