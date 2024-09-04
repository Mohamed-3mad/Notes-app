import 'package:flutter/material.dart';

class LoginIcon extends StatelessWidget {
  const LoginIcon({
    super.key,
    required this.image,
    required this.onPressed,
  });
  final String image;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 243, 239, 239),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: Image.asset(
          image,
          height: 40,
        )),
      ),
    );
  }
}
