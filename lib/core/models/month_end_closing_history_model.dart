import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mess_app/core/models/month_end_closing_hospitality_model.dart';
import 'package:mess_app/core/models/month_end_closing_officer_model.dart';

class MonthEndClosingHistoryModel {
  String id ;
  List<MonthEndClosingOfficerModel> officers;
  Timestamp date;
  num canteenBalance;
  MonthEndClosingHospitalityModel monthEndClosingHospitalityModel;

  MonthEndClosingHistoryModel({
    required this.officers,
    this.id='',
    required this.date,
    required this.canteenBalance,
    required this.monthEndClosingHospitalityModel,
  });

  MonthEndClosingHistoryModel.fromJson(Map<String, dynamic> json)
      : this(
          officers: (json['officers'] as List<dynamic>?)
                  ?.map((e) => MonthEndClosingOfficerModel.fromJson(
                      e as Map<String, dynamic>))
                  .toList() ??
              [],
          date: json['date'] is Timestamp
              ? json['date'] as Timestamp
              : Timestamp.now(),
    canteenBalance: (json['canteenBalance'] as num?) ?? 0,
          monthEndClosingHospitalityModel:
              json['monthEndClosingHospitalityModel'] != null
                  ? MonthEndClosingHospitalityModel.fromJson(
                      json['monthEndClosingHospitalityModel']
                          as Map<String, dynamic>)
                  : MonthEndClosingHospitalityModel(
                      fixed: 0,
                      consumer: 0,
                      total: 0,
                    ),
        );

  Map<String, dynamic> toJson() => {
        'officers': officers.map((e) => e.toJson()).toList(),
        'date': date,
        'canteenBalance': canteenBalance,
        'monthEndClosingHospitalityModel':
            monthEndClosingHospitalityModel.toJson(),
      };
}
