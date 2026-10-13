enum HeroTags {
  addNewInvoice("add_new_invoice"),
  addNewOfficer("addNewOfficer"),
  financials("financials"),
  disburse("disburse");

  final String value;
  const HeroTags(this.value);
}

enum SharedPreferencesKeys {
  battalionName('BattalionName'),
  capital("Capital");

  final String value;
  const SharedPreferencesKeys(this.value);
}

enum DispensingItemsTabType { init ,isCanteen, isHarmony, isHospitality,isOfficer }

enum HomeStatus {
  init,
  setCapitalLoading,
  setCapitalSuccess,
  setCapitalFailure,
}
