import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:mess_app/core/models/food_model.dart';
import 'package:mess_app/core/models/officer_model.dart';
import 'package:mess_app/core/utils/app_enums.dart';
import 'package:mess_app/features/dispensing_items/data/models/dispensing_items_model.dart';
import 'package:mess_app/features/dispensing_items/domain/repositories/dispensing_items_repo.dart';

import '../../../../core/firebase/firebase_firestore_manager.dart';
import '../../data/data_source/dispensing_items_ds_impl.dart';
import '../../data/repositories/dispensing_items_repo_impl.dart';
part 'dispensing_item_state.dart';

class DispensingItemCubit extends Cubit<DispensingItemState> {
  ScrollController scrollController = ScrollController();
  TextEditingController quantityController = TextEditingController();
  void changeDispensingItemsTabType(
    DispensingItemsTabType dispensingItemsTabType,
  ) async {
    if (dispensingItemsTabType == DispensingItemsTabType.isOfficer) {
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
    while (index < (state.selectedFood?.prices.length ?? 0)) {
      if (quantity == state.selectedFood?.prices[index].quantity) {
        totalPrice +=
            (state.selectedFood?.prices[index].price ?? 0.0) * quantity;
        state.selectedFood?.prices.removeAt(index);
        break;
      } else if (quantity < state.selectedFood?.prices[index].quantity) {
        totalPrice +=
            (state.selectedFood?.prices[index].price ?? 0.0) * quantity;
        state.selectedFood?.prices[index].quantity -= quantity;
        break;
      } else {
        totalPrice +=
            (state.selectedFood?.prices[index].price ?? 0.0) * quantity;
        quantity = quantity - state.selectedFood?.prices[index].quantity;
        state.selectedFood?.prices.removeAt(index);
        index++;
      }
    }
    items.add(
      DispensingItemsModel(
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

  void getAvailableFood() async {
    WidgetsBinding.instance.addPostFrameCallback((_)async{
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
              dispensingItemStatus: DispensingItemStatus.getAvailableFoodsSuccess,
              availableFoods: r,
            ),
          );
        },
      );
    });

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
      (l) => emit(
        state.copyWith(
          massage: l.error,
          dispensingItemStatus: DispensingItemStatus.getOfficersError,
        ),
      ),
      (r) => emit(
        state.copyWith(
          dispensingItemStatus: DispensingItemStatus.getOfficersSuccess,
          officers: r,
        ),
      ),
    );
  }
  DispensingItemCubit() : super(DispensingItemInitial()){
    getAvailableFood();
  }
}
