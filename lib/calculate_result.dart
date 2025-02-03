class CalculateResult {
  final double monthlyPayment;
  final double totalPrincipal;
  final double totalInterest;
  final double totalPayment;
  final List<Map<String, double>>? payments;

  CalculateResult({
    required this.monthlyPayment,
    required this.totalPrincipal,
    required this.totalInterest,
    required this.totalPayment,
    this.payments,
  });
}




