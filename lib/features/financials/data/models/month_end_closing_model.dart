import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mess_app/core/models/officer_model.dart';

class MonthEndClosingModel {
  List<OfficerModel?> officers;
  num perishes;
  num variable;
  num fixed;
  num hospitality;
  num canteen;
  Timestamp? date;
  MonthEndClosingModel({
    required this.officers,
    required this.fixed,
    required this.hospitality,
    required this.canteen,
    this.date,
    required this.perishes,
    required this.variable,
  });
  MonthEndClosingModel.fromJson(Map<String, dynamic> json)
    : this(
        officers: json['officers']
            .map((e) => OfficerModel.fromJson(e))
            .toList(),
        fixed: json['fixed'],
        date: json['date'],
        perishes: json['perishes'],
        hospitality: json['hospitality'],
        canteen: json['canteen'],
        variable: json['variable'],
      );
  Map<String, dynamic> toJson() => {
    'officers': officers.map((e) => e?.toJson()).toList(),
    'fixed': fixed,
    'date': date,
    'perishes': perishes,
    'hospitality': hospitality,
    'canteen': canteen,
    'variable': variable,
  };
}
