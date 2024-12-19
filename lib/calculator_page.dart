import 'package:cal_interest/input_text.dart';
import 'package:cal_interest/result_page.dart';
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
  final List<String> _payDesc = [
    '원리금균등상환은 어쩌고 저쩌고',
    '원금균등상환 어쩌고 저쩌고',
    '원금일시상환 어쩌고 저쩌고',
  ];

  void _onOptionSelected(int index) {
    setState(() {
      _selectedOption = index;
      widget.calculatorInput = widget.calculatorInput.copyWith(
        repaymentType: index,
        description: _payDesc[index],
      );
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //     children: [
  //       LayoutBuilder(
  //         builder: (context, constraints) {
  //           return SingleChildScrollView(
  //             padding: const EdgeInsets.all(16),
  //             child: ConstrainedBox(
  //               constraints: BoxConstraints(
  //                 minHeight: constraints.maxHeight,
  //               ),
  //               child: IntrinsicHeight(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.stretch,
  //                   children: <Widget>[
  //                     InputText(
  //                       title: '대출원금',
  //                       placeholder: '대출 원금을 입력해주세요',
  //                       surfix: '만원',
  //                       isRequired: true,
  //                       desc: '',
  //                       onChanged: (value) {
  //                         widget.calculatorInput =
  //                             widget.calculatorInput.copyWith(
  //                           principal: double.parse(value),
  //                           interestRate: null,
  //                         );
  //                       },
  //                     ),
  //                     InputText(
  //                       title: '이자율',
  //                       placeholder: '이자율을 입력해주세요',
  //                       surfix: '%',
  //                       isRequired: true,
  //                       desc: '',
  //                       onChanged: (value) {
  //                         widget.calculatorInput =
  //                             widget.calculatorInput.copyWith(
  //                           interestRate: double.parse(value),
  //                         );
  //                       },
  //                     ),
  //                     InputText(
  //                       title: '대출 기간',
  //                       placeholder: '대출 기간을 입력해주세요',
  //                       surfix: '개월',
  //                       isRequired: true,
  //                       desc: '',
  //                       onChanged: (value) {},
  //                     ),
  //                     const InputText(
  //                         title: '거치 기간',
  //                         placeholder: '거치 기간을 입력해주세요',
  //                         surfix: '개월',
  //                         isRequired: false,
  //                         desc: ''),
  //                     const Text('상환방식'),
  //                     Wrap(
  //                       spacing: 8.0,
  //                       runSpacing: 8.0,
  //                       children: <Widget>[
  //                         _buildOption(0, '원리금\n균등상환'),
  //                         _buildOption(1, '원금\n균등상환'),
  //                         _buildOption(2, '원금\n일시상환'),
  //                       ],
  //                     ),
  //                     Text(_payDesc[_selectedOption]),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //       const Spacer(),
  //       Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: ElevatedButton(
  //           onPressed: () {
  //             Navigator.push(context,
  //                 MaterialPageRoute(builder: (context) => const ResultPage()));
  //           },
  //           child: const Text('계산하기'),
  //         ),
  //       )
  //     ],
  //   );
  // }
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
                    desc: '',
                    onChanged: (value) {
                      widget.calculatorInput = widget.calculatorInput.copyWith(
                        principal: double.parse(value),
                      );
                      // setState(() {
                      //   _principal = double.parse(value);
                      // });
                    },
                  ),
                  InputText(
                    title: '이자율',
                    placeholder: '이자율을 입력해주세요',
                    surfix: '%',
                    isRequired: true,
                    desc: '',
                    onChanged: (value) {
                      widget.calculatorInput = widget.calculatorInput.copyWith(
                        interestRate: double.parse(value),
                      );
                    },
                  ),
                  InputText(
                    title: '대출 기간',
                    placeholder: '대출 기간을 입력해주세요',
                    surfix: '개월',
                    isRequired: true,
                    desc: '',
                    onChanged: (value) {
                      widget.calculatorInput = widget.calculatorInput.copyWith(
                        term: int.parse(value),
                      );
                      // setState(() {
                      //   _term = int.parse(value);
                      // });
                    },
                  ),
                  const InputText(
                    title: '거치 기간',
                    placeholder: '거치 기간을 입력해주세요',
                    surfix: '개월',
                    isRequired: false,
                    desc: '',
                  ),
                  const Text('상환방식'),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: <Widget>[
                      _buildOption(0, '원리금\n균등상환'),
                      _buildOption(1, '원금\n균등상환'),
                      _buildOption(2, '원금\n일시상환'),
                    ],
                  ),
                  Text(_payDesc[_selectedOption]),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_isValueValid()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultPage(
                                  calculatorInput: widget.calculatorInput),
                            ),
                          );
                        }
                      },
                      child: const Text('계산하기'),
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

  bool _isValueValid() {
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
    return widget.calculatorInput.principal > 0 &&
        widget.calculatorInput.interestRate > 0 &&
        widget.calculatorInput.term > 0;
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
          color: isSelected ? Colors.blue : Colors.white,
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
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
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
