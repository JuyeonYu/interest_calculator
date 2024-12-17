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
}
