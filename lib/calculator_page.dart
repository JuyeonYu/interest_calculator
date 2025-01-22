// import 'dart:ffi';

import 'dart:io';

import 'package:cal_interest/calculate_result.dart';
import 'package:cal_interest/input_text.dart';
import 'package:cal_interest/result_page.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:cal_interest/models/calculator_input.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';

// import 'package:numberpicker/numberpicker.dart';

class CalculatorPage extends StatefulWidget {
  CalculatorInput calculatorInput = CalculatorInput(
    principal: 0,
    interestRate: 0,
    term: 0,
    repaymentType: 0,
    description: '',
  );
  CalculatorPage({super.key});

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  InterstitialAd? _interstitialAd;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-7604048409167711/2272461651'
          : 'ca-app-pub-7604048409167711/1510646965',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              // _moveToHome();
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  List<VariableInterestRate> _variableInterestRates = [
    VariableInterestRate(interestRate: 0, months: 0)
  ];
  int _selectedOption = 0;
  bool _isValueValid = true;
  final List<String> _payDesc = [
    '원리금 균등상환 방식은 매 달 나가는 금액이 같습니다. 안정적인 미래를 예측하기 위해 가장 많이 사용됩니다.',
    '세가지 방식 중 가장 내야하는 이자의 총액이 낮습니다. 첫 달부터 가장 많은 돈을 내서 부담이 있습니다.',
    '원금일시상환은 매 달 이자만 내고, 마지막 달에 원금을 한번에 상환하는 방식입니다. 이자가 가장 많이 발생합니다.',
  ];

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();

  int _currentValue = 1;

