import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:mess_app/core/models/food_model.dart';
import 'package:mess_app/core/models/officer_model.dart';
import 'package:mess_app/core/utils/app_enums.dart';
// import 'package:mess_app/features/dispensing_items/data/models/combo_meal_item_model.dart';
import 'package:mess_app/features/dispensing_items/data/models/dispensing_items_model.dart';
import 'package:mess_app/features/dispensing_items/domain/repositories/dispensing_items_repo.dart';

import '../../../../core/firebase/firebase_firestore_manager.dart';
import '../../data/data_source/dispensing_items_ds_impl.dart';
import '../../data/repositories/dispensing_items_repo_impl.dart';
part 'dispensing_item_state.dart';

class DispensingItemCubit extends Cubit<DispensingItemState> {
  ScrollController scrollController = ScrollController();
  ScrollController comboItemsScrollController = ScrollController();
  ScrollController officerScrollController = ScrollController();
  GlobalKey<FormState> addItemFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> addComboItemFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> officerFormKey = GlobalKey<FormState>();
  TextEditingController quantityController = TextEditingController();
  void changeDispensingItemsTabType(
    DispensingItemsTabType dispensingItemsTabType,
  ) async {
    if (dispensingItemsTabType == DispensingItemsTabType.isOfficer&&(state.officers??[]).isEmpty) {
      await getOfficers();
    }
    emit(
      state.copyWith(
        dispensingItemsTabType: dispensingItemsTabType,
        dispensingItemStatus: DispensingItemStatus.init,
      ),
    );
  }

  void selectFood(FoodModel? food) {
    emit(
      state.copyWith(
        selectedFood: food,
        dispensingItemStatus: DispensingItemStatus.init,
      ),
    );
  }

  void selectOfficer(OfficerModel? officer) {
    emit(
      state.copyWith(
        dispensingItemStatus: DispensingItemStatus.init,
        selectedOfficer: officer,
      ),
    );
  }

