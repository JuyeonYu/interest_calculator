import 'package:cal_interest/calculator_page.dart';
import 'package:cal_interest/history_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/calculator_input.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CalculatorInputAdapter());
  await Hive.openBox<CalculatorInput>('CalculatorInput');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const KeyboardDismissOnTap(child: MainTabPage()),
    );
  }
}

class MainTabPage extends StatefulWidget {
  const MainTabPage({super.key});

  @override
  State<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  int _bottomIndex = 0;

  final List<String> _titles = [
    '대출 이자 계산',
    '기록',
  ];
  final List<Widget> _children = [
    CalculatorPage(),
    const HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomIndex,
        onTap: (value) => setState(() {
          _bottomIndex = value;
        }),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '계산',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: '기록',
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(_titles[_bottomIndex]),
        actions: [
          if (_bottomIndex == 1) 
            IconButton(
            icon: const Icon(Icons.delete_sweep),
            color: Colors.red[500],
            onPressed: () {
              Hive.box<CalculatorInput>('CalculatorInput').clear();
            },
            )
        ],
      ),
      body: _children[_bottomIndex],
    );
  }
}
