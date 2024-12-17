import 'package:cal_interest/input_text.dart';
import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const InputText(title: '대출원금', placeholder: '대출 원금을 입력해주세요', surfix: '만원',  isRequired: true, desc: ''),
          const InputText(title: '이자율', placeholder: '이자율을 입력해주세요', surfix: '%', isRequired: true, desc: ''), 
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
          Text(_payDesc[_selectedOption]), 
        ],
      ),
    ),
    const Spacer(),
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {},
        child: const Text('계산하기'),
      ),
    )
    ],);
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