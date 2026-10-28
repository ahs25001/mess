enum HeroTags {
  addNewInvoice("add_new_invoice"),
  addNewOfficer("addNewOfficer"),
  financials("financials"),
  invoices("invoices"),
  disburse("disburse");

  final String value;
  const HeroTags(this.value);
}

enum SharedPreferencesKeys {
  battalionName('BattalionName'),
  capital("Capital"),
  hospitalityBalance('HospitalityBalance'),
  canteenBalance('CanteenBalance');

  final String value;
  const SharedPreferencesKeys(this.value);
}

enum DispensingItemsTabType {
  init,
  isCanteen,
  isHarmony,
  isHospitality,
  isOfficer,
}

enum HomeStatus {
  init,
  setCapitalLoading,
  setCapitalSuccess,
  setCapitalFailure,
  getFoodLoading,
  getFoodSuccess,
  getFoodFailure,
}

enum AddNewInvoiceStatus {
  initial,
  addInvoiceLoading,
  addInvoiceSuccess,
  addInvoiceFailure,
  addFoodLoading,
  addFoodSuccess,
  addFoodFailure,
  getFoodLoading,
  getFoodSuccess,
  getFoodFailure,
}

enum AddNewOfficerStateStatus { initial, loading, success, failure }

enum DispensingItemStatus {
  init,
  success,
  error,
  getOfficersLoading,
  getOfficersSuccess,
  getOfficersError,
  getAvailableFoodsLoading,
  getAvailableFoodsSuccess,
  getAvailableFoodsError,
  saveDispensingItemsLoading,
  saveDispensingItemsSuccess,
  saveDispensingItemsError,
}

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
  getInvoicesLoading,
  getInvoicesSuccess,
  getInvoicesFailure,
  getPerishesLoading,
  getPerishesSuccess,
  getPerishesFailure,
  createMonthEndClosingLoading,
  createMonthEndClosingSuccess,
  createMonthEndClosingFailure,
  saveMonthEndClosingLoading,
  saveMonthEndClosingSuccess,
  saveMonthEndClosingFailure,
  getCanteenLoading,
  getCanteenSuccess,
  getCanteenFailure,
  getHospitalityLoading,
  getHospitalitySuccess,
  getHospitalityFailure,
}

enum InvoicesStatus { init, loading, success, failure }
