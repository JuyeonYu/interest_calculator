import 'package:cal_interest/calculator_input.dart';
import 'package:flutter/material.dart';
import 'calculate_result.dart';

class ResultPage extends StatelessWidget {
  final CalculatorInput calculatorInput;
  const ResultPage({super.key, required this.calculatorInput});

  // String formatCurrency(double amount) {
  //   return amount.toStringAsFixed(2).replaceAllMapped(
  //         RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
  //         (Match match) => '${match[1]},',
  //       );
  // }

  String formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    CalculateResult result = calculatorInput.calculateResult();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('원금: ${formatCurrency(calculatorInput.principal)}'),
            Text('이자율: ${calculatorInput.interestRate}%'),
            Text('대출 기간: ${calculatorInput.term}개월'),
            Text('Repayment Type: ${calculatorInput.repaymentType}'),
            Text('Description: ${calculatorInput.description}'),
            if (calculatorInput.repaymentType == 0 ||
                calculatorInput.repaymentType == 2) ...[
              Text('Monthly Payment: ${formatCurrency(result.monthlyPayment)}'),
              Text('Total Principal: ${formatCurrency(result.totalPrincipal)}'),
              Text('Total Interest: ${formatCurrency(result.totalInterest)}'),
              Text('Total Payment: ${formatCurrency(result.totalPayment)}'),
            ],
            ...[
              Table(
                border: TableBorder.all(),
                columnWidths: const {
                  0: FlexColumnWidth(0.2),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                  3: FlexColumnWidth(),
                  4: FlexColumnWidth(),
                },
                children: [
                  const TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('회차',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('납입원금(원)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('납입이자(원)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('납입금액(원)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('남은 원금(원)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue)),
                    ),
                  ]),
                  ...result.payments!.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    Map<String, double> payment = entry.value;
                    return TableRow(children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('$index'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child:
                            Text(formatCurrency(payment['monthlyPrincipal']!)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child:
                            Text(formatCurrency(payment['monthlyInterest']!)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(formatCurrency(payment['monthlyPayment']!)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(formatCurrency(payment['restPrincipal']!)),
                      ),
                    ]);
                  }).toList(),
                ],
              ),
              Text('Total Principal: ${formatCurrency(result.totalPrincipal)}'),
              Text('Total Interest: ${formatCurrency(result.totalInterest)}'),
              Text('Total Payment: ${formatCurrency(result.totalPayment)}'),
            ],
          ],
        ),
      ),
    );
  }
}
