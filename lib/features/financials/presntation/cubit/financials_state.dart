part of 'financials_cubit.dart';

enum FinancialsStatus {
  initial,
  addMoneyLoading,
  addMoneySuccess,
  addMoneyFailure,
  getOfficersLoading,
  getOfficersSuccess,
  getOfficersFailure,
}

class FinancialsState {
  String? errorMessage;
  List<OfficerModel>? officers;
  FinancialsStatus? status;
  OfficerModel? selectedOfficer;
  FinancialsState({
    this.status,
    this.errorMessage,
    this.officers,
    this.selectedOfficer,
  });
  FinancialsState copyWith({
    OfficerModel? selectedOfficer,
    String? errorMessage,
    List<OfficerModel>? officers,
    FinancialsStatus? status,
  }) => FinancialsState(
    officers: officers ?? this.officers,
    selectedOfficer: selectedOfficer ?? this.selectedOfficer,
    errorMessage: errorMessage ?? this.errorMessage,
    status: status ?? this.status,
  );
}

final class FinancialsInitial extends FinancialsState {}
