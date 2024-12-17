import 'package:cal_interest/input_text.dart';
import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  int _selectedOption = 0;
  List<double> interestRates = [0.0];
  List<int> periods = [1];

  void _onOptionSelected(int index) {
    setState(() {
      _selectedOption = index;
    });
  }

  void _addInterestRate() {
    setState(() {
      interestRates.add(0.0);
      periods.add(1);
    });
  }

  void _removeInterestRate(int index) {
    setState(() {
      interestRates.removeAt(index);
      periods.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          const InputText(title: '대출원금', placeholder: '대출 원금을 입력해주세요', surfix: '만원',  isRequired: true, desc: ''),
          Column(
            children: List.generate(interestRates.length, (index) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: InputText(
                          title: '이자율 ${index + 1}',
                          placeholder: '이자율을 입력해주세요',
                          surfix: '%',
                          isRequired: true,
                          desc: '',
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () => _removeInterestRate(index),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('기간: '),
                      Expanded(
                        child: Slider(
                          value: periods[index].toDouble(),
                          min: 1,
                          max: 36,
                          divisions: 35,
                          label: '${periods[index]} 개월',
                          onChanged: (value) {
                            setState(() {
                              periods[index] = value.toInt();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
          TextButton(
            onPressed: _addInterestRate,
            child: const Text('이자율 추가'),
          ),
          const InputText(title: '대출 기간', placeholder: '대출 기간을 입력해주세요', surfix: '개월', isRequired: true, desc: ''),
          const InputText(title: '거치 기간', placeholder: '거치 기간을 입력해주세요', surfix: '개월', isRequired: false, desc: ''),

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
        ],
      ),
    );
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