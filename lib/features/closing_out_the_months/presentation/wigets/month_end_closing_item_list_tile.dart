import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mess_app/config/routes/app_routes.dart';
import 'package:mess_app/core/models/month_end_closing_history_model.dart';
import 'package:mess_app/core/utils/app_colors.dart';

class MonthEndClosingItemListTile extends StatelessWidget {
  final MonthEndClosingHistoryModel? monthEndClosingHistoryModel;
  const MonthEndClosingItemListTile({
    super.key,
    required this.monthEndClosingHistoryModel,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.closingOutTheMonthsDetails,arguments: monthEndClosingHistoryModel);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary, width: 2.sp),
        ),
        child: Row(
          children: [
            Icon(Icons.book, color: AppColors.primary, size: 25.sp),
            SizedBox(width: 10.w),
            Text(
              monthEndClosingHistoryModel?.date.toDate().toString().substring(
                    0,
                    10,
                  ) ??
                  "",
              style: TextStyle(color: AppColors.black,fontSize: 18.sp,fontWeight: FontWeight.w700),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios_outlined,color: AppColors.primary,size: 20.sp,)
          ],
        ),
      ),
    );
  }
}
