import 'dart:math';
import 'calculate_result.dart';

class CalculatorInput {
  final double principal;
  final double interestRate;
  final int term;
  final int repaymentType;
  final String description;

  CalculatorInput({
    required this.principal,
    required this.interestRate,
    required this.term,
    required this.repaymentType,
    required this.description,
  });

  CalculatorInput copyWith({
    double? principal,
    double? interestRate,
    int? term,
    int? repaymentType,
    String? description,
  }) {
    return CalculatorInput(
      principal: principal ?? this.principal,
      interestRate: interestRate ?? this.interestRate,
      term: term ?? this.term,
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
    double monthlyInterestRate = interestRate / 12;
    double monthlyPayment = principal *
        monthlyInterestRate /
        (1 - pow(1 + monthlyInterestRate, -term));
    double totalPayment = monthlyPayment * term;
    double totalInterest = totalPayment - principal;
    List<Map<String, double>> payments = [];
    for (int i = 0; i < term; i++) {
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
    double monthlyInterestRate = interestRate / 12 / 100;
    double monthlyPrincipal = principal / term;
    double restPrincipal = principal;
    List<Map<String, double>> payments = [];
    double totalInterest = 0;
    for (int i = 0; i < term; i++) {
      double interestPayment = restPrincipal * interestRate / 12;
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
      monthlyPayment: monthlyPrincipal +
          (principal *
              monthlyInterestRate), // Monthly payment for the first month
      totalPrincipal: principal,
      totalInterest: totalInterest,
      totalPayment: principal + totalInterest,
      payments: payments,
    );
  }

  // 원금 일시상환 방식
  CalculateResult calculateLumpSumRepayment() {
    double totalInterest = principal * interestRate * term / 12;
    double totalPayment = principal + totalInterest;

    List<Map<String, double>> payments = [];
    for (int i = 0; i < term; i++) {
      double monthlyInterest = principal * interestRate / 12;
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
