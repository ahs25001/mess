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
  num? hospitalityBalance;
  num? canteenBalance;
  num? invoicesBalance;
  num? officersBalance;
  num? totalOfficersAmount;
  num? totalConsumerAmount;
  AddMoneyMode? addMoneyMode;
  FinancialsState({
    this.status,
    this.monthEndClosing,
    this.addMoneyMode,
    this.officersBalance,
    this.hospitalityBalance,
    this.totalOfficersAmount,
    this.totalConsumerAmount,
    this.canteenBalance,
    this.invoicesBalance,
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
    num? hospitalityBalance,
    num? officersBalance,
    num? totalOfficersAmount,
    num? totalConsumerAmount,
    num? canteenBalance,
    num? invoicesBalance,
    AddMoneyMode? addMoneyMode,
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
    totalOfficersAmount: totalOfficersAmount ?? this.totalOfficersAmount,
    totalConsumerAmount: totalConsumerAmount ?? this.totalConsumerAmount,
    addMoneyMode: addMoneyMode ?? this.addMoneyMode,
    canteenBalance: canteenBalance??this.canteenBalance,
    officersBalance: officersBalance??this.officersBalance,
    hospitalityBalance: hospitalityBalance??this.hospitalityBalance,
    invoicesBalance: invoicesBalance??this.invoicesBalance,
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

final class FinancialsInitial extends FinancialsState {
   FinancialsInitial(): super(status: FinancialsStatus.initial,addMoneyMode: AddMoneyMode.init);
}
