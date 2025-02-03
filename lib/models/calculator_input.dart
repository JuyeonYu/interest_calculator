import 'dart:math';
import '../calculate_result.dart';
import 'package:hive/hive.dart';
import 'variable_interest_rate.dart';

part 'calculator_input.g.dart';

enum RepaymentType {
  equalPrincipalAndInterest,
  equalPrincipal,
  lumpSumRepayment,
}

extension RepaymentTypeExtension on RepaymentType {
  String value() {
    switch (this) {
      case RepaymentType.equalPrincipalAndInterest:
        return '원리금 균등상환';
      case RepaymentType.equalPrincipal:
        return '원금 균등상환';
      case RepaymentType.lumpSumRepayment:
        return '원금 일시상환';
    }
  }
}

@HiveType(typeId: 0)
class CalculatorInput extends HiveObject {
  @HiveField(7)
  final String id = DateTime.now().millisecondsSinceEpoch.toString();
  @HiveField(0)
  final double principal;

  @HiveField(1)
  final double interestRate;

  @HiveField(2)
  final int term;

  @HiveField(3)
  int repaymentType;

  @HiveField(4)
  int? delayTerm;

  @HiveField(5)
  List<VariableInterestRate> variableInterestRates;

  @HiveField(6)
  final String description;

  RepaymentType get repaymentTypeEnum => RepaymentType.values[repaymentType];

  CalculatorInput({
    required this.principal,
    required this.interestRate,
    required this.term,
    this.delayTerm,
    List<VariableInterestRate>? variableInterestRates,
    required this.repaymentType,
    required this.description,
  }) : variableInterestRates = variableInterestRates ?? [];

  Map<String, dynamic> toJson() {
    return {
      'principal': principal,
      'interestRate': interestRate,
      'term': term,
      'repaymentType': repaymentType,
      'delayTerm': delayTerm,
      'variableInterestRates':
          variableInterestRates.map((e) => e.toJson()).toList(),
      'description': description,
    };
  }

  CalculatorInput copyWith({
    double? principal,
    double? interestRate,
    int? term,
    List<VariableInterestRate>? variableInterestRates,
    int? delayTerm,
    int? repaymentType,
    String? description,
  }) {
    return CalculatorInput(
      principal: principal ?? this.principal,
      interestRate: interestRate ?? this.interestRate,
      term: term ?? this.term,
      variableInterestRates:
          variableInterestRates ?? this.variableInterestRates,
      delayTerm: delayTerm ?? this.delayTerm,
      repaymentType: repaymentType ?? this.repaymentType,
      description: description ?? this.description,
    );
  }

  CalculateResult calculateResult() {
    switch (repaymentType) {
      case 0:
        return calculateEqualPrincipalAndInterest();
      case 1:
        return calculateEqualPrincipal();
      case 2:
        return calculateLumpSumRepayment();
      default:
        throw Exception('Invalid repayment type');
    }
  }

  // 원리금 균등상환 방식
  CalculateResult calculateEqualPrincipalAndInterest() {
    double monthlyInterestRate = interestRate / 100 / 12;
    double monthlyPayment = principal *
        monthlyInterestRate /
        (1 - pow(1 + monthlyInterestRate, -(term - (delayTerm ?? 0))));
    double totalPayment = monthlyPayment * (term - (delayTerm ?? 0)) +
        (delayTerm ?? 0) * (principal * monthlyInterestRate);
    double totalInterest = totalPayment - principal;

    List<Map<String, double>> payments = [];

    if (delayTerm != null && delayTerm! > 0) {
      for (int i = 0; i < delayTerm!; i++) {
        double interestPayment = principal * monthlyInterestRate;
        payments.add({
          'monthlyPrincipal': 0,
          'monthlyInterest': interestPayment * 10000,
          'monthlyPayment': interestPayment * 10000,
          'restPrincipal': principal * 10000,
        });
      }
    }

    double restPrincipal = principal;

    variableInterestRates.sort((a, b) => a.months.compareTo(b.months));
    int variableIndex = 0;
    VariableInterestRate? variableRate = variableInterestRates.isNotEmpty
        ? variableInterestRates[variableIndex]
        : null;

    for (int i = 0; i < term - (delayTerm ?? 0); i++) {
      if (variableRate != null && i + 1 == variableRate.months) {
        monthlyInterestRate = variableRate.interestRate / 100 / 12;
        monthlyPayment = principal *
            monthlyInterestRate /
            (1 - pow(1 + monthlyInterestRate, -(term - (delayTerm ?? 0))));
        variableIndex++;
        if (variableIndex < variableInterestRates.length) {
          variableRate = variableInterestRates[variableIndex];
        } else {
          variableRate = null;
        }
      }

      double interestPayment = restPrincipal * monthlyInterestRate;
      double principalPayment = monthlyPayment - interestPayment;
      restPrincipal -= principalPayment;

      payments.add({
        'monthlyPrincipal': principalPayment * 10000,
        'monthlyInterest': interestPayment * 10000,
        'monthlyPayment': monthlyPayment * 10000,
        'restPrincipal': (principal - (principal * (i + 1) / term)) * 10000,
      });
    }
    return CalculateResult(
      monthlyPayment: monthlyPayment,
      totalPrincipal: principal,
      totalInterest: totalInterest * 10000,
      totalPayment: totalPayment * 10000,
      payments: payments,
    );
  }

