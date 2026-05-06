import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apvision/core/models/patient_model.dart';

class EmrStateNotifier extends Notifier<Patient?> {
  @override
  Patient? build() => null;

  void selectPatient(Patient? patient) {
    state = patient;
  }

  void reset() {
    state = null;
  }
}

final emrStateProvider = NotifierProvider<EmrStateNotifier, Patient?>(() {
  return EmrStateNotifier();
});
