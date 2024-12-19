import 'dart:math';
import 'calculate_result.dart';

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

class CalculatorInput {
  final double principal;
  final double interestRate;
  final int term;
  final int repaymentType;

  int? delayTerm;

  RepaymentType get repaymentTypeEnum => RepaymentType.values[repaymentType];
  final String description;

  CalculatorInput({
    required this.principal,
    required this.interestRate,
    required this.term,
    this.delayTerm,
    required this.repaymentType,
    required this.description,
  });

  CalculatorInput copyWith({
    double? principal,
    double? interestRate,
    int? term,
    int? delayTerm,
    int? repaymentType,
    String? description,
  }) {
    return CalculatorInput(
      principal: principal ?? this.principal,
      interestRate: interestRate ?? this.interestRate,
      term: term ?? this.term,
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
          'monthlyInterest': interestPayment,
          'monthlyPayment': interestPayment,
          'restPrincipal': principal,
        });
      }
    }

    for (int i = 0; i < term - (delayTerm ?? 0); i++) {
      double interestPayment =
          (principal - (principal * i / term)) * monthlyInterestRate;
      double principalPayment = monthlyPayment - interestPayment;

      payments.add({
        'monthlyPrincipal': principalPayment,
        'monthlyInterest': interestPayment,
        'monthlyPayment': monthlyPayment,
        'restPrincipal': principal - (principal * (i + 1) / term),
      });
    }
    return CalculateResult(
      monthlyPayment: monthlyPayment,
      totalPrincipal: principal,
      totalInterest: totalInterest,
      totalPayment: totalPayment,
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
          'monthlyInterest': interestPayment,
          'monthlyPayment': interestPayment,
          'restPrincipal': restPrincipal,
        });
      }
    }

    for (int i = 0; i < term - (delayTerm ?? 0); i++) {
      double interestPayment = restPrincipal * monthlyInterestRate;
      double totalPayment = monthlyPrincipal + interestPayment;

      totalInterest += interestPayment;
      restPrincipal -= monthlyPrincipal;
      payments.add({
        'monthlyPrincipal': monthlyPrincipal,
        'monthlyInterest': interestPayment,
        'monthlyPayment': totalPayment,
        'restPrincipal': restPrincipal,
      });
    }
    return CalculateResult(
      monthlyPayment: monthlyPrincipal + (principal * monthlyInterestRate),
      totalPrincipal: principal,
      totalInterest: totalInterest,
      totalPayment: principal + totalInterest,
      payments: payments,
    );
  }

  // 원금 일시상환 방식
  CalculateResult calculateLumpSumRepayment() {
    double totalInterest = principal * interestRate / 100 * term / 12;
    double totalPayment = principal + totalInterest;

    List<Map<String, double>> payments = [];
    for (int i = 0; i < term; i++) {
      double monthlyInterest = principal * interestRate / 100 / 12;
      if (i == term - 1) {
        payments.add({
          'monthlyPrincipal': principal,
          'monthlyInterest': monthlyInterest,
          'monthlyPayment': principal + monthlyInterest,
          'restPrincipal': 0,
        });
      } else {
        payments.add({
          'monthlyPrincipal': 0,
          'monthlyInterest': monthlyInterest,
          'monthlyPayment': monthlyInterest,
          'restPrincipal': principal,
        });
      }
    }
    return CalculateResult(
      monthlyPayment: totalPayment / term,
      totalPrincipal: principal,
      totalInterest: totalInterest,
      totalPayment: totalPayment,
      payments: payments,
    );
  }
}
