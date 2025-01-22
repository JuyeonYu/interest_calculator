import 'package:cal_interest/result_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/calculator_input.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<CalculatorInput>('CalculatorInput');

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box<CalculatorInput> box, _) {
        if (box.values.isEmpty) {
          return const Center(child: Text('No history found'));
        } else {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              var input = box.getAt(box.length - 1 - index);
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    '원금: ${formatKoreanCurrency(input?.principal ?? 0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    '이자: ${input?.interestRate}% 기간: ${input?.term}개월',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(calculatorInput: input!),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<Box<CalculatorInput>> _openBox() async {
    if (!Hive.isBoxOpen('calculatorInputs')) {
      return await Hive.openBox<CalculatorInput>('calculatorInputs');
    }
    return Hive.box<CalculatorInput>('calculatorInputs');
  }
}