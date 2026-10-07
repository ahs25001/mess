import 'package:mess_app/core/models/food_model.dart';

class InvoiceItemModel {
  FoodModel? food;
  double quantity;
  double price;
  String id;

  InvoiceItemModel({
    required this.food,
    required this.quantity,
   required this.id ,
    required this.price,
  });
  Map<String,dynamic>toJson()=>{
    "foodName":food?.toJson(),
    "quantity":quantity,
    "price":price,
    "id":id
  };
}
