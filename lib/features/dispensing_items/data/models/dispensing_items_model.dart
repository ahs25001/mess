import 'package:mess_app/core/models/food_model.dart';
import 'package:mess_app/core/models/price_model.dart';

class DispensingItemsModel {
  final double quantity;
  final String name;
   String id;
  final double totalPrice;
   String officerId;
   FoodModel food;
  // final List<dynamic>prices;

   DispensingItemsModel({
    required this.officerId,
    required this.quantity,
    required this.name,
     required this.food,
    // required this.prices,
    required this.totalPrice,
    required this.id,
  });

  DispensingItemsModel.fromJson(Map<String, dynamic> json)
      : this(
    officerId: json['officerId'] ?? '',
    food: FoodModel.fromJson(json['food']),
    name: json['name'] ?? '',
    // prices: (json['prices'] as List)
    //     .map((e) => PriceModel.fromJson(e))
    //     .toList(),
    id: json['id'] ?? '',
    quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
    totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
  );

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "id": id,
      "food": food.toJson(),
      "officerId": officerId,
      // "prices": prices.map((e) => e.toJson()).toList(),
      "quantity": quantity,
      "totalPrice": totalPrice,
    };
  }
}
