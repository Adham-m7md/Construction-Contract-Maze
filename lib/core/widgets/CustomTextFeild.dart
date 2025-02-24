import 'package:flutter/material.dart';
import 'package:maze/core/widgets/constants.dart';

// ignore: must_be_immutable
class TextFormFeild extends StatelessWidget {
  TextFormFeild({
    super.key,
    this.hintText,
    this.onChanged,
    this.obscureText = false,
    required this.controller,
    this.validator,
    this.focusNode,
    this.suffixIcon, // إضافة معلمة prefixIcon
  });

  String? hintText;
  bool? obscureText;
  Function(String)? onChanged;
  TextEditingController controller;
  String? Function(String?)? validator;
  FocusNode? focusNode;
  Widget? suffixIcon; // معلمة prefixIcon

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText!,
      focusNode: focusNode,
      validator: validator ??
          (data) {
            if (data!.isEmpty) {
              return 'هذا الحقل مطلوب'; // رسالة الخطأ الافتراضية
            }
            return null;
          },
      onChanged: onChanged,
      style: const TextStyle(color: kBlackColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.black54,
          fontSize: 19,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        errorStyle: const TextStyle(color: Colors.red, fontSize: 14),
        suffixIcon: suffixIcon, // عرض prefixIcon فقط مع Password Field
      ),
    );
  }
}
