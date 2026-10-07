import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mess_app/core/firebase/firebase_firestore_manager.dart';
import 'package:mess_app/features/add_new_invoice/data/data_source/add_invoice_ds_impl.dart';
import 'package:mess_app/features/add_new_invoice/data/repositories/add_invoice_repository_impl.dart';
import 'package:mess_app/features/add_new_invoice/domain/repositories/add_invoice_repository.dart';

import '../../../../core/models/food_model.dart';
import '../../../../core/models/invoice_item_model.dart';
import '../../../../core/models/ivoice_model.dart';
import '../../../../core/models/price_model.dart';

part 'add_new_invoice_state.dart';

class AddNewInvoiceCubit extends Cubit<AddNewInvoiceState> {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController representativeNameController =
      TextEditingController();
  final TextEditingController newFoodNameController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AddNewInvoiceCubit() : super(AddNewInvoiceInitial()) {
    getFood();
  }
  void selectFood(FoodModel? food) {
    emit(
      state.copyWith(selectedFood: food, status: AddNewInvoiceStatus.initial),
    );
  }

  void addNewItem() {
    emit(
      state.copyWith(
        status: AddNewInvoiceStatus.initial,
        selectedFood: state.selectedFood,
      ),
    );
    final items = List<InvoiceItemModel>.from(state.items ?? []);
    items.add(
      InvoiceItemModel(
        id: state.selectedFood?.id ?? "",
        food: state.selectedFood,
        quantity: double.tryParse(quantityController.text) ?? 0.0,
        price: double.tryParse(priceController.text) ?? 0.0,
      ),
    );

    priceController.clear();
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
        status: AddNewInvoiceStatus.initial,
        selectedFood: state.selectedFood,
      ),
    );
    final items = List<InvoiceItemModel>.from(state.items ?? []);
    items.removeAt(index);
    emit(state.copyWith(items: items));
  }

  void addInvoice() async {
    emit(state.copyWith(status: AddNewInvoiceStatus.addInvoiceLoading));
    List<InvoiceItemModel> items = List<InvoiceItemModel>.from(
      state.items ?? [],
    );
    double total = 0;
    for (var item in items) {
      total += item.price;
    }
    AddInvoiceRepository repo = AddInvoiceRepositoryImpl(
      addInvoiceDS: AddInvoiceDSImpl(
        firebaseFirestoreManager: FirebaseFirestoreManager(),
      ),
    );
    for (var item in items) {
      //todo update food quantity and price
      List<PriceModel> prices = List<PriceModel>.from(item.food?.prices ?? []);
      print("prices : $prices");
      print("food : ${item.food?.prices}");
      prices.add(
        PriceModel(
          price:
              ((item.food?.isFixedMiscellaneousExpenses ?? false) ||
                  (item.food?.isVariableMiscellaneousExpenses ?? false))
              ? item.price
              : (item.price) / item.quantity,
          quantity: item.quantity,
          foodId: item.food?.id ?? "",
          date: Timestamp.now(),
        ),
      );
      var updateFoodResult = await repo.upDateFood(
        food: FoodModel(
          isFixedMiscellaneousExpenses: item.food?.isFixedMiscellaneousExpenses ?? false,
          isVariableMiscellaneousExpenses: item.food?.isVariableMiscellaneousExpenses ?? false,
          name: item.food?.name ?? "",
          quantity: (item.food?.quantity ?? 0) + item.quantity,
          id: item.food?.id ?? "",
          prices: prices,
        ),
      );
      updateFoodResult.fold((l) {
        emit(state.copyWith(status: AddNewInvoiceStatus.addInvoiceFailure));
      }, (r) {});
    }
    InvoiceModel invoiceModel = InvoiceModel(
      representativeName: representativeNameController.text,
      id: "",
      date: DateTime.now(),
      total: total,
      items: items,
    );

    var addInvoiceResult = await repo.addNewInvoice(invoice: invoiceModel);
    addInvoiceResult.fold(
      (error) {
        emit(
          state.copyWith(
            status: AddNewInvoiceStatus.addInvoiceFailure,
            errorMessage: error.error,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            status: AddNewInvoiceStatus.addInvoiceSuccess,
            items: [],
          ),
        );
      },
    );
  }

  void saveNewFood() async {
    emit(state.copyWith(status: AddNewInvoiceStatus.addFoodLoading));
    AddInvoiceRepository repo = AddInvoiceRepositoryImpl(
      addInvoiceDS: AddInvoiceDSImpl(
        firebaseFirestoreManager: FirebaseFirestoreManager(),
      ),
    );
    FoodModel foodModel = FoodModel(
      name: newFoodNameController.text,
      quantity: 0,
      id: "",
      isFixedMiscellaneousExpenses:
          state.newFoodIsFixedMiscellaneousExpenses ?? false,
      isVariableMiscellaneousExpenses:
          state.newFoodIsVariableMiscellaneousExpenses ?? false,
      prices: [],
    );
    var result = await repo.addNewFood(food: foodModel);
    result.fold(
      (error) {
        emit(
          state.copyWith(
            status: AddNewInvoiceStatus.addFoodFailure,
            errorMessage: error.error,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            status: AddNewInvoiceStatus.addFoodSuccess,
            items: [],
            newFoodIsFixedMiscellaneousExpenses: false,
            newFoodIsVariableMiscellaneousExpenses: false,
          ),
        );
        newFoodNameController.clear();
      },
    );
  }

  void changeVariableMiscellaneousExpenses(bool value) {
    emit(
      state.copyWith(
        newFoodIsVariableMiscellaneousExpenses: value,
        newFoodIsFixedMiscellaneousExpenses: false,
      ),
    );
  }

  void changeFixedMiscellaneousExpenses(bool value) {
    emit(
      state.copyWith(
        newFoodIsFixedMiscellaneousExpenses: value,
        newFoodIsVariableMiscellaneousExpenses: false,
      ),
    );
  }

  void getFood() {
    var repo = AddInvoiceRepositoryImpl(
      addInvoiceDS: AddInvoiceDSImpl(
        firebaseFirestoreManager: FirebaseFirestoreManager(),
      ),
    );
    var result = repo.getFood();
    result.fold(
      (l) {
        l.listen((event) {
          var food = event.docs
              .map((e) => FoodModel.fromJson(e.data()))
              .toList();
          emit(
            state.copyWith(
              availableItems: food,
              status: AddNewInvoiceStatus.initial,
            ),
          );
        });
      },
      (r) {
        emit(
          state.copyWith(
            status: AddNewInvoiceStatus.getFoodFailure,
            errorMessage: r.error,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    quantityController.dispose();
    priceController.dispose();
    scrollController.dispose();
    return super.close();
  }
}
