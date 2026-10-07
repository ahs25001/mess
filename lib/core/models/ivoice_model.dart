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
  Map<String,dynamic>toJson()=>{
    "id":id,
    "date":date,
    "total":total,
    "representativeName":representativeName,
    "items":items.map((e) => e.toJson()).toList(),
  };
}
