import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class RemainingAmountBottomSheet extends StatelessWidget {
  final double total;
  final double cache;
  final double officersAmounts;
  final double canteen;
  final double hospitality;
  final double invoices;
  const RemainingAmountBottomSheet({
    super.key,
    required this.total,
    required this.invoices,
    required this.cache,
    required this.officersAmounts,
    required this.canteen,
    required this.hospitality,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      children: [
        Center(child: Text("الإجمالي : $total",style: TextStyle(
          color: AppColors.primary,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),)),
        SizedBox(height: 10.h,),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 2.w),
          decoration: BoxDecoration(
            color: AppColors.borderColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.r),
              topRight: Radius.circular(7.r),
            ),
            border: Border.all(color: AppColors.borderColor, width: 1.w),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "موجود",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "ضباط",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "كانتين",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "ضيافة",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ), Expanded(
                flex: 1,
                child: Text(
                  "فواتير",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 2.w),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(7.r),
              bottomRight: Radius.circular(7.r),
            ),
            border: Border.all(color: AppColors.borderColor, width: 1.w),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "$cache",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "$officersAmounts",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "$canteen",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "$hospitality",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ), Expanded(
                flex: 1,
                child: Text(
                  "$invoices",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
