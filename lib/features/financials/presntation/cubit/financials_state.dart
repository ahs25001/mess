part of 'financials_cubit.dart';

enum FinancialsStatus {
  initial,
  addMoneyLoading,
  addMoneySuccess,
  addMoneyFailure,
  getOfficersLoading,
  getOfficersSuccess,
  getOfficersFailure,
  getCapitalLoading,
  getCapitalSuccess,
  getCapitalFailure,
}

class FinancialsState {
  String? errorMessage;
  List<OfficerModel>? officers;
  FinancialsStatus? status;
  OfficerModel? selectedOfficer;
  num ? capital;
  FinancialsState({
    this.status,
    this.errorMessage,
    this.capital,
    this.officers,
    this.selectedOfficer,
  });
  FinancialsState copyWith({
    OfficerModel? selectedOfficer,
    num? capital,
    String? errorMessage,
    List<OfficerModel>? officers,
    FinancialsStatus? status,
  }) => FinancialsState(
    officers: officers ?? this.officers,
    capital: capital??this.capital,
    selectedOfficer: selectedOfficer ?? this.selectedOfficer,
    errorMessage: errorMessage ?? this.errorMessage,
    status: status ?? this.status,
  );
}

final class FinancialsInitial extends FinancialsState {}
