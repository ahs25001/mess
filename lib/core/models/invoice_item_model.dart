import 'package:mess_app/core/models/food_model.dart';

class InvoiceItemModel {
  FoodModel? food;
  double quantity;
  double price;
  String id;

  InvoiceItemModel({
    required this.food,
    required this.quantity,
    required this.id,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        "food": food?.toJson(),
        "quantity": quantity,
        "price": price,
        "id": id,
      };

  InvoiceItemModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] ?? '',
          quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
          price: (json['price'] as num?)?.toDouble() ?? 0.0,
          food: json['food'] != null
              ? FoodModel.fromJson(json['food'] as Map<String, dynamic>)
              : (json['foodName'] != null && json['foodName'] is Map<String, dynamic>
                  ? FoodModel.fromJson(json['foodName'] as Map<String, dynamic>)
                  : null),
        );
}
