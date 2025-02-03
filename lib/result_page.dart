import 'dart:math';

import 'package:cal_interest/models/calculator_input.dart';
import 'package:cal_interest/models/variable_interest_rate.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:segmented_button_slide/segmented_button_slide.dart';
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

class ResultPage extends StatefulWidget {
  // final CalculatorInput calculatorInput;
  final String id;
  TextEditingController changeInterestRateController = TextEditingController();

  ResultPage({super.key, required this.id});

  // @override
  // State<ResultPage> createState() =>
  //     _ResultPageState(calculatorInput: calculatorInput);

  @override
  State<StatefulWidget> createState() {
    var box = Hive.box<CalculatorInput>('CalculatorInput');
    var item = box.get(id)!;
    return _ResultPageState(calculatorInput: item);
  }
}

class _ResultPageState extends State<ResultPage> {
  int selectedType = 0;
  CalculatorInput calculatorInput;
  _ResultPageState({required this.calculatorInput});

  @override
  Widget build(BuildContext context) {
    CalculateResult result = calculatorInput.calculateResult();
    ScrollController scrollController = ScrollController();
    

    return Scaffold(
      appBar: AppBar(
        title: const Text('계산 결과'),
        actions: [
          IconButton(icon: Icon(Icons.delete, color: Colors.red[500],), onPressed: () {
            Hive.box<CalculatorInput>('CalculatorInput').delete(calculatorInput.id);
            Navigator.pop(context);
          },)
        ],
      ),
      body: Stack(
        children: [
          ListView(
            controller: scrollController,
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
                          '${formatCurrency(calculatorInput.principal * 10000)} 원',
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
                      '${calculatorInput.interestRate}%',
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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: GestureDetector(
                  child: Row(
                    children: [
                      const Text('상환방식'),
                      Icon(Icons.info, color: Colors.blue[700]),
                    ],
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '미래를 계획하세요!',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
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
                                border: TableBorder.all(),
                                children: const [
                                  TableRow(
                                    children: [
                                      TableCell(
                                          child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('상환방식',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)))),
                                      TableCell(
                                          child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('매달 납부 금액',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)))),
                                      TableCell(
                                          child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('총 이자 비용',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)))),
                                      TableCell(
                                          child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('특징',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)))),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                          child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('원리금 균등'))),
                                      TableCell(
                                          child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('일정함'))),
                                      TableCell(
                                          child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('중간 수준'))),
                                      TableCell(
                                          child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('안정적예측 가능'))),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                          child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('원금 균등'))),
                                      TableCell(
                                          child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('점점 줄어듦'))),
                                      TableCell(
                                          child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('가장 적음'))),
                                      TableCell(
                                          child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('초기 부담 큼, 총 비용 절약'))),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                          child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('원금 일시'))),
                                      TableCell(
                                          child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('이자만 납부'))),
                                      TableCell(
                                          child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('가장 많음'))),
                                      TableCell(
                                          child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                  '초기 부담 적음, 마지막에 큰 금액 필요'))),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              SegmentedButtonSlide(
                selectedEntry: selectedType,
                onChange: (selected) => setState(() {
                  selectedType = selected;
                  calculatorInput.repaymentType = selected;
                  // _updateCalculatorInput();
                }),
                entries: const [
                  SegmentedButtonSlideEntry(
                    label: "원리금균등",
                  ),
                  SegmentedButtonSlideEntry(
                    label: "원금균등",
                  ),
                  SegmentedButtonSlideEntry(
                    label: "만기일시",
                  ),
                ],
                colors: SegmentedButtonSlideColors(
                  barColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.5),
                  backgroundSelectedColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
                slideShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(1),
                    blurRadius: 3,
                    spreadRadius: 1,
                  )
                ],
                margin: const EdgeInsets.all(16),
                height: 40,
                padding: const EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(8),
                selectedTextStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
                unselectedTextStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
                hoverTextStyle: const TextStyle(
                  color: Colors.orange,
                ),
              ),

              if ((calculatorInput.delayTerm ?? 0) > 0)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Text(
                        '거치 기간',
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

              
              // if ((widget.calculatorInput.variableInterest ?? 0) > 0 &&
              //     widget.calculatorInput.variableMonth != null)
              //   Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: Row(
              //       children: [
              //         const Text(
              //           '변동 금리',
              //           style: TextStyle(
              //             fontSize: 18,
              //             fontWeight: FontWeight.w100,
              //           ),
              //         ),
              //         const Spacer(),
              //         Text(
              //           '${widget.calculatorInput.variableMonth} 회 차부터 ${widget.calculatorInput.variableInterest}%',
              //           style: const TextStyle(
              //             fontSize: 24,
              //             fontWeight: FontWeight.w900,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              if (calculatorInput.variableInterestRates != null &&
                  calculatorInput.variableInterestRates!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Text(
                        '변동 금리',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${calculatorInput.variableInterestRates!.join(', ')}%',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Divider(
                  color: Colors.grey[300],
                  thickness: 20,
                ),
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
                        child: const Row(
                          children: [
                            Text(
                              '전체 이자',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: CompareInterestViewPage(
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
                          '${formatCurrency(result.totalInterest)}원',
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
                      '${formatCurrency(result.payments!.first['monthlyPayment']!)}원',
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
                      '${formatCurrency(result.payments!.last['monthlyPayment']!)}원',
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if ((calculatorInput.delayTerm ?? 0) > 0 &&
                              index - 1 ==
                                  calculatorInput.delayTerm) ...[
                            const Icon(Icons.arrow_drop_up_outlined,
                                color: Colors.red),
                            const Text(
                              '거치 종료',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ]
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // if (index ==
                          //     widget.calculatorInput.variableMonth) ...[
                          //   const Icon(Icons.arrow_drop_down_outlined,
                          //       color: Colors.blue),
                          //   Text(
                          //     '금리 변동(${widget.calculatorInput.variableInterest}%)',
                          //     style: const TextStyle(
                          //       fontSize: 13,
                          //       fontWeight: FontWeight.w100,
                          //     ),
                          //   ),
                          // ]
                          
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.trending_up),
                                    title: const Text('금리 변동'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _showInterestRateChangeDialog(context, index);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.payment),
                                    title: const Text('중도 상환'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _showEarlyRepaymentDialog(context, index);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.cancel),
                                    title: const Text('취소'),
                                    onTap: () {

                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 30, height: 80,child: Icon(Icons.add_circle, color: Colors.blue[800],), ),
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
                scrollController.animateTo(
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

  void _showInterestRateChangeDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('금리 변동'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('회차: $index'),
              TextField(
                controller: widget.changeInterestRateController,
                decoration: const InputDecoration(
                  labelText: '변동 금리 (%)',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {

                calculatorInput.variableInterestRates ??= [];

                calculatorInput.variableInterestRates?.add(VariableInterestRate(months: index + 1, interestRate: double.parse(widget.changeInterestRateController.text)));
                _updateCalculatorInput();
                Navigator.pop(context);
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showEarlyRepaymentDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('중도 상환'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('회차: $index'),
              TextField(
                decoration: const InputDecoration(
                  labelText: '상환 금액 (원)',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _updateCalculatorInput() {
    Hive.box<CalculatorInput>('CalculatorInput').put(calculatorInput.id, calculatorInput);
  }
}

class CompareInterestViewPage extends StatefulWidget {
  final CalculatorInput calculatorInput;
  const CompareInterestViewPage({super.key, required this.calculatorInput});

  @override
  _CompareInterestViewPageState createState() =>
      _CompareInterestViewPageState();
}

class _CompareInterestViewPageState extends State<CompareInterestViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상환 방법 비교'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CompareInterestView(
              calculatorInput: widget.calculatorInput,
              type: 0,
            ),
            CompareInterestView(
              calculatorInput: widget.calculatorInput,
              type: 1,
            ),
            CompareInterestView(
              calculatorInput: widget.calculatorInput,
              type: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class CompareInterestView extends StatelessWidget {
  const CompareInterestView({
    super.key,
    required this.calculatorInput,
    required this.type,
  });

  final CalculatorInput calculatorInput;
  final int type;

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
          Text(
            type == 0
                ? '전체 이자'
                : type == 1
                    ? '월 최저 납부액'
                    : '월 최고 납부액',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     const Text(
          //       '납부 방식 비교',
          //       style: TextStyle(
          //         fontSize: 18,
          //         fontWeight: FontWeight.w100,
          //       ),
          //     ),
          //     IconButton(
          //       icon: const Icon(Icons.close),
          //       onPressed: () {
          //         Navigator.pop(context);
          //       },
          //     ),
          //   ],
          // ),
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
