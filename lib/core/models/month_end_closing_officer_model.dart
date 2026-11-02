class MonthEndClosingOfficerModel {
  String name;
  num total;
  num fixed;
  num variable;
  num consumer;
  num perish;

  MonthEndClosingOfficerModel({
    required this.name,
    required this.total,
    required this.fixed,
    required this.variable,
    required this.consumer,
    required this.perish,
  });

  MonthEndClosingOfficerModel.fromJson(Map<String, dynamic> json)
      : this(
          name: json['name'] ?? '',
          total: (json['total'] as num?) ?? 0,
          fixed: (json['fixed'] as num?) ?? 0,
          variable: (json['variable'] as num?) ?? 0,
          consumer: (json['consumer'] as num?) ?? 0,
          perish: (json['perish'] as num?) ?? 0,
        );

  Map<String, dynamic> toJson() => {
        'name': name,
        'total': total,
        'fixed': fixed,
        'variable': variable,
        'consumer': consumer,
        'perish': perish,
      };
}
