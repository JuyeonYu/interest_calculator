import 'package:hive/hive.dart';

part 'variable_interest_rate.g.dart';

@HiveType(typeId: 1)
class VariableInterestRate extends HiveObject {
  @HiveField(0)
  final int months;

  @HiveField(1)
  final double interestRate;

  VariableInterestRate({
    required this.months,
    required this.interestRate,
  });

  Map<String, dynamic> toJson() {
    return {
      'months': months,
      'interestRate': interestRate,
    };
  }

  factory VariableInterestRate.fromJson(Map<String, dynamic> json) {
    return VariableInterestRate(
      months: json['months'],
      interestRate: json['interestRate'],
    );
  }
}
