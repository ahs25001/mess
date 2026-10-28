class MonthEndClosingHospitalityModel {
  num total;
  num fixed;
  num consumer;

  MonthEndClosingHospitalityModel({
    required this.fixed,
    required this.consumer,
    required this.total,
  });

  MonthEndClosingHospitalityModel.fromJson(Map<String, dynamic> json)
      : this(
          fixed: (json['fixed'] as num?) ?? 0,
          consumer: (json['consumer'] as num?) ?? 0,
          total: (json['total'] as num?) ?? 0,
        );

  Map<String, dynamic> toJson() => {
        'fixed': fixed,
        'consumer': consumer,
        'total': total,
      };
}
