import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final bool isRequired;
  final String title;
  final String placeholder;
  final String? surfix;
  final String desc;

  const InputText({super.key, required this.title, required this.placeholder, this.surfix, required this.isRequired, required this.desc});
  @override
  Widget build(BuildContext context) {
    
    return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row (children: [
          Text(title),
          if (isRequired) const Text('*'),
        ]),
        TextField(
          decoration: InputDecoration(
          labelText: placeholder,
          // hintText: "대출 원금 입력",
          hintStyle: TextStyle(color: Colors.grey),
          suffixText: surfix,
          suffixIcon: Padding(padding: EdgeInsets.all(16), child: Text(surfix ?? ''),)
          ),
        ),
        Text(desc),
      ],
    );
  }
}