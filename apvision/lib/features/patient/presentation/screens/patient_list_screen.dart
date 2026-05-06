import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PatientListScreen extends ConsumerStatefulWidget {
  const PatientListScreen({super.key});

  @override
  ConsumerState<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends ConsumerState<PatientListScreen> {
  final List<Map<String, dynamic>> _patients = [
    {'id': 'APV-A1B2C3', 'name': 'Ravi Kumar', 'age': 58, 'gender': 'Male', 'village': 'Tenali', 'date': '2026-05-04', 'status': 'Screened', 'color': Colors.orange},
    {'id': 'APV-D4E5F6', 'name': 'Lakshmi Devi', 'age': 45, 'gender': 'Female', 'village': 'Bapatla', 'date': '2026-05-03', 'status': 'Spectacles Dispensed', 'color': Colors.green},
    {'id': 'APV-G7H8I9', 'name': 'Venkata Reddy', 'age': 67, 'gender': 'Male', 'village': 'Palnadu', 'date': '2026-05-02', 'status': 'Referred', 'color': Colors.red},
    {'id': 'APV-J1K2L3', 'name': 'Padma Srinivas', 'age': 52, 'gender': 'Female', 'village': 'Guntur', 'date': '2026-04-28', 'status': 'Referred', 'color': Colors.purple},
    {'id': 'APV-M4N5O6', 'name': 'Srinivas Rao', 'age': 61, 'gender': 'Male', 'village': 'Mangalagiri', 'date': '2026-05-01', 'status': 'Screened', 'color': Colors.blue},
    {'id': 'APV-P7Q8R9', 'name': 'Anitha Kumari', 'age': 38, 'gender': 'Female', 'village': 'Narasaraopet', 'date': '2026-05-02', 'status': 'Manufacturing', 'color': Colors.teal},
    {'id': 'APV-S1T2U3', 'name': 'Narasimha Rao', 'age': 72, 'gender': 'Male', 'village': 'Macherla', 'date': '2026-05-05', 'status': 'Prescribed', 'color': Colors.indigo},
    {'id': 'APV-V4W5X6', 'name': 'Sarada Devi', 'age': 55, 'gender': 'Female', 'village': 'Chirala', 'date': '2026-04-25', 'status': 'Screened', 'color': Colors.cyan},
  ];

  String _search = '';

  List<Map<String, dynamic>> get _filtered => _patients.where((p) {
    final q = _search.toLowerCase();
    return (p['name'] as String).toLowerCase().contains(q) ||
        (p['id'] as String).toLowerCase().contains(q) ||
        (p['village'] as String).toLowerCase().contains(q);
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient Registration')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => _search = v),
                    decoration: InputDecoration(
                      hintText: 'Search by name, ID, or village...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => context.push('/registration/new'),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF173F45),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text('${_filtered.length} patients', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const Spacer(),
                const Icon(Icons.sort, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                const Text('Sort by Date', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _filtered.length,
              itemBuilder: (context, i) {
                final p = _filtered[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: (p['color'] as Color).withValues(alpha: 0.12),
                      child: Text(
                        (p['name'] as String)[0],
                        style: TextStyle(color: p['color'] as Color, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(p['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: (p['color'] as Color).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(p['status'] as String, style: TextStyle(fontSize: 10, color: p['color'] as Color, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.badge, size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(p['id'] as String, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(width: 12),
                          const Icon(Icons.person, size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('${p['age']} yrs, ${p['gender']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ]),
                        const SizedBox(height: 2),
                        Row(children: [
                          const Icon(Icons.location_on, size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(p['village'] as String, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(width: 12),
                          const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(p['date'] as String, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ]),
                      ],
                    ),
                    onTap: () {},
                    trailing: PopupMenuButton<String>(
                      onSelected: (val) {
                        if (val == 'screening') context.push('/screening');
                        if (val == 'emr') context.push('/emr');
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: 'screening', child: Row(children: [Icon(Icons.health_and_safety, size: 16), SizedBox(width: 8), Text('Start Screening')])),
                        const PopupMenuItem(value: 'emr', child: Row(children: [Icon(Icons.history, size: 16), SizedBox(width: 8), Text('View EMR')])),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
