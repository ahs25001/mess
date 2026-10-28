import 'package:cloud_firestore/cloud_firestore.dart';
import 'invoice_item_model.dart';

class InvoiceModel {
  List<InvoiceItemModel> items;
  String id;
  DateTime date;
  double total;
  String representativeName;

  InvoiceModel({
    required this.items,
    required this.id,
    required this.date,
    required this.total,
    required this.representativeName,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": Timestamp.fromDate(date),
        "total": total,
        "representativeName": representativeName,
        "items": items.map((e) => e.toJson()).toList(),
      };

  InvoiceModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] ?? '',
          items: (json['items'] as List<dynamic>?)
                  ?.map<InvoiceItemModel>(
                      (e) => InvoiceItemModel.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              <InvoiceItemModel>[],
          date: json['date'] is Timestamp
              ? (json['date'] as Timestamp).toDate()
              : (json['date'] is String
                  ? DateTime.tryParse(json['date']) ?? DateTime.now()
                  : DateTime.now()),
          total: (json['total'] as num?)?.toDouble() ?? 0.0,
          representativeName: json['representativeName'] ?? '',
        );
}
