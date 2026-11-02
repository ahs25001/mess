class OfficerModel {
  String id;
  String name;
  String rank;
  String phone;
  num militaryIDNumber;
  num amount;
  num consumer;
  bool isActive;
  OfficerModel({
    required this.id,
    required this.consumer,
    required this.amount,
    required this.name,
    this.isActive = true,
    required this.rank,
    required this.phone,
    required this.militaryIDNumber,
  });

  OfficerModel.fromJson(Map<String, dynamic> json)
    : this(
        id: json['id'] ?? '',
        isActive: json['isActive'] ?? true,
        consumer: json['consumer'],
        name: json['name'] ?? '',
        rank: json['rank'] ?? '',
        phone: json['phone'] ?? '',
        amount: (json['amount'] as num?) ?? 0,
        militaryIDNumber: (json['militaryIDNumber'] as num?) ?? 0,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'isActive': isActive,
    'name': name,
    'consumer': consumer,
    'rank': rank,
    'amount': amount,
    'phone': phone,
    'militaryIDNumber': militaryIDNumber,
  };
}
