import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class ComboMealTab extends StatelessWidget {
  const ComboMealTab({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Container(color: Colors.green),
        FilledButton(onPressed: (){},
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: Size(double.infinity, 40.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ), child: Text('حفظ',
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),),)
      ],
    );
  }
}