  void addNewItem() {
    emit(
      state.copyWith(
        dispensingItemStatus: DispensingItemStatus.init,
        selectedFood: state.selectedFood,
      ),
    );
    final items = List<DispensingItemsModel>.from(state.items ?? []);
    double totalPrice = 0;
    int index = 0;
    double quantity = double.tryParse(quantityController.text) ?? 0.0;
    if ((state.selectedFood?.quantity ?? 0) < quantity) {
      emit(
        state.copyWith(
          dispensingItemStatus: DispensingItemStatus.error,
          massage: "الكمية المصروفه أكبر من المتوفرة",
        ),
      );

      return;
    }
    while (index < (state.selectedFood?.prices.length ?? 0)) {
      if (quantity == state.selectedFood?.prices[index].quantity) {
        totalPrice +=
            (state.selectedFood?.prices[index].price ?? 0.0) * quantity;
        state.selectedFood?.prices.removeAt(index);
        state.selectedFood?.quantity -= quantity;
        break;
      } else if (quantity < state.selectedFood?.prices[index].quantity) {
        totalPrice +=
            (state.selectedFood?.prices[index].price ?? 0.0) * quantity;
        state.selectedFood?.prices[index].quantity -= quantity;
        state.selectedFood?.quantity -= quantity;
        break;
      } else {
        totalPrice +=
            (state.selectedFood?.prices[index].price ?? 0.0) * quantity;
        quantity = quantity - state.selectedFood?.prices[index].quantity;
        state.selectedFood?.prices.removeAt(index);
        state.selectedFood?.quantity -= quantity;
      }
    }
    items.add(
      DispensingItemsModel(
        food: state.selectedFood!,
        officerId: state.selectedOfficer?.id ?? "",
        id: state.selectedFood?.id ?? "",
        quantity: double.tryParse(quantityController.text) ?? 0.0,
        name: state.selectedFood?.name ?? "",
        totalPrice: totalPrice,
      ),
    );
    quantityController.clear();
    emit(state.copyWith(items: items, selectedFood: null));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void addOfficerToCombo() {
    emit(state.copyWith(dispensingItemStatus: DispensingItemStatus.init,selectedOfficer: state.selectedOfficer));
    List<OfficerModel> officers = List<OfficerModel>.from(state.selectedOfficers ?? []);
    officers.add(state.selectedOfficer!);
    emit(state.copyWith(selectedOfficers: officers,selectedOfficer: null));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        officerScrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void deleteItem(int index) {
    emit(
      state.copyWith(
        dispensingItemStatus: DispensingItemStatus.init,
        selectedFood: state.selectedFood,
      ),
    );
    final items = List<DispensingItemsModel>.from(state.items ?? []);
    items.removeAt(index);
    emit(state.copyWith(items: items));
  }
 void deleteOfficer(int index) {
    emit(
      state.copyWith(
        dispensingItemStatus: DispensingItemStatus.init,
        selectedFood: state.selectedFood,
        selectedOfficer: state.selectedOfficer
      ),
    );
    final officers = List<OfficerModel>.from(state.selectedOfficers ?? []);
    officers.removeAt(index);
    emit(state.copyWith(selectedOfficers: officers));
  }

  void getAvailableFood() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      emit(
        state.copyWith(
          dispensingItemStatus: DispensingItemStatus.getAvailableFoodsLoading,
        ),
      );
      DispensingItemsRepo repo = DispensingItemsRepoImpl(
        DispensingItemsDsImpl(FirebaseFirestoreManager()),
      );
      var result = await repo.getAvailableFoods();
      result.fold(
        (l) {
          emit(
            state.copyWith(
              dispensingItemStatus: DispensingItemStatus.getAvailableFoodsError,
              massage: l.error,
            ),
          );
        },
        (r) {
          emit(
            state.copyWith(
              dispensingItemStatus:
                  DispensingItemStatus.getAvailableFoodsSuccess,
              availableFoods: r,
            ),
          );
        },
      );
    });
  }

  void saveDispensingItems() async {
    emit(
      state.copyWith(
        dispensingItemStatus: DispensingItemStatus.saveDispensingItemsLoading,
      ),
    );
    DispensingItemsRepo repo = DispensingItemsRepoImpl(
      DispensingItemsDsImpl(FirebaseFirestoreManager()),
    );
    switch (state.dispensingItemsTabType ?? DispensingItemsTabType.init) {
      case DispensingItemsTabType.isCanteen:
        for (DispensingItemsModel item in state.items ?? []) {
          var addToCanteenResult = await repo.addDispensingItemsToCanteen(
            dispensingItems: item,
          );
          addToCanteenResult.fold((l) {
            emit(
              state.copyWith(
                dispensingItemStatus:
                    DispensingItemStatus.saveDispensingItemsError,
              ),
            );
          }, (r) {});
          var updateResult = await repo.updateFood(item.food);
          updateResult.fold((l) {
            emit(
              state.copyWith(
                dispensingItemStatus:
                    DispensingItemStatus.saveDispensingItemsError,
              ),
            );
          }, (r) {});
          if (state.dispensingItemStatus ==
              DispensingItemStatus.saveDispensingItemsError) {
            break;
          }
        }
      case DispensingItemsTabType.init:
      case DispensingItemsTabType.isHarmony:
        for (var item in state.items ?? []) {
          var result = await repo.addDispensingItemsToHarmony(
            dispensingItems: item,
          );
          var updateResult = await repo.updateFood(item.food);
          updateResult.fold((l) {
            emit(
              state.copyWith(
                dispensingItemStatus:
                    DispensingItemStatus.saveDispensingItemsError,
              ),
            );
          }, (r) {});
          result.fold((l) {
            emit(
              state.copyWith(
                dispensingItemStatus:
                    DispensingItemStatus.saveDispensingItemsError,
              ),
            );
          }, (r) {});
          if (state.dispensingItemStatus ==
              DispensingItemStatus.saveDispensingItemsError) {
            break;
          }
        }
      case DispensingItemsTabType.isHospitality:
        for (var item in state.items ?? []) {
          var result = await repo.addDispensingItemsToHospitality(
            dispensingItems: item,
          );
          var updateResult = await repo.updateFood(item.food);
          updateResult.fold((l) {
            emit(
              state.copyWith(
                dispensingItemStatus:
                    DispensingItemStatus.saveDispensingItemsError,
              ),
            );
          }, (r) {});
          result.fold((l) {
            emit(
              state.copyWith(
                dispensingItemStatus:
                    DispensingItemStatus.saveDispensingItemsError,
              ),
            );
          }, (r) {});
          if (state.dispensingItemStatus ==
              DispensingItemStatus.saveDispensingItemsError) {
            break;
          }
        }
      case DispensingItemsTabType.isOfficer:
        OfficerModel selectedOfficer = state.selectedOfficer!;
        num totalPrice = 0;
        for (DispensingItemsModel item in state.items ?? []) {
          item.officerId = state.selectedOfficer?.id ?? "";
          totalPrice += item.totalPrice;
          var result = await repo.addDispensingItemsToOfficer(
            dispensingItems: item,
          );
          var updateResult = await repo.updateFood(item.food);
          updateResult.fold((l) {
            emit(
              state.copyWith(
                dispensingItemStatus:
                    DispensingItemStatus.saveDispensingItemsError,
              ),
            );
          }, (r) {});
          result.fold((l) {
            emit(
              state.copyWith(
                dispensingItemStatus:
                    DispensingItemStatus.saveDispensingItemsError,
              ),
            );
          }, (r) {});
          if (state.dispensingItemStatus ==
              DispensingItemStatus.saveDispensingItemsError) {
            break;
          }
        }
        selectedOfficer.amount = selectedOfficer.amount - totalPrice;
        var result = await repo.updateOfficer(selectedOfficer);
        result.fold((l) {
          emit(
            state.copyWith(
              dispensingItemStatus:
                  DispensingItemStatus.saveDispensingItemsError,
            ),
          );
        }, (r) {});
    }
    if (state.dispensingItemStatus !=
        DispensingItemStatus.saveDispensingItemsError) {
      emit(
        state.copyWith(
          dispensingItemStatus: DispensingItemStatus.saveDispensingItemsSuccess,
          items: [],
          selectedFood: null,
        ),
      );
      getAvailableFood();
    }
  }
