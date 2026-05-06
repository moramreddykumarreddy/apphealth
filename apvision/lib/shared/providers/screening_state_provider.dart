import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScreeningState {
  final String? selectedPatient;
  final int currentStep;

  ScreeningState({this.selectedPatient, this.currentStep = 0});

  ScreeningState copyWith({String? selectedPatient, int? currentStep, bool clearSelection = false}) {
    return ScreeningState(
      selectedPatient: clearSelection ? null : (selectedPatient ?? this.selectedPatient),
      currentStep: currentStep ?? this.currentStep,
    );
  }
}

class ScreeningStateNotifier extends Notifier<ScreeningState> {
  @override
  ScreeningState build() => ScreeningState();

  void selectPatient(String? patient) {
    state = state.copyWith(selectedPatient: patient, currentStep: 0);
  }

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void reset() {
    state = ScreeningState();
  }
}

final screeningStateProvider = NotifierProvider<ScreeningStateNotifier, ScreeningState>(() {
  return ScreeningStateNotifier();
});
