import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apvision/core/models/patient_model.dart';

final patientProvider = NotifierProvider<PatientNotifier, List<Patient>>(() {
  return PatientNotifier();
});

class PatientNotifier extends Notifier<List<Patient>> {
  @override
  List<Patient> build() => _initialPatients;

  static final List<Patient> _initialPatients = [
    Patient(
      id: 'APV-A1B2C3',
      name: 'Ravi Kumar',
      age: 58,
      gender: 'Male',
      village: 'Tenali',
      phone: '9876543210',
      lastVisit: '2026-05-04',
      diagnosis: 'Cataract (OD)',
      status: 'Under Treatment',
      color: Colors.orange,
      visits: [
        ScreeningVisit(
          date: '2026-05-04',
          doctor: 'Dr. Suresh Babu',
          diagnosis: 'Cataract (OD)',
          iop: '16 / 14 mmHg',
          va: 'OD: 6/36  OS: 6/12',
          notes: 'Surgery scheduled for May 20. Patient counselled.',
          plan: 'Surgery Referral',
        ),
      ],
    ),
    Patient(
      id: 'APV-D4E5F6',
      name: 'Lakshmi Devi',
      age: 45,
      gender: 'Female',
      village: 'Bapatla',
      phone: '9988776655',
      lastVisit: '2026-05-03',
      diagnosis: 'Myopia',
      status: 'Spectacles Dispensed',
      color: Colors.green,
      visits: [
        ScreeningVisit(
          date: '2026-05-03',
          doctor: 'Dr. Kavitha Rao',
          diagnosis: 'Myopia',
          iop: '13 / 13 mmHg',
          va: 'OD: 6/24  OS: 6/18',
          notes: 'Spectacles dispensed. Review in 6 months.',
          plan: 'Spectacles dispensed',
        ),
      ],
    ),
  ];

  void addPatient(Patient patient) {
    state = [...state, patient];
  }

  void updatePatientScreening(String patientId, ScreeningVisit visit) {
    state = [
      for (final p in state)
        if (p.id == patientId || p.name == patientId)
          p.copyWith(
            lastVisit: visit.date,
            diagnosis: visit.diagnosis,
            status: 'Screened',
            visits: [visit, ...p.visits],
          )
        else
          p
    ];
  }
}