void saveComboMeal() async{
  emit(
    state.copyWith(
      dispensingItemStatus: DispensingItemStatus.saveDispensingItemsLoading,
    ),
  );
  DispensingItemsRepo repo = DispensingItemsRepoImpl(
    DispensingItemsDsImpl(FirebaseFirestoreManager()),
  );
  num totalPrice = 0;
  for (DispensingItemsModel item in state.items ?? []) {
    item.officerId = state.selectedOfficer?.id ?? "";
    totalPrice += item.totalPrice;
    var result = await repo.addDispensingItemsToOfficer(
      dispensingItems: item,
    );
    var updateResult = await repo.updateFood(item.food);
    updateResult.fold((l) {
      emit(
        state.copyWith(
          dispensingItemStatus:
          DispensingItemStatus.saveDispensingItemsError,
        ),
      );
    }, (r) {});
    result.fold((l) {
      emit(
        state.copyWith(
          dispensingItemStatus:
          DispensingItemStatus.saveDispensingItemsError,
        ),
      );
    }, (r) {});
    if (state.dispensingItemStatus ==
        DispensingItemStatus.saveDispensingItemsError) {
      break;
    }
  }
  totalPrice = totalPrice/state.selectedOfficers!.length;
  for(OfficerModel officer in state.selectedOfficers??[]){
    officer.amount = officer.amount - totalPrice;
    var result = await repo.updateOfficer(officer);
    result.fold((l) {
      emit(
        state.copyWith(
          dispensingItemStatus:
          DispensingItemStatus.saveDispensingItemsError,
        ),
      );
    }, (r) {});
  }
  if (state.dispensingItemStatus !=
      DispensingItemStatus.saveDispensingItemsError) {
    emit(
      state.copyWith(
        dispensingItemStatus: DispensingItemStatus.saveDispensingItemsSuccess,
        items: [],
        selectedOfficers: [],
        selectedFood: null,
      ),
    );
    getAvailableFood();
  }
}
  Future<void> getOfficers() async {
    emit(
      state.copyWith(
        dispensingItemStatus: DispensingItemStatus.getOfficersLoading,
      ),
    );
    DispensingItemsRepo repo = DispensingItemsRepoImpl(
      DispensingItemsDsImpl(FirebaseFirestoreManager()),
    );
    var result = await repo.getOfficers();
    result.fold(
      (l) {
        print('fffffffffffffffffffffffffffffffff');
        emit(
          state.copyWith(
            massage: l.error,
            dispensingItemStatus: DispensingItemStatus.getOfficersError,
          ),
        );
      },
      (r) {
        print('sssssssssssssssssssssssssssssss');

        emit(
          state.copyWith(
            dispensingItemStatus: DispensingItemStatus.getOfficersSuccess,
            officers: r,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    quantityController.dispose();
    scrollController.dispose();
    comboItemsScrollController.dispose();
    officerScrollController.dispose();
    return super.close();
  }

  DispensingItemCubit() : super(DispensingItemInitial()) {
    getAvailableFood();
  }
}
