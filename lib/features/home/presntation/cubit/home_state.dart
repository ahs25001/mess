part of 'home_cubit.dart';

class HomeState {
  HomeStatus? status;
  int? currentIndex;
  String? errorMessage;
  List<FoodModel?>? food;
  String? selectedRank;
  List<OfficerModel?>?officers;
  OfficerModel? selectedOfficer;
  bool? isOfficerActive;
  num?capital;
  List<DispensingItemsModel?>? officerItems;
  HomeState({
    this.status,
    this.currentIndex,
    this.capital,
    this.selectedOfficer,
    this.isOfficerActive,
    this.errorMessage,
    this.officers,
    this.selectedRank,
    this.officerItems,
    this.food,
  });
  HomeState copyWith({
    HomeStatus? status,
    num ?capital,
    String? selectedRank,
    bool? isOfficerActive,
    String? errorMessage,
    OfficerModel? selectedOfficer,
    List<OfficerModel?>? officers,
    List<DispensingItemsModel>?officerItems,
    int? currentIndex,
    List<FoodModel?>? food,
  }) => HomeState(
    status: status ?? this.status,
    officerItems: officerItems ?? this.officerItems,
    food: food ?? this.food,
    isOfficerActive: isOfficerActive ?? this.isOfficerActive,
    selectedOfficer: selectedOfficer ?? this.selectedOfficer,
    officers: officers ?? this.officers,
    selectedRank: selectedRank ?? this.selectedRank,
    capital: capital ?? this.capital,
    errorMessage: errorMessage ?? this.errorMessage,
    currentIndex: currentIndex ?? this.currentIndex,
  );
}

final class HomeInitial extends HomeState {
  HomeInitial() : super(status: HomeStatus.init, currentIndex: 0);
}
