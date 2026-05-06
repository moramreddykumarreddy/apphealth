import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/utils/responsive.dart';

class ScreeningScreen extends ConsumerStatefulWidget {
  const ScreeningScreen({super.key});

  @override
  ConsumerState<ScreeningScreen> createState() => _ScreeningScreenState();
}

class _ScreeningScreenState extends ConsumerState<ScreeningScreen> {
  // null = show patient selection, non-null = show stepper
  String? _selectedPatient;
  int _currentStep = 0;

  static const Color _violet = Color(0xFF173F45);

  final List<Map<String, String>> _waitingPatients = [
    {'id': 'APV-A1B2C3', 'name': 'Ravi Kumar', 'age': '58', 'gender': 'Male', 'village': 'Tenali'},
    {'id': 'APV-G7H8I9', 'name': 'Venkata Reddy', 'age': '67', 'gender': 'Male', 'village': 'Palnadu'},
    {'id': 'APV-M4N5O6', 'name': 'Srinivas Rao', 'age': '61', 'gender': 'Male', 'village': 'Mangalagiri'},
    {'id': 'APV-P7Q8R9', 'name': 'Anitha Kumari', 'age': '38', 'gender': 'Female', 'village': 'Narasaraopet'},
  ];

  final List<String> _symptoms = ['Blurry Vision', 'Eye Pain', 'Redness', 'Tearing', 'Headache', 'Itching', 'Watering', 'Night Blindness'];
  final List<String> _selectedSymptoms = [];
  final List<String> _medicalHistory = ['Diabetes', 'Hypertension', 'Asthma', 'Thyroid', 'Heart Disease', 'Glaucoma (family)'];
  final List<String> _selectedMedicalHistory = [];

  @override
  Widget build(BuildContext context) {
    if (_selectedPatient == null) {
      return _buildPatientSelection();
    }
    return _buildScreeningFlow();
  }

  Widget _buildPatientSelection() {
    return Scaffold(
      appBar: AppBar(title: const Text('Eye Screening')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: _violet.withValues(alpha: 0.05),
            child: Row(children: [
              const Icon(Icons.queue, color: Color(0xFF173F45)),
              const SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Screening Queue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('${_waitingPatients.length} patients waiting', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ]),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: _waitingPatients.length,
              itemBuilder: (context, i) {
                final p = _waitingPatients[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _violet.withValues(alpha: 0.1),
                      child: Text(p['name']![0], style: const TextStyle(color: Color(0xFF173F45), fontWeight: FontWeight.bold)),
                    ),
                    title: Text(p['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${p['id']} • ${p['age']} yrs, ${p['gender']} • ${p['village']}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    trailing: ElevatedButton(
                      onPressed: () => setState(() {
                        _selectedPatient = p['name'];
                        _currentStep = 0;
                        _selectedSymptoms.clear();
                        _selectedMedicalHistory.clear();
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _violet,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        textStyle: const TextStyle(fontSize: 13),
                      ),
                      child: const Text('Start'),
                    ),
                    onTap: () => setState(() {
                      _selectedPatient = p['name'];
                      _currentStep = 0;
                    }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreeningFlow() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screening: $_selectedPatient'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _selectedPatient = null),
        ),
      ),
      body: Stepper(
        type: Responsive.isMobile(context) ? StepperType.vertical : StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 4) {
            setState(() => _currentStep++);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('✅ Screening saved successfully!')),
            );
            setState(() => _selectedPatient = null);
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) setState(() => _currentStep--);
          else setState(() => _selectedPatient = null);
        },
        steps: [
          Step(title: const Text('Symptoms'), content: _buildSymptomsStep(), isActive: _currentStep >= 0, state: _currentStep > 0 ? StepState.complete : StepState.indexed),
          Step(title: const Text('Medical Hx'), content: _buildMedicalHistoryStep(), isActive: _currentStep >= 1, state: _currentStep > 1 ? StepState.complete : StepState.indexed),
          Step(title: const Text('Visual Acuity'), content: _buildVisualAcuityStep(), isActive: _currentStep >= 2, state: _currentStep > 2 ? StepState.complete : StepState.indexed),
          Step(title: const Text('Refraction'), content: _buildRefractionStep(), isActive: _currentStep >= 3, state: _currentStep > 3 ? StepState.complete : StepState.indexed),
          Step(title: const Text('Diagnosis'), content: _buildDiagnosisStep(), isActive: _currentStep >= 4, state: _currentStep == 4 ? StepState.editing : StepState.indexed),
        ],
      ),
    );
  }

