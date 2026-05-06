import 'package:flutter/material.dart';

class EmrScreen extends StatefulWidget {
  const EmrScreen({super.key});

  @override
  State<EmrScreen> createState() => _EmrScreenState();
}

class _EmrScreenState extends State<EmrScreen> {
  static const Color _violet = Color(0xFF173F45);

  final List<Map<String, dynamic>> _patients = [
    {
      'id': 'APV-A1B2C3',
      'name': 'Ravi Kumar',
      'age': 58,
      'gender': 'Male',
      'village': 'Tenali',
      'phone': '9876543210',
      'lastVisit': '2026-05-04',
      'diagnosis': 'Cataract (OD)',
      'status': 'Under Treatment',
      'color': Colors.orange,
      'visits': [
        {
          'date': '2026-05-04',
          'doctor': 'Dr. Suresh Babu',
          'diagnosis': 'Cataract (OD)',
          'iop': '16 / 14 mmHg',
          'va': 'OD: 6/36  OS: 6/12',
          'notes': 'Surgery scheduled for May 20. Patient counselled.',
          'plan': 'Surgery Referral',
        },
        {
          'date': '2026-03-12',
          'doctor': 'Dr. Kavitha Rao',
          'diagnosis': 'Early Cataract',
          'iop': '15 / 15 mmHg',
          'va': 'OD: 6/24  OS: 6/9',
          'notes': 'Monitor every 3 months. No surgery yet.',
          'plan': 'Follow-up in 3 months',
        },
        {
          'date': '2026-01-05',
          'doctor': 'Dr. Suresh Babu',
          'diagnosis': 'Presbyopia + Early Cataract',
          'iop': '14 / 13 mmHg',
          'va': 'OD: 6/18  OS: 6/9',
          'notes': 'Prescribed reading glasses +2.00 OU.',
          'plan': 'Spectacles',
        },
      ],
    },
    {
      'id': 'APV-D4E5F6',
      'name': 'Lakshmi Devi',
      'age': 45,
      'gender': 'Female',
      'village': 'Bapatla',
      'phone': '9988776655',
      'lastVisit': '2026-05-03',
      'diagnosis': 'Myopia',
      'status': 'Spectacles Dispensed',
      'color': Colors.green,
      'visits': [
        {
          'date': '2026-05-03',
          'doctor': 'Dr. Kavitha Rao',
          'diagnosis': 'Myopia',
          'iop': '13 / 13 mmHg',
          'va': 'OD: 6/24  OS: 6/18',
          'notes': 'Spectacles dispensed. Review in 6 months.',
          'plan': 'Spectacles dispensed',
        },
        {
          'date': '2025-11-20',
          'doctor': 'Dr. Kavitha Rao',
          'diagnosis': 'Myopia',
          'iop': '13 / 12 mmHg',
          'va': 'OD: 6/24  OS: 6/18',
          'notes': 'Rx: OD -1.50/-0.75×180  OS -1.25/-0.50×175',
          'plan': 'Spectacles ordered',
        },
      ],
    },
    {
      'id': 'APV-G7H8I9',
      'name': 'Venkata Reddy',
      'age': 67,
      'gender': 'Male',
      'village': 'Palnadu',
      'phone': '9123456780',
      'lastVisit': '2026-05-02',
      'diagnosis': 'Glaucoma Suspect',
      'status': 'Referred',
      'color': Colors.red,
      'visits': [
        {
          'date': '2026-05-02',
          'doctor': 'Dr. Suresh Babu',
          'diagnosis': 'Glaucoma Suspect',
          'iop': '24 / 22 mmHg',
          'va': 'OD: 6/9  OS: 6/9',
          'notes': 'IOP elevated. Referred to Guntur Eye Hospital for OCT.',
          'plan': 'Refer to District Hospital',
        },
        {
          'date': '2026-02-14',
          'doctor': 'Dr. Suresh Babu',
          'diagnosis': 'Borderline IOP',
          'iop': '21 / 20 mmHg',
          'va': 'OD: 6/9  OS: 6/9',
          'notes': 'Monitor IOP monthly. Timolol drops prescribed.',
          'plan': 'Medical Treatment',
        },
      ],
    },
    {
      'id': 'APV-J1K2L3',
      'name': 'Padma Srinivas',
      'age': 52,
      'gender': 'Female',
      'village': 'Guntur',
      'phone': '9871234560',
      'lastVisit': '2026-04-28',
      'diagnosis': 'Diabetic Retinopathy',
      'status': 'Referred',
      'color': Colors.purple,
      'visits': [
        {
          'date': '2026-04-28',
          'doctor': 'Dr. Kavitha Rao',
          'diagnosis': 'Non-proliferative DR',
          'iop': '15 / 14 mmHg',
          'va': 'OD: 6/18  OS: 6/12',
          'notes': 'HbA1c advised. Referred for laser treatment at LV Prasad.',
          'plan': 'Refer to District Hospital',
        },
      ],
    },
    {
      'id': 'APV-M4N5O6',
      'name': 'Srinivas Rao',
      'age': 61,
      'gender': 'Male',
      'village': 'Mangalagiri',
      'phone': '9765432100',
      'lastVisit': '2026-05-01',
      'diagnosis': 'Pterygium',
      'status': 'Screened',
      'color': Colors.blue,
      'visits': [
        {
          'date': '2026-05-01',
          'doctor': 'Dr. Suresh Babu',
          'diagnosis': 'Pterygium (OD)',
          'iop': '14 / 14 mmHg',
          'va': 'OD: 6/12  OS: 6/6',
          'notes': 'Mild pterygium encroaching pupillary area. Surgery not yet needed.',
          'plan': 'Follow-up in 3 months',
        },
      ],
    },
  ];

