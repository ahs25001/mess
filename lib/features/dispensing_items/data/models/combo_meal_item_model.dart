import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mess_app/core/models/officer_model.dart';

import 'dispensing_items_model.dart';

class ComboMealItemModel {
  List<DispensingItemsModel> foods;
  List<OfficerModel> officers;
  String id;
  String name;
  Timestamp dateTime;
  num totalPrice;
  ComboMealItemModel({
    required this.foods,
    required this.officers,
    required this.id,
    required this.name,
    required this.dateTime,
    required this.totalPrice,
  });
  ComboMealItemModel.fromJson(Map<String, dynamic> json)
    : this(
        totalPrice: json['totalPrice'] as num,
        id: json['id'],
        name: json['name'],
        officers: json['officers']
            .map((e) => OfficerModel.fromJson(e))
            .toList(),
        dateTime: Timestamp.now(),
        foods: json['food'].map((e) => DispensingItemsModel.fromJson(e)).toList(),
      );
  Map <String ,dynamic> toJson ()=>{
    'id':id,
    'name':name,
    'dateTime':dateTime,
    'totalPrice':totalPrice,
    'foods':foods.map((e) => e.toJson()).toList(),
    'officers':officers.map((e) => e.toJson()).toList(),
  };
}
