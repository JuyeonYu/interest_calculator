import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final bool isRequired;
  final String title;
  final String placeholder;
  final String? surfix;
  final String desc;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final List<CurrencyTextInputFormatter>? inputFormatters;
  const InputText({
    super.key,
    required this.title,
    required this.placeholder,
    this.surfix,
    required this.isRequired,
    required this.desc,
    required this.keyboardType,
    this.onChanged,
    this.focusNode,
    this.inputFormatters,
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
          style: const TextStyle(fontSize: 24),
          inputFormatters: inputFormatters,
          contextMenuBuilder: (context, editableTextState) {
            final List<ContextMenuButtonItem> buttonItems =
                editableTextState.contextMenuButtonItems;
            buttonItems.removeWhere((ContextMenuButtonItem buttonItem) {
              return buttonItem.type == ContextMenuButtonType.cut;
            });
            return AdaptiveTextSelectionToolbar.buttonItems(
              anchors: editableTextState.contextMenuAnchors,
              buttonItems: buttonItems,
            );
          },
          keyboardType: keyboardType,
          decoration: InputDecoration(
            suffixIcon: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(surfix ?? '',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
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
        if (desc.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Text(
              desc,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}
