import 'package:cloud_firestore/cloud_firestore.dart';

class PriceModel {
  double price;
  Timestamp date;
  String foodId;
  double quantity;
  PriceModel.fromJson(Map<String, dynamic> json)
    : this(
        date: json["date"]??Timestamp.now(),
        foodId: json["foodId"]??"",
        price: json["price"]??0,
        quantity: json["quantity"]??0,
      );
  PriceModel({
    required this.price,
    required this.date,
    required this.foodId,
    required this.quantity,
  });
  Map<String, dynamic> toJson() => {
    "price": price,
    "date": date,
    "foodId": foodId,
    "quantity": quantity,
  };
}
