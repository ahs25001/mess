import 'package:mess_app/core/models/price_model.dart';

class FoodModel {
  String name;
  double quantity;
  String id;
  List<dynamic> prices;
  bool isFixedMiscellaneousExpenses;
  bool isVariableMiscellaneousExpenses;

  FoodModel({
    required this.name,
    required this.quantity,
    required this.id,
    this.isFixedMiscellaneousExpenses = false,
    this.isVariableMiscellaneousExpenses = false,
    required this.prices,
  });
  FoodModel.fromJson(Map<String, dynamic> json)
    : this(
        name: json["name"],
        quantity: json["quantity"],
        id: json["id"],
        isFixedMiscellaneousExpenses: json["isFixedMiscellaneousExpenses"]??false,
        isVariableMiscellaneousExpenses:
            json["isVariableMiscellaneousExpenses"]??false,
        prices:  json["prices"]?.map((e) => PriceModel.fromJson(e)).toList() ?? [],
      );
  Map<String, dynamic> toJson() => {
    "name": name,
    "quantity": quantity,
    "isVariableMiscellaneousExpenses":isVariableMiscellaneousExpenses,
    "isFixedMiscellaneousExpenses":isFixedMiscellaneousExpenses,
    "id": id,
    "prices": prices.map((e) => e.toJson()).toList(),
  };
}
