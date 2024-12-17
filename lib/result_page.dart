import 'package:cal_interest/calculator_input.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final CalculatorInput calculatorInput;
  const ResultPage({super.key, required this.calculatorInput});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: Column(
        children: [
          Text('Principal: ${calculatorInput.principal}'),
          Text('Interest Rate: ${calculatorInput.interestRate}'),
          Text('Term: ${calculatorInput.term}'),
          Text('Repayment Type: ${calculatorInput.repaymentType}'),
          Text('Description: ${calculatorInput.description}'),
        ],
      ),
    );
  }
}
