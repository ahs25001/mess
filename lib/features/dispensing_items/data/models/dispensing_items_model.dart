class DispensingItemsModel {
  final double quantity;
  final String name;
  final String id;
  final double totalPrice;

  const DispensingItemsModel({
    required this.quantity,
    required this.name,
    required this.totalPrice,
    required this.id,
  });

  DispensingItemsModel.fromJson(Map<String, dynamic> json)
      : this(
    name: json['name'] ?? '',
    id: json['id'] ?? '',
    quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
    totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
  );

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "id": id,
      "quantity": quantity,
      "totalPrice": totalPrice,
    };
  }
}
