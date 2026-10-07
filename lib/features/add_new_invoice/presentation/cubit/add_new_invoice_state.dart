part of 'add_new_invoice_cubit.dart';

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

class AddNewInvoiceState {
  AddNewInvoiceStatus? status;
  String? errorMessage;
  List<InvoiceItemModel>? items;
  List<FoodModel>? availableItems;
  FoodModel? selectedFood;
  bool? newFoodIsVariableMiscellaneousExpenses;
  bool? newFoodIsFixedMiscellaneousExpenses;
  AddNewInvoiceState({
    this.status,
    this.errorMessage,
    this.items,
    this.availableItems,
    this.selectedFood,
    this.newFoodIsFixedMiscellaneousExpenses = false,
    this.newFoodIsVariableMiscellaneousExpenses = false,
  });
  AddNewInvoiceState copyWith({
    AddNewInvoiceStatus? status,
    List<FoodModel>? availableItems,
    String? errorMessage,
    bool? newFoodIsVariableMiscellaneousExpenses,
    bool? newFoodIsFixedMiscellaneousExpenses,
    FoodModel? selectedFood,
    List<InvoiceItemModel>? items,
  }) => AddNewInvoiceState(
    newFoodIsFixedMiscellaneousExpenses:
        newFoodIsFixedMiscellaneousExpenses ??
        this.newFoodIsFixedMiscellaneousExpenses,
    newFoodIsVariableMiscellaneousExpenses:
        newFoodIsVariableMiscellaneousExpenses ??
        this.newFoodIsVariableMiscellaneousExpenses,
    selectedFood: selectedFood,
    availableItems: availableItems ?? this.availableItems,
    errorMessage: errorMessage ?? this.errorMessage,
    items: items ?? this.items,
    status: status ?? this.status,
  );
}

final class AddNewInvoiceInitial extends AddNewInvoiceState {
  AddNewInvoiceInitial()
    : super(status: AddNewInvoiceStatus.initial, items: [], availableItems: []);
}
