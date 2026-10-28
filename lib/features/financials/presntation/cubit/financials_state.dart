part of 'financials_cubit.dart';

class FinancialsState {
  String? errorMessage;
  List<OfficerModel>? officers;
  List<InvoiceModel>? invoices;
  MonthEndClosingModel? monthEndClosing;
  List<DispensingItemsModel>? perishes;
  FinancialsStatus? status;
  List<DispensingItemsModel>?hospitality;
  List<DispensingItemsModel>?canteen;
  OfficerModel? selectedOfficer;
  num? capital;
  FinancialsState({
    this.status,
    this.monthEndClosing,
    this.hospitality,
    this.canteen,
    this.perishes,
    this.errorMessage,
    this.invoices,
    this.capital,
    this.officers,
    this.selectedOfficer,
  });
  FinancialsState copyWith({
    List<DispensingItemsModel> ?hospitality,
    List<DispensingItemsModel> ?canteen,
    OfficerModel? selectedOfficer,
    MonthEndClosingModel? monthEndClosing,
    List<InvoiceModel>? invoices,
    List<DispensingItemsModel>? perishes,
    num? capital,
    String? errorMessage,
    List<OfficerModel>? officers,
    FinancialsStatus? status,
  }) => FinancialsState(
    officers: officers ?? this.officers,
    hospitality: hospitality??this.hospitality,
    canteen: canteen??this.canteen,
    perishes: perishes ?? this.perishes,
    monthEndClosing: monthEndClosing ?? this.monthEndClosing,
    invoices: invoices ?? this.invoices,
    capital: capital ?? this.capital,
    selectedOfficer: selectedOfficer ?? this.selectedOfficer,
    errorMessage: errorMessage ?? this.errorMessage,
    status: status ?? this.status,
  );
}

final class FinancialsInitial extends FinancialsState {}
