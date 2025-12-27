import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AgreementState {
  final bool term0;
  final bool term1;
  final bool term2;
  final bool term3;
  final bool isLoading; // Add this

  const AgreementState({
    this.term0 = false,
    this.term1 = false,
    this.term2 = false,
    this.term3 = false,
    this.isLoading = false,
  });

  bool get allRequiredAccepted => term1 && term2;

  //bool get term0 => false;

  AgreementState copyWith({
    bool? term0,
    bool? term1,
    bool? term2,
    bool? term3,
    bool? isLoading,
  }) {
    return AgreementState(
      term0: term0 ?? this.term0,
      term1: term1 ?? this.term1,
      term2: term2 ?? this.term2,
      term3: term3 ?? this.term3,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AgreementNotifier extends StateNotifier<AgreementState> {
  AgreementNotifier() : super(const AgreementState());

  void toggleTerm0(bool v) => state = state.copyWith(term0: v);
  void toggleTerm1(bool v) => state = state.copyWith(term1: v);

  void toggleTerm2(bool v) => state = state.copyWith(term2: v);
  void toggleTerm3(bool v) => state = state.copyWith(term3: v);

  void toggleAll(bool v) {
    state = AgreementState(term1: v, term2: v, term3: v);
  }

  // New method to handle "Next" logic
  // Future<void> completeAgreements(VoidCallback onSuccess) async {
  //   state = state.copyWith(isLoading: true);
  //   await Future.delayed(
  //     const Duration(milliseconds: 800),
  //   ); // Brief delay for UX
  //   state = state.copyWith(isLoading: false);
  //   onSuccess();
  // }
  Future<void> submit(VoidCallback onSuccess) async {
    // 1. Start loading
    state = state.copyWith(isLoading: true);

    // 2. Small delay to let the UI show the spinner and prevent "jank"
    await Future.delayed(const Duration(milliseconds: 300));

    // 3. Stop loading and navigate
    state = state.copyWith(isLoading: false);
    onSuccess();
  }
}

final agreementProvider =
    StateNotifierProvider<AgreementNotifier, AgreementState>(
      (ref) => AgreementNotifier(),
    );
