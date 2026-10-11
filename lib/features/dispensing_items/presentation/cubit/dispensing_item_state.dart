part of 'dispensing_item_cubit.dart';

enum DispensingItemStatus {
  init,
  getOfficersLoading,
  getOfficersSuccess,
  getOfficersError,
  getAvailableFoodsLoading,
  getAvailableFoodsSuccess,
  getAvailableFoodsError,
}

class DispensingItemState {
  final DispensingItemStatus? dispensingItemStatus;
  final DispensingItemsTabType? dispensingItemsTabType;
  final List<OfficerModel>? officers;
  final List<FoodModel>? availableFoods;
  final FoodModel? selectedFood;
  final List<DispensingItemsModel>? items;
  final String? massage;
  const DispensingItemState({
    this.dispensingItemsTabType,
    this.items,
    this.dispensingItemStatus,
    this.selectedFood,
    this.officers,
    this.massage,
    this.availableFoods,
  });
  DispensingItemState copyWith({
    List<FoodModel>? availableFoods,
    List<DispensingItemsModel>? items,
    DispensingItemStatus? dispensingItemStatus,
    List<OfficerModel>? officers,
    DispensingItemsTabType? dispensingItemsTabType,
    String? massage,
    FoodModel? selectedFood,
  }) => DispensingItemState(
    items: items ?? this.items,
    selectedFood: selectedFood ?? this.selectedFood,
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
