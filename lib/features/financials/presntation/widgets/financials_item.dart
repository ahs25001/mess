import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/utils/app_colors.dart';

class FinancialsItem extends StatelessWidget {
 final String title ;
 final String animatedIconPath;
  const FinancialsItem({super.key,required this.title,required this.animatedIconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsGeometry.symmetric(
        horizontal: 20.w,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primary),
      ),
      child: Row(
        children: [
          Lottie.asset(
            animatedIconPath,
            width: 35.w,
            height: 35.h,
            repeat: false,
          ),
          SizedBox(width: 20.w,),
          Text(title,style: TextStyle(color: AppColors.primary,fontSize: 20.sp,fontWeight: FontWeight.w500),)
          ,Spacer()
          ,Icon(Icons.arrow_forward_ios_outlined,size: 20.sp,color: AppColors.primary,)
        ],
      ),
    );
  }
}
