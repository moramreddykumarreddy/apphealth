import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScreeningScreen extends ConsumerStatefulWidget {
  const ScreeningScreen({super.key});

  @override
  ConsumerState<ScreeningScreen> createState() => _ScreeningScreenState();
}

class _ScreeningScreenState extends ConsumerState<ScreeningScreen> {
  int _currentStep = 0;
  String? _selectedPatient;

  // Colors based on the design
  static const Color _bgColor = Color(0xFFFBF6EE);
  static const Color _cardColor = Colors.white;
  static const Color _fieldBgColor = Color(0xFFF4EBDC);
  static const Color _activeColor = Color(0xFF173F45); // Changed from Orange to Emerald
  static const Color _completedColor = Color(0xFF173F45); // Emerald
  static const Color _inactiveColor = Color(0xFFE0E0E0);
  static const Color _textColor = Color(0xFF173F45);

  final List<String> _steps = [
    'PATIENT INFO', 'COMPLAINTS', 'VISUAL ACUITY',
    'REFRACTION & RX', 'DIAGNOSIS', 'EXAMINER'
  ];

  final List<IconData> _stepIcons = [
    Icons.person, Icons.chat_bubble_outline, Icons.remove_red_eye,
    Icons.remove_red_eye_outlined, Icons.medical_services_outlined, Icons.badge_outlined
  ];

  bool get isMobile => MediaQuery.of(context).size.width < 800;

