import 'package:flutter/material.dart';

class CustomNoteForm extends StatelessWidget {
  const CustomNoteForm({
    super.key,
    required this.hintTxt,
    required this.controller,
    required this.validator,
  });

  final String hintTxt;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
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
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 240, 234, 234),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
