part of 'dispensing_item_cubit.dart';

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

class DispensingItemState {
  final DispensingItemStatus? dispensingItemStatus;
  final DispensingItemsTabType? dispensingItemsTabType;
  final List<OfficerModel>? officers;
  final List<OfficerModel>? selectedOfficers;
  final List<FoodModel>? availableFoods;
  final FoodModel? selectedFood;
  final List<DispensingItemsModel>? items;
  final String? massage;
  final OfficerModel? selectedOfficer;
  // final List<ComboMealItemModel>?comboMealItems;
  const DispensingItemState({
    this.dispensingItemsTabType,
    // this.comboMealItems,
    this.selectedOfficers,
    this.selectedOfficer,
    this.items,
    this.dispensingItemStatus,
    this.selectedFood,
    this.officers,
    this.massage,
    this.availableFoods,
  });
  DispensingItemState copyWith({
    // List<ComboMealItemModel>? comboMealItems,
    OfficerModel? selectedOfficer,
    List<OfficerModel>? selectedOfficers,
    List<FoodModel>? availableFoods,
    List<DispensingItemsModel>? items,
    DispensingItemStatus? dispensingItemStatus,
    List<OfficerModel>? officers,
    DispensingItemsTabType? dispensingItemsTabType,
    String? massage,
    FoodModel? selectedFood,
  }) => DispensingItemState(
    items: items ?? this.items,
    selectedOfficers: selectedOfficers ?? this.selectedOfficers,
    selectedOfficer: selectedOfficer??this.selectedOfficer ,
    selectedFood: selectedFood,
    availableFoods: availableFoods ?? this.availableFoods,
    officers: officers ?? this.officers,
    massage: massage ?? this.massage,
    dispensingItemsTabType:
        dispensingItemsTabType ?? this.dispensingItemsTabType,
    dispensingItemStatus: dispensingItemStatus ?? this.dispensingItemStatus,
  );
}

final class DispensingItemInitial extends DispensingItemState {
  DispensingItemInitial()
    : super(
        dispensingItemStatus: DispensingItemStatus.init,
        dispensingItemsTabType: DispensingItemsTabType.init,
      );
}