  // 원금 균등상환 방식
  CalculateResult calculateEqualPrincipal() {
    double monthlyInterestRate = interestRate / 100 / 12;
    double monthlyPrincipal = principal / (term - (delayTerm ?? 0));
    double restPrincipal = principal;
    List<Map<String, double>> payments = [];
    double totalInterest = 0;

    if (delayTerm != null && delayTerm! > 0) {
      for (int i = 0; i < delayTerm!; i++) {
        double interestPayment = restPrincipal * monthlyInterestRate;
        totalInterest += interestPayment;
        payments.add({
          'monthlyPrincipal': 0,
          'monthlyInterest': interestPayment * 10000,
          'monthlyPayment': interestPayment * 10000,
          'restPrincipal': restPrincipal * 10000,
        });
      }
    }

    variableInterestRates.sort((a, b) => a.months.compareTo(b.months));
    int variableIndex = 0;
    VariableInterestRate? variableRate = variableInterestRates.isNotEmpty
        ? variableInterestRates[variableIndex]
        : null;

    for (int i = 0; i < term - (delayTerm ?? 0); i++) {
      if (variableRate != null && i + 1 == variableRate.months) {
        monthlyInterestRate = variableRate.interestRate / 100 / 12;
        variableIndex++;
        if (variableIndex < variableInterestRates.length) {
          variableRate = variableInterestRates[variableIndex];
        } else {
          variableRate = null;
        }
      }

      double interestPayment = restPrincipal * monthlyInterestRate;
      double totalPayment = monthlyPrincipal + interestPayment;

      totalInterest += interestPayment;
      restPrincipal -= monthlyPrincipal;
      payments.add({
        'monthlyPrincipal': monthlyPrincipal * 10000,
        'monthlyInterest': interestPayment * 10000,
        'monthlyPayment': totalPayment * 10000,
        'restPrincipal': restPrincipal * 10000,
      });
    }
    return CalculateResult(
      monthlyPayment: monthlyPrincipal + (principal * monthlyInterestRate),
      totalPrincipal: principal,
      totalInterest: totalInterest * 10000,
      totalPayment: principal + totalInterest,
      payments: payments,
    );
  }

  // 원금 일시상환 방식
  CalculateResult calculateLumpSumRepayment() {
    double totalInterest = principal * interestRate / 100 * term / 12;
    double totalPayment = principal + totalInterest;
    double monthlyInterestRate = interestRate / 100 / 12;

    List<Map<String, double>> payments = [];

    variableInterestRates.sort((a, b) => a.months.compareTo(b.months));
    int variableIndex = 0;
    VariableInterestRate? variableRate = variableInterestRates.isNotEmpty
        ? variableInterestRates[variableIndex]
        : null;

    for (int i = 0; i < term; i++) {
      if (variableRate != null && i + 1 == variableRate.months) {
        monthlyInterestRate = variableRate.interestRate / 100 / 12;
        variableIndex++;
        if (variableIndex < variableInterestRates.length) {
          variableRate = variableInterestRates[variableIndex];
        } else {
          variableRate = null;
        }
      }

      double monthlyInterest = principal * monthlyInterestRate;

      if (i == term - 1) {
        payments.add({
          'monthlyPrincipal': principal * 10000,
          'monthlyInterest': monthlyInterest * 10000,
          'monthlyPayment': principal + monthlyInterest,
          'restPrincipal': 0,
        });
      } else {
        payments.add({
          'monthlyPrincipal': 0,
          'monthlyInterest': monthlyInterest * 10000,
          'monthlyPayment': monthlyInterest * 10000,
          'restPrincipal': principal,
        });
      }
    }
    return CalculateResult(
      monthlyPayment: totalPayment / term,
      totalPrincipal: principal,
      totalInterest: totalInterest * 10000,
      totalPayment: totalPayment,
      payments: payments,
    );
  }
}
