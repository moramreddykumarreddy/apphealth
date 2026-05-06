import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apvision/shared/providers/patient_provider.dart';
import 'package:apvision/shared/providers/emr_state_provider.dart';
import 'package:apvision/core/models/patient_model.dart';

class EmrScreen extends ConsumerStatefulWidget {
  const EmrScreen({super.key});

  @override
  ConsumerState<EmrScreen> createState() => _EmrScreenState();
}

class _EmrScreenState extends ConsumerState<EmrScreen> {
  static const Color _violet = Color(0xFF173F45);

  // State is now managed by emrStateProvider
  // Patient? _selected;

  @override
  Widget build(BuildContext context) {
    final patients = ref.watch(patientProvider);
    final selectedPatient = ref.watch(emrStateProvider);
    final isWide = MediaQuery.of(context).size.width > 700;

    if (isWide) {
      return Scaffold(
        appBar: AppBar(title: const Text('EMR / Patient History')),
        body: Row(
          children: [
            SizedBox(width: 300, child: _buildList(patients, selectedPatient)),
            const VerticalDivider(width: 1),
            Expanded(
              child: selectedPatient == null
                  ? _buildEmptyState()
                  : _buildDetail(selectedPatient),
            ),
          ],
        ),
      );
    }

    // Mobile: show list OR detail
    if (selectedPatient != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(selectedPatient.name),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => ref.read(emrStateProvider.notifier).reset(),
          ),
        ),
        body: _buildDetail(selectedPatient),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('EMR / Patient History')),
      body: _buildList(patients, selectedPatient),
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

  Widget _buildList(List<Patient> patients, Patient? selectedPatient) {
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
            child: Text('${patients.length} records',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(10),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final p = patients[i];
                final isSelected = selectedPatient != null && selectedPatient.id == p.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Card(
                    color: isSelected ? _violet.withValues(alpha: 0.06) : null,
                    margin: EdgeInsets.zero,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: p.color.withValues(alpha: 0.15),
                        child: Text(
                          p.name[0],
                          style: TextStyle(color: p.color, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text('${p.age} yrs • ${p.gender} • ${p.village}', style: const TextStyle(fontSize: 12)),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: p.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              p.status.split(' ').take(2).join(' '),
                              style: TextStyle(fontSize: 9, color: p.color, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('${p.visits.length} visits', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                      onTap: () => ref.read(emrStateProvider.notifier).selectPatient(p),
                    ),
                  ),
                );
              },
              childCount: patients.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetail(Patient p) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
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
                      backgroundColor: p.color.withValues(alpha: 0.15),
                      child: Text(p.name[0], style: TextStyle(fontSize: 24, color: p.color, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 3),
                          Text('${p.age} yrs • ${p.gender} • ${p.village}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          const SizedBox(height: 3),
                          Text('📞 ${p.phone}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
                    _infoChip(Icons.badge_outlined, 'ID: ${p.id}', Colors.grey),
                    _infoChip(Icons.medical_information_outlined, p.diagnosis, _violet),
                    _infoChip(Icons.calendar_today_outlined, 'Last: ${p.lastVisit}', Colors.grey),
                    _infoChip(Icons.history_outlined, '${p.visits.length} visit(s)', Colors.grey),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: p.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text('● ${p.status}', style: TextStyle(color: p.color, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 10),
          child: Text('Visit History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        ...List.generate(p.visits.length, (i) => _buildVisitCard(p.visits[i], i)),
      ],
    );
  }

  Widget _infoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.07), borderRadius: BorderRadius.circular(6)),
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

  Widget _buildVisitCard(ScreeningVisit v, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: index == 0 ? _violet.withValues(alpha: 0.3) : Colors.transparent, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: index == 0 ? _violet : Colors.grey, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text(v.date, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: index == 0 ? _violet : Colors.black87)),
                  if (index == 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: _violet.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(5)),
                      child: const Text('Latest', style: TextStyle(fontSize: 9, color: _violet, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ]),
                Text(v.doctor, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
            const Divider(height: 16),
            _detailRow('Diagnosis', v.diagnosis, Icons.medical_information_outlined),
            const SizedBox(height: 8),
            _detailRow('IOP', v.iop, Icons.compress_outlined),
            const SizedBox(height: 8),
            _detailRow('Visual Acuity', v.va, Icons.remove_red_eye_outlined),
            const SizedBox(height: 8),
            _detailRow('Plan', v.plan, Icons.assignment_outlined),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.notes_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text(v.notes, style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic))),
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
        SizedBox(width: 90, child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
      ],
    );
  }
}
