import 'package:cal_interest/calculator_page.dart';
import 'package:flutter/material.dart';

void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainTabPage(),
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
    'Home',
    'Business',
    'School',
  ];
  final List<Widget> _children = [
    CalculatorPage(),
    const Text('Business'),
    const Text('School'),
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
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(_titles[_bottomIndex]),
      ),
      body: _children[_bottomIndex],
    );
  }
}
