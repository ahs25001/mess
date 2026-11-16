import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mess_app/core/utils/app_colors.dart';

class CustomEmptyListWidget extends StatelessWidget {
  final String message;
  final String? subtitle;
  final double? height;
  final double? width;

  const CustomEmptyListWidget({
    super.key,
    this.message = "لا توجد عناصر",
    this.subtitle,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/json/empty_list.json',
                height: height ?? 180.h,
                width: width ?? 180.w,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 12.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null && subtitle!.isNotEmpty) ...[
                SizedBox(height: 6.h),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
