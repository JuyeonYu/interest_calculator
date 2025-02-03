import 'package:cal_interest/calculate_result.dart';
import 'package:cal_interest/models/variable_interest_rate.dart';
import 'package:hive/hive.dart';

// part 'calculator_input.g.dart';

@HiveType(typeId: 0)
class CalculatorInput2 extends HiveObject {
  @HiveField(0)
  final int principal;

  @HiveField(1)
  final double interestRate;

  @HiveField(2)
  final int term;

  @HiveField(3)
  final int repaymentType;

  @HiveField(4)
  final int? delayTerm;

  @HiveField(5)
  final List<VariableInterestRate>? variableInterestRates;

  @HiveField(6)
  final String description;

  CalculatorInput2({
    required this.principal,
    required this.interestRate,
    required this.term,
    this.delayTerm,
    this.variableInterestRates,
    required this.repaymentType,
    required this.description,
  });
}