  void _onOptionSelected(int index) {
    setState(() {
      _selectedOption = index;
      widget.calculatorInput = widget.calculatorInput.copyWith(
        repaymentType: index,
        description: _payDesc[index],
      );
    });
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  InputText(
                    title: '대출원금',
                    placeholder: '대출 원금을 입력해주세요',
                    surfix: '만원',
                    isRequired: true,
                    focusNode: _focusNode1,
                    desc: widget.calculatorInput.principal == 0
                        ? ''
                        : '${formatKoreanCurrency(widget.calculatorInput.principal)}원',
                    inputFormatters: [
                      CurrencyTextInputFormatter.currency(
                        locale: 'ko',
                        decimalDigits: 0,
                        symbol: '',
                      )
                    ],
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          widget.calculatorInput =
                              widget.calculatorInput.copyWith(
                            principal: 0,
                          );
                          return;
                        }
                        value = value.replaceAll(RegExp(r'[^0-9]'), '');
                        widget.calculatorInput =
                            widget.calculatorInput.copyWith(
                          principal: double.parse(value),
                        );
                      });
                    },
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                  InputText(
                    title: '이자율',
                    placeholder: '이자율을 입력해주세요',
                    surfix: '%',
                    isRequired: true,
                    desc: '',
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          widget.calculatorInput =
                              widget.calculatorInput.copyWith(
                            interestRate: 0,
                          );
                          return;
                        }
                        widget.calculatorInput =
                            widget.calculatorInput.copyWith(
                          interestRate: double.parse(value),
                        );
                      });
                    },
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    focusNode: _focusNode2,
                  ),
                  InputText(
                    title: '대출 기간',
                    placeholder: '대출 기간을 입력해주세요',
                    surfix: '개월',
                    isRequired: true,
                    desc: '',
                    onChanged: (value) {
                      if (value.isEmpty) {
                        widget.calculatorInput =
                            widget.calculatorInput.copyWith(
                          term: 0,
                        );
                        return;
                      }
                      widget.calculatorInput = widget.calculatorInput.copyWith(
                        term: int.parse(value),
                      );
                    },
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: false),
                    focusNode: _focusNode3,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Divider(),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 24, 0, 16),
                        child: Text('선택',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      if (_selectedOption == 0 || _selectedOption == 1)
                        InputText(
                          title: '거치 기간',
                          placeholder: '거치 기간을 입력해주세요',
                          surfix: '개월',
                          isRequired: false,
                          desc: '',
                          onChanged: (value) {
                            if (value.isEmpty) {
                              widget.calculatorInput =
                                  widget.calculatorInput.copyWith(
                                delayTerm: 0,
                              );
                              return;
                            }
                            widget.calculatorInput =
                                widget.calculatorInput.copyWith(
                              delayTerm: int.parse(value),
                            );
                          },
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false),
                        ),
                      // const Padding(
                      //   padding: EdgeInsets.fromLTRB(0, 8, 0, 16),
                      //   child: Text('변동 금리'),
                      // ),
                      // ..._variableInterestRates.asMap().entries.map((entry) {
                      //   int variableIndex = entry.key;
                      //   VariableInterestRate varibleInterestRate = entry.value;
                      //   return Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Stack(
                      //       clipBehavior: Clip.none,
                      //       children: [
                      //         Container(
                      //           decoration: BoxDecoration(
                      //               color: Colors.grey[100],
                      //               borderRadius: BorderRadius.circular(12)),
                      //           child: Padding(
                      //             padding:
                      //                 const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      //             child: Column(
                      //               children: [
                      //                 InputText(
                      //                   title: '회차',
                      //                   placeholder: '회차를 입력해주세요',
                      //                   surfix: '회차',
                      //                   isRequired: false,
                      //                   desc: '',
                      //                   onChanged: (value) {
                      //                     if (value.isEmpty) {
                      //                       return;
                      //                     }

                      //                     int start = int.parse(value);
                      //                     if (start < 1) {
                      //                       ScaffoldMessenger.of(context)
                      //                           .showSnackBar(
                      //                         const SnackBar(
                      //                           content: Text('1회차 이상 입력해주세요.'),
                      //                         ),
                      //                       );
                      //                       return;
                      //                     }

                      //                     if (start < 1) {
                      //                       ScaffoldMessenger.of(context)
                      //                           .showSnackBar(
                      //                         const SnackBar(
                      //                           content: Text('1회차 이상 입력해주세요.'),
                      //                         ),
                      //                       );
                      //                       return;
                      //                     }
                      //                     if (_variableInterestRates
                      //                         .map((element) => element.months)
                      //                         .contains(start)) {
                      //                       return;
                      //                     }

                      //                     _variableInterestRates[
                      //                             variableIndex] =
                      //                         _variableInterestRates[
                      //                                 variableIndex]
                      //                             .copywith(
                      //                                 months: int.parse(value));
                      //                     widget.calculatorInput
                      //                             .variableInterestRates =
                      //                         _variableInterestRates;
                      //                   },
                      //                   keyboardType: const TextInputType
                      //                       .numberWithOptions(decimal: false),
                      //                 ),
                      //                 InputText(
                      //                   title: '금리',
                      //                   placeholder: '변동 금리를 입력해주세요',
                      //                   surfix: '%',
                      //                   isRequired: false,
                      //                   desc: '',
                      //                   onChanged: (value) {
                      //                     if (value.isEmpty) {
                      //                       widget.calculatorInput = widget
                      //                           .calculatorInput
                      //                           .copyWith(interestRate: 0);
                      //                       return;
                      //                     }
                      //                     try {
                      //                       double d = double.parse(value);
                      //                       _variableInterestRates[
                      //                               variableIndex] =
                      //                           _variableInterestRates[
                      //                                   variableIndex]
                      //                               .copywith(interestRate: d);
                      //                       widget.calculatorInput.copyWith(
                      //                           variableInterestRates:
                      //                               _variableInterestRates);
                      //                       print(d);
                      //                     } catch (e) {
                      //                       print('Invalid input string');
                      //                     }
                      //                   },
                      //                   keyboardType: const TextInputType
                      //                       .numberWithOptions(decimal: false),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //         if (variableIndex > 0 &&
                      //             variableIndex ==
                      //                 _variableInterestRates.length - 1)
                      //           Positioned(
                      //             top: 0,
                      //             right: 0,
                      //             child: GestureDetector(
                      //               onTap: () {
                      //                 setState(() {
                      //                   _variableInterestRates
                      //                       .removeAt(variableIndex);
                      //                   widget.calculatorInput.copyWith(
                      //                       variableInterestRates:
                      //                           _variableInterestRates);
                      //                 });
                      //               },
                      //               child: Container(
                      //                 decoration: BoxDecoration(
                      //                   color: Colors.red[400],
                      //                   shape: BoxShape.circle,
                      //                 ),
                      //                 child: const Padding(
                      //                   padding: EdgeInsets.all(8.0),
                      //                   child: Icon(Icons.remove),
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //       ],
                      //     ),
                      //   );
                      // }),
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 48),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isValueValid ? Colors.blue[900] : Colors.grey[100],
                      ),
                      onPressed: () async {
                        if (widget.calculatorInput.principal > 0 &&
                            widget.calculatorInput.interestRate > 0 &&
                            widget.calculatorInput.term > 0) {
                          final box =
                              Hive.box<CalculatorInput>('CalculatorInput');
                          await box.add(widget.calculatorInput);
                          _interstitialAd?.show();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultPage(
                                  calculatorInput: widget.calculatorInput),
                            ),
                          );
                        } else {
                          _showInvalidSnackBar();
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('계산하기',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _checkValueValid() {
    _isValueValid = widget.calculatorInput.principal > 0 &&
        widget.calculatorInput.interestRate > 0 &&
        widget.calculatorInput.term > 0;
    // return _isValueValid;
  }

  void _showInvalidSnackBar() {
    if (widget.calculatorInput.principal == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('대출 원금을 입력해주세요'),
        ),
      );
    } else if (widget.calculatorInput.interestRate == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('이자율을 입력해주세요'),
        ),
      );
    } else if (widget.calculatorInput.term == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('대출 기간을 입력해주세요'),
        ),
      );
    }
  }

  Widget _buildOption(int index, String text) {
    bool isSelected = _selectedOption == index;
    return GestureDetector(
      onTap: () => _onOptionSelected(index),
      child: Container(
        width: MediaQuery.of(context).size.width / 3 - 16,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.grey[200],
          border: Border.all(
              color: isSelected
                  ? (Colors.blue[900] ?? Colors.blue)
                  : Colors.transparent),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blue[900]!.withOpacity(isSelected ? 0.1 : 0),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: text,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.blue[900] : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
