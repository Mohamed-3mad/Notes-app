import 'package:flutter/material.dart';

import '../constants.dart';

class FormWidget extends StatelessWidget {
  const FormWidget({
    super.key,
    required this.hintTxt,
    required this.icon,
    required this.controller,
    required this.obscText,
    this.validator,
  });

  final String hintTxt;
  final IconButton icon;
  final TextEditingController controller;
  final bool obscText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscText,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        suffixIcon: icon,
        suffixIconColor: kPrimaryColor,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        // filled: true,
        // fillColor: const Color.fromARGB(255, 241, 235, 235),
        hintText: hintTxt,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 240, 234, 234),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
