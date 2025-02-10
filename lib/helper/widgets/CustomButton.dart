import 'package:flutter/material.dart';
import 'package:maze/helper/widgets/constants.dart';

// ignore: must_be_immutable
class Button extends StatelessWidget {
  Button({super.key, this.buttonText, this.onTap});
  String? buttonText;
  VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: kPrimaryColor, borderRadius: BorderRadius.circular(16)),
          height: 45,
          width: double.infinity,
          child: Center(
              child: Text(
            buttonText!,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }
}
