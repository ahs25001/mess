class MonthEndClosingHospitalityModel {
  num total;
  num variable;
  num consumer;

  MonthEndClosingHospitalityModel({
    required this.variable,
    required this.consumer,
    required this.total,
  });

  MonthEndClosingHospitalityModel.fromJson(Map<String, dynamic> json)
      : this(
          variable: (json['fixed'] as num?) ?? 0,
          consumer: (json['consumer'] as num?) ?? 0,
          total: (json['total'] as num?) ?? 0,
        );

  Map<String, dynamic> toJson() => {
        'fixed': variable,
        'consumer': consumer,
        'total': total,
      };
}