  Widget _buildSymptomsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select all presenting symptoms:', style: TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _symptoms.map((symptom) {
            final isSelected = _selectedSymptoms.contains(symptom);
            return FilterChip(
              label: Text(symptom),
              selected: isSelected,
              selectedColor: _violet.withValues(alpha: 0.18),
              checkmarkColor: _violet,
              onSelected: (v) => setState(() {
                if (v) _selectedSymptoms.add(symptom);
                else _selectedSymptoms.remove(symptom);
              }),
            );
          }).toList(),
        ),
        if (_selectedSymptoms.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: _violet.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(8)),
            child: Text('Selected: ${_selectedSymptoms.join(', ')}', style: const TextStyle(fontSize: 12, color: Color(0xFF173F45))),
          ),
        ],
        const SizedBox(height: 12),
        TextFormField(
          maxLines: 2,
          decoration: const InputDecoration(labelText: 'Other complaints (optional)'),
        ),
      ],
    );
  }

  Widget _buildMedicalHistoryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Known medical conditions:', style: TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 8),
        ..._medicalHistory.map((h) {
          final isSelected = _selectedMedicalHistory.contains(h);
          return SwitchListTile(
            title: Text(h),
            value: isSelected,
            activeColor: _violet,
            dense: true,
            onChanged: (v) => setState(() {
              if (v) _selectedMedicalHistory.add(h);
              else _selectedMedicalHistory.remove(h);
            }),
          );
        }),
        const SizedBox(height: 8),
        TextFormField(decoration: const InputDecoration(labelText: 'Current medications (if any)')),
        const SizedBox(height: 8),
        TextFormField(decoration: const InputDecoration(labelText: 'Previous eye surgeries')),
      ],
    );
  }

  Widget _buildVisualAcuityStep() {
    return Responsive.isMobile(context)
        ? Column(children: [_buildVAInput('Right Eye (OD)'), const SizedBox(height: 16), _buildVAInput('Left Eye (OS)')])
        : Row(children: [Expanded(child: _buildVAInput('Right Eye (OD)')), const SizedBox(width: 16), Expanded(child: _buildVAInput('Left Eye (OS)'))]);
  }

  Widget _buildVAInput(String eye) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(eye, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF173F45))),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Distance Vision (Unaided)', isDense: true),
              items: ['6/6', '6/9', '6/12', '6/18', '6/24', '6/36', '6/60', 'CF', 'HM', 'PL', 'NPL']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) {},
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Distance Vision (Aided)', isDense: true),
              items: ['6/6', '6/9', '6/12', '6/18', '6/24', '6/36', '6/60', 'CF', 'HM', 'PL', 'NPL', 'N/A']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) {},
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Near Vision', isDense: true),
              items: ['N6', 'N8', 'N10', 'N12', 'N18', 'N24', 'N36', 'Unable']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRefractionStep() {
    return Column(
      children: [
        const Text('Enter refraction values:', style: TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(children: [
                  const SizedBox(width: 36, child: Text('Eye', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey))),
                  Expanded(child: Text('Sphere', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade600, fontSize: 12))),
                  Expanded(child: Text('Cylinder', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade600, fontSize: 12))),
                  Expanded(child: Text('Axis', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade600, fontSize: 12))),
                  Expanded(child: Text('ADD', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade600, fontSize: 12))),
                ]),
                const Divider(height: 16),
                _buildRefractionRow('OD'),
                const SizedBox(height: 10),
                _buildRefractionRow('OS'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Lens Type Recommendation'),
          items: ['Single Vision', 'Bifocal', 'Progressive', 'Reading Glasses', 'No Correction Needed']
              .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) {},
        ),
      ],
    );
  }

  Widget _buildRefractionRow(String eye) {
    return Row(
      children: [
        SizedBox(width: 36, child: Text(eye, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF173F45)))),
        Expanded(child: TextFormField(decoration: const InputDecoration(hintText: '+0.00', isDense: true), keyboardType: TextInputType.number)),
        const SizedBox(width: 6),
        Expanded(child: TextFormField(decoration: const InputDecoration(hintText: '-0.00', isDense: true), keyboardType: TextInputType.number)),
        const SizedBox(width: 6),
        Expanded(child: TextFormField(decoration: const InputDecoration(hintText: '0°', isDense: true), keyboardType: TextInputType.number)),
        const SizedBox(width: 6),
        Expanded(child: TextFormField(decoration: const InputDecoration(hintText: '+0.00', isDense: true), keyboardType: TextInputType.number)),
      ],
    );
  }

  Widget _buildDiagnosisStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Responsive.isMobile(context)
            ? Column(children: [_buildIOPField('Right Eye (OD)'), const SizedBox(height: 10), _buildIOPField('Left Eye (OS)')])
            : Row(children: [Expanded(child: _buildIOPField('IOP – OD (mmHg)')), const SizedBox(width: 12), Expanded(child: _buildIOPField('IOP – OS (mmHg)'))]),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Primary Diagnosis'),
          items: ['Normal', 'Refractive Error', 'Presbyopia', 'Cataract', 'Glaucoma Suspect', 'Glaucoma', 'Diabetic Retinopathy', 'Corneal Opacity', 'Amblyopia', 'Other']
              .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) {},
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Secondary Diagnosis (if any)'),
          items: ['None', 'Pterygium', 'Dry Eye', 'Allergic Conjunctivitis', 'Blepharitis', 'Strabismus']
              .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) {},
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Management Plan'),
          items: ['Spectacles', 'Surgery Referral', 'Medical Treatment', 'Follow-up in 3 Months', 'Refer to District Hospital', 'No Treatment Required']
              .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) {},
        ),
        const SizedBox(height: 12),
        TextFormField(
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Clinical Notes / Remarks'),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: TextFormField(decoration: const InputDecoration(labelText: 'Examiner Name'))),
          const SizedBox(width: 12),
          Expanded(child: TextFormField(decoration: const InputDecoration(labelText: 'Qualification'))),
        ]),
      ],
    );
  }

  Widget _buildIOPField(String label) {
    return TextFormField(
      decoration: InputDecoration(labelText: label, suffixText: 'mmHg'),
      keyboardType: TextInputType.number,
    );
  }
}
