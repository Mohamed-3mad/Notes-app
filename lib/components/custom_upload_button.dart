import 'package:flutter/material.dart';

import '../constants.dart';

class CustomUploadButton extends StatefulWidget {
  const CustomUploadButton({super.key, this.onPressed, required this.title, required this.isSelected});
  final void Function()? onPressed;
  final String title;
  final bool isSelected;


  @override
  State<CustomUploadButton> createState() => _CustomUploadButtonState();
}

class _CustomUploadButtonState extends State<CustomUploadButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 50,
      minWidth: 100,
      color:widget.isSelected?Colors.green: kPrimaryColor,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      onPressed: widget.onPressed,
      child:  Text(widget.title),
    );
  }
}
