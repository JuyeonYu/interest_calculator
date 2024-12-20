import 'package:cal_interest/calculator_input.dart';
import 'package:flutter/material.dart';
import 'calculate_result.dart';

class ResultPage extends StatelessWidget {
  final CalculatorInput calculatorInput;
  const ResultPage({super.key, required this.calculatorInput});

  String formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]},',
        );
  }

  String convertToKorean(double amount) {
    List<String> units = ['', '만', '억', '조', '경'];
    List<String> numbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    if (amount == 0) return numbers[0];

    String result = '';
    int unitIndex = 0;

    while (amount > 0) {
      int chunk = (amount % 10000).toInt();
      if (chunk > 0) {
        String chunkStr = '';
        while (chunk > 0) {
          int digit = chunk % 10;
          if (digit > 0) {
            chunkStr = '${numbers[digit]}$chunkStr';
          }
          chunk ~/= 10;
        }
        result = chunkStr + units[unitIndex] + result;
      }
      amount /= 10000;
      unitIndex++;
    }

    // Add commas every 3 digits
    result = result.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );

    // Add space between Korean characters and numbers
    result = result.replaceAllMapped(
      RegExp(r'([가-힣])(\d)'),
      (Match match) => '${match[1]} ${match[2]}',
    );

    return result;
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                const Text(
                  '원금',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${formatCurrency(calculatorInput.principal)}원',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '${convertToKorean(calculatorInput.principal)} 원',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                const Text(
                  '이자율',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                const Spacer(),
                Text(
                  '${formatCurrency(calculatorInput.interestRate)}%',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                const Text(
                  '대출 기간',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                const Spacer(),
                Text(
                  '${calculatorInput.term}개월',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                const Text(
                  '상환 방법',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                const Spacer(),
                Text(
                  calculatorInput.repaymentTypeEnum.value(),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
            ),

            if (calculatorInput.delayTerm != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(children: [
                  const Text(
                    '연기 기간',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${calculatorInput.delayTerm}개월',
                    style: const TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ]),
              ),

            const Divider(
              color: Colors.black,
              thickness: 0.5,
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                '납부액',
                style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w100,
              ),),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                const Text(
                  '전체 이자',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                const Spacer(),
                Text(
                  '${formatCurrency(result.totalInterest)}원',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Colors.blue
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                const Text(
                  '첫 달',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                const Spacer(),
                Text(
                  '${formatCurrency(result.payments!.first['monthlyPayment']!)}원',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
            ),


            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                const Text(
                  '마지막 달',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                const Spacer(),
                Text(
                  '${formatCurrency(result.payments!.last['monthlyPayment']!)}원',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
            ),

            

            const Divider(
              color: Colors.black,
              thickness: 0.5,
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                '상세 내역',
                style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w100,
              ),),
            ),
            ...[
              Table(
                border: TableBorder.all(),
                columnWidths: const {
                  0: FlexColumnWidth(0.5),
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
