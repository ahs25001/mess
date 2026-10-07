class OfficerModel {
  String id;
  String name;
  String rank;
  String phone;
  num militaryIDNumber;
  num amount;
  OfficerModel({
    required this.id,
    required this.amount,
    required this.name,
    required this.rank,
    required this.phone,
    required this.militaryIDNumber,
  });
  OfficerModel.fromJson(Map<String, dynamic> json)
    : this(
        id: json['id'],
        name: json['name'],
        rank: json['rank'],
        phone: json['phone'],
        amount: json['amount'],
        militaryIDNumber: json['militaryIDNumber'],
      );
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'rank': rank,
    'amount': amount,
    'phone': phone,
    'militaryIDNumber': militaryIDNumber,
  };
}
