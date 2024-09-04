import 'package:flutter/material.dart';
import 'package:login/constants.dart';

void customSnackBar(BuildContext context, {required String snackText}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: kPrimaryColor,
    content: Text(
      snackText,
      style: const TextStyle(fontSize: 18, color: Colors.white),
    ),
    duration: const Duration(seconds: 2),
  ));
}
