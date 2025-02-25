import 'package:flutter/material.dart';
import 'package:maze/core/widgets/constants.dart';

class DropDownButtonFormFeild extends StatelessWidget {
  final String? selectedJobTitle; // القيمة المحددة
  final Function(String?)? onChanged; // دالة التحديث
  final String? Function(String?)? validator; // دالة التحقق

  const DropDownButtonFormFeild({
    super.key,
    required this.selectedJobTitle,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      hint: const Text(
        'Job Title',
        style: TextStyle(
          color: Colors.black54,
          fontSize: 19,
        ),
      ),
      borderRadius: BorderRadius.circular(24), // نصف قطر الحدود
      value: selectedJobTitle, // القيمة المحددة
      onChanged: onChanged, // تحديث القيمة عند الاختيار
      items: <String>[
        'Main Contractor',
        'Sub Contractor',
        'Consultant',
        'Supplier',
        'Developer',
        'Other',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(
                fontSize: 16,
                color: Colors.black87 // حجم النص داخل القائمة المنسدلة
                ),
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        hintText: '',
        hintStyle: const TextStyle(
          color: Colors.black54,
          fontSize: 19,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24), // نصف قطر الحدود
          borderSide: const BorderSide(
            color: kPrimaryColor, // لون الحدود العادي
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24), // نصف قطر الحدود عند التركيز
          borderSide: const BorderSide(
            color: kPrimaryColor, // لون الحدود عند التركيز
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24), // نصف قطر الحدود عند الخطأ
          borderSide: const BorderSide(
            color: Colors.red, // لون الحدود عند الخطأ
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(24), // نصف قطر الحدود عند التركيز مع الخطأ
          borderSide: const BorderSide(
            color: Colors.red, // لون الحدود عند التركيز مع الخطأ
            width: 2,
          ),
        ),
        errorStyle: const TextStyle(
          color: Colors.red, // لون نص الخطأ
          fontSize: 14, // حجم نص الخطأ
        ),
      ),
      style: const TextStyle(
        color: kBlackColor, // لون النص المحدد
        fontSize: 19, // حجم النص المحدد
      ),
      dropdownColor: Colors.white, // لون خلفية القائمة المنسدلة
      icon: const Icon(
        Icons.arrow_drop_down,
        color: kPrimaryColor, // لون أيقونة السهم
      ),
      validator: validator, // دالة التحقق
    );
  }
}
