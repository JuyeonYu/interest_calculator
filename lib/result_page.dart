import 'package:cal_interest/calculator_input.dart';
import 'package:flutter/material.dart';
import 'calculate_result.dart';

String formatCurrency(double amount) {
  return amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (Match match) => '${match[1]},',
      );
}

String formatKoreanCurrency(double input) {
  // if (input == null) return "0";
  if (input == 0) return "0";

  int man = (input % 10000).toInt(); // 만 단위 (소수점 제거)
  int eok = (input ~/ 10000).toInt(); // 억 단위

  // 만 단위를 문자열로 포맷팅 (3자리 콤마 추가)
  String formattedMan = man.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'),
        (match) => '${match[1]},',
      );

  String result = "";

  if (eok > 0) {
    result += "${eok}억";
  }

  if (man > 0) {
    if (result.isNotEmpty) {
      result += " ";
    }
    result += "${formattedMan}만";
  }

  return result;
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

  return result;
}

String convertToKoreanWithDecimal(double amount) {
  if (amount < 1) return '0원';

  int integerPart = amount.toInt();
  double decimalPart = amount - integerPart;

  String integerPartKorean = convertToKorean(integerPart.toDouble());
  String decimalPartKorean = (decimalPart * 10000).toStringAsFixed(0);

  return '$integerPartKorean원 $decimalPartKorean전';
}

class ResultPage extends StatelessWidget {
  final CalculatorInput calculatorInput;
  const ResultPage({super.key, required this.calculatorInput});

  @override
  Widget build(BuildContext context) {
    CalculateResult result = calculatorInput.calculateResult();
    ScrollController _scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('계산 결과'),
      ),
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 80), // 패딩 추가
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                      child: Text(
                        '원금',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${formatCurrency(calculatorInput.principal)}만 원',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          '${formatKoreanCurrency(calculatorInput.principal)} 원',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Text(
                      '이자율',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${formatCurrency(calculatorInput.interestRate)}%',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Text(
                      '대출 기간',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${calculatorInput.term}개월',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Text(
                      '상환 방법',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      calculatorInput.repaymentTypeEnum.value(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              if (calculatorInput.delayTerm != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Text(
                        '연기 기간',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${calculatorInput.delayTerm}개월',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
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
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                      child: GestureDetector(
                        child: Row(
                          children: [
                            const Text(
                              '전체 이자',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                            Icon(Icons.info, color: Colors.blue[900]),
                          ],
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: CompareInterestView(
                                    calculatorInput: calculatorInput),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${formatCurrency(result.totalInterest)}만 원',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.blue[700]),
                        ),
                        Text(
                          '${formatKoreanCurrency(result.totalInterest / 10000)} 원',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // CompareInterestView(calculatorInput: calculatorInput),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Text(
                      '첫 달',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${formatCurrency(result.payments!.first['monthlyPayment']!)}만원',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Text(
                      '마지막 달',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${formatCurrency(result.payments!.last['monthlyPayment']!)}만원',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
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
                  ),
                ),
              ),
              ...result.payments!.asMap().entries.map((entry) {
                int index = entry.key + 1;
                Map<String, double> payment = entry.value;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                            child: Text(
                              '$index회차',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ),
                          if (index ~/ 12 > 0)
                            Text('${index ~/ 12}년 ${index % 12}개월'),
                          if (index ~/ 12 == 0 && index % 12 > 0)
                            Text('${index % 12}개월'),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${formatCurrency(payment['monthlyPayment']!)}원',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            '원금 ${formatCurrency(payment['monthlyPrincipal']!)}원',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            '이자 ${formatCurrency(payment['monthlyInterest']!)}원',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                );
              },
              child: const Icon(Icons.arrow_upward),
            ),
          ),
        ],
      ),
    );
  }
}

class CompareInterestView extends StatelessWidget {
  const CompareInterestView({
    super.key,
    required this.calculatorInput,
  });

  final CalculatorInput calculatorInput;

  @override
  Widget build(BuildContext context) {
    var calculatorInput0 = calculatorInput.copyWith(repaymentType: 0);
    var calculatorInput1 = calculatorInput.copyWith(repaymentType: 1);
    var calculatorInput2 = calculatorInput.copyWith(repaymentType: 2);

    CalculateResult result0 = calculatorInput0.calculateResult();
    CalculateResult result1 = calculatorInput1.calculateResult();
    CalculateResult result2 = calculatorInput2.calculateResult();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '납부 방식 비교',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w100,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Table(
            border: TableBorder.all(color: Colors.grey),
            children: [
              const TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '상환방식',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '전체 이자(원)',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  const TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '원금 균등',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        formatCurrency(result1.totalInterest),
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  const TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '원리금 균등',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        formatCurrency(result0.totalInterest),
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  const TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '원금 일시',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        formatCurrency(result2.totalInterest),
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
