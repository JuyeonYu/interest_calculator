import 'package:cal_interest/input_text.dart';
import 'package:cal_interest/result_page.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:cal_interest/calculator_input.dart';

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
                  GestureDetector(
                    child: const Row(
                      children: [
                        Text('상환방식'),
                        Icon(Icons.info, color: Colors.blue),
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
                                                child:
                                                    Text('초기 부담 큼, 총 비용 절약'))),
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
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: <Widget>[
                      _buildOption(0, '원리금 균등'),
                      _buildOption(1, '원금 균등'),
                      _buildOption(2, '원금 일시'),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  if (_selectedOption == 0 || _selectedOption == 1)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 24, 0, 16),
                          child: Text('선택',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
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
                      ],
                    ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 48),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isValueValid ? Colors.blue : Colors.grey[100],
                      ),
                      onPressed: () {
                        if (widget.calculatorInput.principal > 0 &&
                            widget.calculatorInput.interestRate > 0 &&
                            widget.calculatorInput.term > 0) {
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
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: const Text('계산하기',
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
          border:
              Border.all(color: isSelected ? Colors.blue : Colors.transparent),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(isSelected ? 0.1 : 0),
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
                color: isSelected ? Colors.blue : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
