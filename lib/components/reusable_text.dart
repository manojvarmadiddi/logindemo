// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(
      {required this.controller,
      required this.label,
      this.isNumber = false,
      this.inputType,
      this.validator});
  final TextEditingController? controller;
  final String? label;
  final String? Function(String?)? validator;
  final bool? isNumber;
  final TextInputType? inputType;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? '',
          style: const TextStyle(
              fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
        ),
        Container(
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              // labelText: label,
            ),
            keyboardType: inputType ?? TextInputType.name,
            inputFormatters: inputType == null
                ? null
                : <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            validator: validator ??
                (value) {
                  if (value!.isEmpty) {
                    return 'required';
                  }
                  return null;
                },
          ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}