  // Track which patient is selected (null = list view)
  Map<String, dynamic>? _selected;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    if (isWide) {
      return Scaffold(
        appBar: AppBar(title: const Text('EMR / Patient History')),
        body: Row(
          children: [
            SizedBox(width: 300, child: _buildList()),
            const VerticalDivider(width: 1),
            Expanded(
              child: _selected == null
                  ? _buildEmptyState()
                  : _buildDetail(_selected!),
            ),
          ],
        ),
      );
    }

    // Mobile: show list OR detail
    if (_selected != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_selected!['name'] as String),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => setState(() => _selected = null),
          ),
        ),
        body: _buildDetail(_selected!),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('EMR / Patient History')),
      body: _buildList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.person_add),
        label: const Text('New Patient'),
        backgroundColor: _violet,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_search, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text('Select a patient to view their history',
              style: TextStyle(color: Colors.grey, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildList() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search patient...',
                prefixIcon: const Icon(Icons.search, size: 18),
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text('${_patients.length} records',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(10),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final p = _patients[i];
                final isSelected = _selected != null && _selected!['id'] == p['id'];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Card(
                    color: isSelected ? _violet.withValues(alpha: 0.06) : null,
                    margin: EdgeInsets.zero,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            (p['color'] as Color).withValues(alpha: 0.15),
                        child: Text(
                          (p['name'] as String)[0],
                          style: TextStyle(
                              color: p['color'] as Color,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(p['name'] as String,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text(
                        '${p['age']} yrs • ${p['gender']} • ${p['village']}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color:
                                  (p['color'] as Color).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              (p['status'] as String)
                                  .split(' ')
                                  .take(2)
                                  .join(' '),
                              style: TextStyle(
                                  fontSize: 9,
                                  color: p['color'] as Color,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(p['visits'] as List).length} visits',
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                      onTap: () => setState(() => _selected = p),
                    ),
                  ),
                );
              },
              childCount: _patients.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetail(Map<String, dynamic> p) {
    final visits = p['visits'] as List<Map<String, dynamic>>;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Patient Header ────────────────────────────────────────────
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: (p['color'] as Color).withValues(alpha: 0.15),
                      child: Text(
                        (p['name'] as String)[0],
                        style: TextStyle(
                            fontSize: 24,
                            color: p['color'] as Color,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p['name'] as String,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 3),
                          Text(
                            '${p['age']} yrs • ${p['gender']} • ${p['village']}',
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          const SizedBox(height: 3),
                          Text('📞 ${p['phone']}',
                              style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _infoChip(Icons.badge_outlined, 'ID: ${p['id']}', Colors.grey),
                    _infoChip(Icons.medical_information_outlined, p['diagnosis'] as String, _violet),
                    _infoChip(Icons.calendar_today_outlined, 'Last: ${p['lastVisit']}', Colors.grey),
                    _infoChip(Icons.history_outlined, '${visits.length} visit(s)', Colors.grey),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: (p['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '● ${p['status']}',
                    style: TextStyle(
                        color: p['color'] as Color,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 10),
          child: Text('Visit History',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),

        // ── Visit Cards ───────────────────────────────────────────────
        ...List.generate(visits.length, (i) => _buildVisitCard(visits[i], i)),
      ],
    );
  }

  Widget _infoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildVisitCard(Map<String, dynamic> v, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: index == 0 ? _violet.withValues(alpha: 0.3) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Visit header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index == 0 ? _violet : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    v['date'] as String,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: index == 0 ? _violet : Colors.black87),
                  ),
                  if (index == 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                          color: _violet.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(5)),
                      child: const Text('Latest',
                          style: TextStyle(fontSize: 9, color: _violet, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ]),
                Text(v['doctor'] as String,
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
            const Divider(height: 16),

            // Diagnosis
            _detailRow('Diagnosis', v['diagnosis'] as String, Icons.medical_information_outlined),
            const SizedBox(height: 8),
            _detailRow('IOP', v['iop'] as String, Icons.compress_outlined),
            const SizedBox(height: 8),
            _detailRow('Visual Acuity', v['va'] as String, Icons.remove_red_eye_outlined),
            const SizedBox(height: 8),
            _detailRow('Plan', v['plan'] as String, Icons.assignment_outlined),
            const SizedBox(height: 10),

            // Notes
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.notes_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      v['notes'] as String,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 6),
        SizedBox(
          width: 90,
          child: Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ),
        Expanded(
          child: Text(value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
