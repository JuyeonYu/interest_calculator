import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final bool isRequired;
  final String title;
  final String placeholder;
  final String? surfix;
  final String desc;
  final ValueChanged<String>? onChanged;

  final TextInputType keyboardType;
  const InputText({
    super.key,
    required this.title,
    required this.placeholder,
    this.surfix,
    required this.isRequired,
    required this.desc,
    required this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(children: [
          Text(title),
          if (isRequired) const Text('*', style: TextStyle(color: Colors.red)),
        ]),
        TextField(
          keyboardType: keyboardType,
          decoration: InputDecoration(
            suffixIcon: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(surfix ?? '', style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            hintText: placeholder,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 24),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300] ?? Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
          ),
          onChanged: onChanged,
        ),
        Text(desc),
      ],
    );
  }
}
