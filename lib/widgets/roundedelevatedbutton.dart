import 'package:flutter/material.dart';

class RoundedElevatedButton extends StatelessWidget {
  const RoundedElevatedButton(
      {required this.color, required this.buttonText, required this.onTap});

  final Color color;
  final String buttonText;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(buttonText),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0))),
          padding:
              MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15.0))),
    );
  }
}