  Widget _buildResponsiveRow(List<Widget> children) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children.map((c) => Padding(padding: const EdgeInsets.only(bottom: 16), child: c)).toList(),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.map((c) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 16), child: c))).toList(),
    );
  }

  final List<Map<String, String>> _waitingPatients = [
    {'id': 'APV-A1B2C3', 'name': 'Ravi Kumar', 'age': '58', 'gender': 'Male', 'village': 'Tenali'},
    {'id': 'APV-G7H8I9', 'name': 'Venkata Reddy', 'age': '67', 'gender': 'Male', 'village': 'Palnadu'},
    {'id': 'APV-M4N5O6', 'name': 'Srinivas Rao', 'age': '61', 'gender': 'Male', 'village': 'Mangalagiri'},
    {'id': 'APV-P7Q8R9', 'name': 'Anitha Kumari', 'age': '38', 'gender': 'Female', 'village': 'Narasaraopet'},
  ];

  @override
  Widget build(BuildContext context) {
    if (_selectedPatient == null) {
      return _buildPatientQueue();
    }

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        title: Text('Screening: $_selectedPatient', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: _completedColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() {
            _selectedPatient = null;
            _currentStep = 0;
          }),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              _buildCustomStepper(),
              const SizedBox(height: 8),
              Expanded(
                child: Card(
                  color: _cardColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 12.0 : 24.0),
                    child: _buildCurrentStepContent(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildBottomControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientQueue() {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        title: const Text('Screening Queue'),
        backgroundColor: _completedColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () => setState(() {
              _selectedPatient = "New Patient";
              _currentStep = 0;
            }),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('NEW PATIENT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: _completedColor.withValues(alpha: 0.05),
            child: Row(
              children: [
                const Icon(Icons.people_outline, color: _completedColor),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Available Patients', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textColor)),
                    Text('${_waitingPatients.length} patients waiting for screening', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _waitingPatients.length,
              itemBuilder: (context, i) {
                final p = _waitingPatients[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: _completedColor.withValues(alpha: 0.1),
                      child: Text(p['name']![0], style: const TextStyle(color: _completedColor, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(p['name']!, style: const TextStyle(fontWeight: FontWeight.bold, color: _textColor)),
                    subtitle: Text('${p['id']} • ${p['age']} yrs, ${p['gender']} • ${p['village']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    trailing: ElevatedButton(
                      onPressed: () => setState(() {
                        _selectedPatient = p['name'];
                        _currentStep = 0;
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _completedColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Start'),
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

  Widget _buildCustomStepper() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            final stepIndex = index ~/ 2;
            final isCompleted = _currentStep > stepIndex;
            final isCurrentPath = _currentStep == stepIndex + 1;
            
            return Container(
              width: 40, height: 2,
              color: isCompleted ? _completedColor : (isCurrentPath ? _activeColor : _inactiveColor),
            );
          }

          final stepIndex = index ~/ 2;
          final isCompleted = _currentStep > stepIndex;
          final isActive = _currentStep == stepIndex;

          return Column(
            children: [
              Container(
                width: 32, height: 32, // Reduced from 40
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? _completedColor : (isActive ? _activeColor : Colors.white),
                  border: Border.all(color: isCompleted ? _completedColor : (isActive ? _activeColor : _inactiveColor), width: 2),
                ),
                child: Icon(isCompleted ? Icons.check : _stepIcons[stepIndex], color: isCompleted || isActive ? Colors.white : Colors.grey, size: 16), // Reduced size
              ),
              const SizedBox(height: 4), // Reduced from 8
              Text(
                _steps[stepIndex],
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isActive ? _activeColor : (isCompleted ? _completedColor : Colors.grey)), // Reduced font size
              )
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              setState(() {
                _selectedPatient = null;
                _currentStep = 0;
              });
            }
          },
          icon: const Icon(Icons.arrow_back, size: 18),
          label: isMobile ? const SizedBox() : const Text('Previous'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey.shade800,
            elevation: 0,
            side: BorderSide(color: Colors.grey.shade300),
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 24, vertical: 10), // Reduced vertical from 16
          ),
        ),
            
        Row(
          children: List.generate(_steps.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8, height: 8,
              decoration: BoxDecoration(shape: BoxShape.circle, color: _currentStep == index ? _activeColor : _inactiveColor),
            );
          }),
        ),

        _currentStep < _steps.length - 1
            ? ElevatedButton(
                onPressed: () => setState(() => _currentStep++),
                style: ElevatedButton.styleFrom(backgroundColor: _activeColor, foregroundColor: Colors.white, elevation: 0, padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: 10)), // Reduced from 16
                child: Row(children: [if (!isMobile) const Text('Next', style: TextStyle(fontWeight: FontWeight.bold)), if (!isMobile) const SizedBox(width: 8), const Icon(Icons.arrow_forward, size: 18)]),
              )
            : ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Screening Saved to EMR')));
                  setState(() { _currentStep = 0; _selectedPatient = null; });
                },
                icon: const Icon(Icons.save),
                label: isMobile ? const SizedBox() : const Text('Save to EMR', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: _completedColor, foregroundColor: Colors.white, elevation: 0, padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: 10)), // Reduced from 16
              ),
      ],
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0: return _buildStep1();
      case 1: return _buildStep2();
      case 2: return _buildStep3();
      case 3: return _buildStep4();
      case 4: return _buildStep5();
      case 5: return _buildStep6();
      default: return const SizedBox();
    }
  }

  Widget _buildStepHeader(IconData icon, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: _activeColor),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textColor))),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        const SizedBox(height: 8),
        TextFormField(decoration: InputDecoration(hintText: hint, filled: true, fillColor: _fieldBgColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14))),
      ],
    );
  }

  Widget _buildDropdownField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(filled: true, fillColor: _fieldBgColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
          hint: Text(hint), items: const [], onChanged: (val) {},
        ),
      ],
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(Icons.person, 'Patient Information'),
          _buildResponsiveRow([
            _buildTextField('FULL NAME *', 'Enter full name'),
            _buildTextField('AGE *', 'Years'),
            _buildDropdownField('GENDER', 'Select'),
          ]),
          _buildResponsiveRow([
            _buildTextField('PHONE NUMBER', '+91 XXXXX XXXXX'),
            _buildDropdownField('DISTRICT', 'Select District'),
            _buildTextField('VILLAGE / WARD', 'Village or ward name'),
          ]),
          SizedBox(width: isMobile ? double.infinity : 300, child: _buildTextField('AADHAAR (LAST 4 DIGITS)', 'XXXX')),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(Icons.chat_bubble, 'Presenting Complaints & History'),
          const Text('SYMPTOMS (TICK ALL THAT APPLY)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _activeColor)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12, runSpacing: 12,
            children: ['Blurred Vision', 'Redness', 'Watering', 'Pain / Discomfort', 'Photophobia', 'Headache / Eye Strain']
                .map((s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(color: _fieldBgColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.check_box_outline_blank, size: 18, color: Colors.grey), const SizedBox(width: 8), Text(s, style: const TextStyle(fontSize: 12))]),
                    )).toList(),
          ),
          const SizedBox(height: 24),
          _buildTextField('OTHER SYMPTOMS', 'Specify other symptoms'),
          const SizedBox(height: 32),
          _buildResponsiveRow([
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('OCULAR HISTORY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _activeColor)),
                const SizedBox(height: 12),
                ...['Refractive Error', 'Cataract', 'Glaucoma', 'Trauma', 'Contact Lens Use'].map((h) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: BoxDecoration(color: _fieldBgColor, borderRadius: BorderRadius.circular(8)), child: Row(children: [const Icon(Icons.check_box_outline_blank, size: 18, color: Colors.grey), const SizedBox(width: 12), Text(h, style: const TextStyle(fontSize: 12))])),
                    )),
                _buildTextField('SURGERY (SPECIFY)', 'Type of surgery'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('MEDICAL HISTORY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _activeColor)),
                const SizedBox(height: 12),
                ...['Diabetes', 'Hypertension', 'Thyroid Disorder', 'Autoimmune Disease'].map((h) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: BoxDecoration(color: _fieldBgColor, borderRadius: BorderRadius.circular(8)), child: Row(children: [const Icon(Icons.check_box_outline_blank, size: 18, color: Colors.grey), const SizedBox(width: 12), Text(h, style: const TextStyle(fontSize: 12))])),
                    )),
                _buildTextField('CURRENT MEDICATIONS', 'List medications'),
                const SizedBox(height: 12),
                _buildTextField('KNOWN ALLERGIES', 'List allergies'),
              ],
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(Icons.remove_red_eye, 'Visual Acuity Assessment'),
          const Text('DISTANCE VISION — UNAIDED / BEST CORRECTED / PINHOLE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _activeColor)),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 60, child: Text('EYE', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10))),
                    const SizedBox(width: 15),
                    const SizedBox(width: 100, child: Text('UCVA', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10))),
                    const SizedBox(width: 16),
                    const SizedBox(width: 100, child: Text('BCVA', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10))),
                    const SizedBox(width: 16),
                    const SizedBox(width: 100, child: Text('PINHOLE', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10))),
                  ],
                ),
                const SizedBox(height: 8),
                _buildAcuityRow('OD', 'RIGHT', _activeColor),
                const SizedBox(height: 12),
                _buildAcuityRow('OS', 'LEFT', Colors.blue),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          const Text('NEAR VISION', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _activeColor)),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 60, child: Text('EYE', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10))),
                    const SizedBox(width: 15),
                    const SizedBox(width: 150, child: Text('UNAIDED', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10))),
                    const SizedBox(width: 16),
                    const SizedBox(width: 150, child: Text('WITH CORRECTION', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10))),
                  ],
                ),
                const SizedBox(height: 8),
                _buildNearAcuityRow('OD', 'RIGHT', _activeColor),
                const SizedBox(height: 12),
                _buildNearAcuityRow('OS', 'LEFT', Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcuityRow(String eye, String sub, Color color) {
    return Row(
      children: [
        Container(
          width: 60, padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(border: Border.all(color: color.withValues(alpha: 0.3)), borderRadius: BorderRadius.circular(8)),
          child: Column(children: [Text(eye, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)), Text(sub, style: TextStyle(color: color, fontSize: 8))]),
        ),
        const SizedBox(width: 15),
        SizedBox(width: 100, child: TextFormField(textAlign: TextAlign.center, decoration: InputDecoration(hintText: '6/6', filled: true, fillColor: _fieldBgColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)))),
        const SizedBox(width: 16),
        SizedBox(width: 100, child: TextFormField(textAlign: TextAlign.center, decoration: InputDecoration(hintText: '6/6', filled: true, fillColor: _fieldBgColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)))),
        const SizedBox(width: 16),
        SizedBox(width: 100, child: TextFormField(textAlign: TextAlign.center, decoration: InputDecoration(hintText: '6/6', filled: true, fillColor: _fieldBgColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)))),
      ],
    );
  }

  Widget _buildNearAcuityRow(String eye, String sub, Color color) {
    return Row(
      children: [
        Container(
          width: 60, padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(border: Border.all(color: color.withValues(alpha: 0.3)), borderRadius: BorderRadius.circular(8)),
          child: Column(children: [Text(eye, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)), Text(sub, style: TextStyle(color: color, fontSize: 8))]),
        ),
        const SizedBox(width: 15),
        SizedBox(width: 150, child: TextFormField(textAlign: TextAlign.center, decoration: InputDecoration(hintText: 'N6', filled: true, fillColor: _fieldBgColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)))),
        const SizedBox(width: 16),
        SizedBox(width: 150, child: TextFormField(textAlign: TextAlign.center, decoration: InputDecoration(hintText: 'N6', filled: true, fillColor: _fieldBgColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)))),
      ],
    );
  }

  Widget _buildStep4() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(Icons.remove_red_eye_outlined, 'Refraction & Final Prescription'),
          const Text('OBJECTIVE REFRACTION (AUTO / RETINOSCOPY)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _activeColor)),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 60, child: Text('EYE', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10))),
                    const SizedBox(width: 15),
                    const SizedBox(width: 80, child: Text('SPHERE', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10))),
                    const SizedBox(width: 16),
                    const SizedBox(width: 80, child: Text('CYLINDER', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10))),
                    const SizedBox(width: 16),
                    const SizedBox(width: 80, child: Text('AXIS', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10))),
                    const SizedBox(width: 16),
                    const SizedBox(width: 80, child: Text('VA', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10))),
                  ],
                ),
                const SizedBox(height: 8),
                _buildRefractionRow('OD', _activeColor),
                const SizedBox(height: 12),
                _buildRefractionRow('OS', Colors.blue),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          const Text('FINAL GLASSES PRESCRIPTION', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _activeColor)),
          const SizedBox(height: 16),
          _buildResponsiveRow([
            _buildRxCard('Right Eye (OD)', _activeColor),
            _buildRxCard('Left Eye (OS)', Colors.blue),
          ]),
          const SizedBox(height: 24),
          SizedBox(width: isMobile ? double.infinity : 300, child: _buildDropdownField('LENS TYPE', 'Single Vision Distance')),
        ],
      ),
    );
  }

  Widget _buildRefractionRow(String eye, Color color) {
    return Row(
      children: [
        Container(
          width: 60, padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(border: Border.all(color: color.withValues(alpha: 0.3)), borderRadius: BorderRadius.circular(8)),
          child: Center(child: Text(eye, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14))),
        ),
        const SizedBox(width: 15),
        SizedBox(width: 80, child: TextFormField(textAlign: TextAlign.center, decoration: InputDecoration(hintText: '0.00', filled: true, fillColor: _fieldBgColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: const EdgeInsets.all(12)))),
        const SizedBox(width: 16),
        SizedBox(width: 80, child: TextFormField(textAlign: TextAlign.center, decoration: InputDecoration(hintText: '0.00', filled: true, fillColor: _fieldBgColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: const EdgeInsets.all(12)))),
        const SizedBox(width: 16),
        SizedBox(width: 80, child: TextFormField(textAlign: TextAlign.center, decoration: InputDecoration(hintText: '0°', filled: true, fillColor: _fieldBgColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: const EdgeInsets.all(12)))),
        const SizedBox(width: 16),
        SizedBox(width: 80, child: TextFormField(textAlign: TextAlign.center, decoration: InputDecoration(hintText: '6/6', filled: true, fillColor: _fieldBgColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: const EdgeInsets.all(12)))),
      ],
    );
  }

  Widget _buildRxCard(String title, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _fieldBgColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(Icons.circle, color: color, size: 10), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))]),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: 60, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('SPHERE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)), const SizedBox(height: 8), TextFormField(textAlign: TextAlign.center, decoration: InputDecoration(hintText: '0.00', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: const EdgeInsets.all(8)))])),
                const SizedBox(width: 8),
                SizedBox(width: 60, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('CYL', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)), const SizedBox(height: 8), TextFormField(textAlign: TextAlign.center, decoration: InputDecoration(hintText: '0.00', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: const EdgeInsets.all(8)))])),
                const SizedBox(width: 8),
                SizedBox(width: 60, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('AXIS', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)), const SizedBox(height: 8), TextFormField(textAlign: TextAlign.center, decoration: InputDecoration(hintText: '0°', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: const EdgeInsets.all(8)))])),
                const SizedBox(width: 8),
                SizedBox(width: 60, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('ADD', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)), const SizedBox(height: 8), TextFormField(textAlign: TextAlign.center, decoration: InputDecoration(hintText: '+0.00', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: const EdgeInsets.all(8)))])),
                const SizedBox(width: 8),
                SizedBox(width: 60, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('PD', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)), const SizedBox(height: 8), TextFormField(textAlign: TextAlign.center, decoration: InputDecoration(hintText: '32', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: const EdgeInsets.all(8)))])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep5() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(Icons.medical_services_outlined, 'IOP, Diagnosis & Treatment'),
          const Text('INTRAOCULAR PRESSURE (IOP)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _activeColor)),
          const SizedBox(height: 16),
          _buildResponsiveRow([
            _buildIopCard('Right Eye (OD)', _activeColor),
            _buildIopCard('Left Eye (OS)', Colors.blue),
          ]),
          const SizedBox(height: 32),
          const Text('CLINICAL FINDINGS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _activeColor)),
          const SizedBox(height: 16),
          _buildDropdownField('DIAGNOSIS', 'Select Diagnosis'),
          const SizedBox(height: 24),
          _buildResponsiveRow([
            _buildTextField('TREATMENT / MANAGEMENT PLAN', 'Recommended management plan...'),
            _buildTextField('REMARKS', 'Additional notes or observations...'),
          ])
        ],
      ),
    );
  }

  Widget _buildIopCard(String title, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _fieldBgColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(Icons.circle, color: color, size: 10), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))]),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('METHOD', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)), const SizedBox(height: 8), TextFormField(decoration: InputDecoration(hintText: 'e.g. NCT', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: const EdgeInsets.all(12)))])),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('IOP', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)), const SizedBox(height: 8), TextFormField(decoration: InputDecoration(hintText: 'e.g. 14', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: const EdgeInsets.all(12)))])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep6() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(Icons.badge_outlined, 'Examiner Details'),
          const Text('All examinations must be completed and authenticated by a qualified eye care professional.', style: TextStyle(color: Colors.blueGrey, fontSize: 12)),
          const SizedBox(height: 24),
          _buildResponsiveRow([
            _buildTextField('EXAMINED BY (FULL NAME)', 'Dr. / PMOA Full Name'),
            _buildTextField('DESIGNATION / QUALIFICATION', 'e.g. PMOA, Ophthalmologist'),
          ]),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: _fieldBgColor, borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: _activeColor),
                    const SizedBox(width: 12),
                    const Text('Ready to Submit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textColor)),
                  ],
                ),
                const SizedBox(height: 24),
                _buildResponsiveRow([
                  _buildSummaryItem('PATIENT', '-'),
                  _buildSummaryItem('AGE / GENDER', '- / -'),
                  _buildSummaryItem('DISTRICT', '-'),
                ]),
                const SizedBox(height: 16),
                _buildResponsiveRow([
                  _buildSummaryItem('DIAGNOSIS', '-'),
                  _buildSummaryItem('LENS TYPE', 'sv_distance', isBold: true),
                  _buildSummaryItem('EXAMINER', '-'),
                ]),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: _textColor)),
      ],
    );
  }
}
