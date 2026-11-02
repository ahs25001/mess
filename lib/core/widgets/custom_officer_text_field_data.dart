import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mess_app/core/utils/app_colors.dart';

class CustomOfficerTextFieldData extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final bool isNumber;
  final String? Function(String?) validator;
  final VoidCallback onSubmitted;
  final int? maxLength;
  final TextInputAction textInputAction;

  const CustomOfficerTextFieldData({
    super.key,
    required this.validator,
    required this.controller,
    required this.onSubmitted,
    required this.focusNode,
    required this.label,
    this.maxLength,
    this.isNumber = false,
    this.textInputAction = TextInputAction.next,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: textInputAction,
      onFieldSubmitted: (value) {
        onSubmitted();
      },
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.borderColor, width: 2.sp),
          borderRadius: BorderRadius.circular(10.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(10.r),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(10.r),
        ),
        label: Text(
          label,
          style: TextStyle(color: AppColors.primary, fontSize: 14.sp),
        ),
      ),
      validator: (value) => validator(value),
    );
  }
}
