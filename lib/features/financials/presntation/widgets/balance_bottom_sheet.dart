import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mess_app/core/models/officer_model.dart';
import '../../../../core/utils/app_colors.dart';
class BalanceBottomSheet extends StatelessWidget {
  final List<OfficerModel>?officers;
  const BalanceBottomSheet({super.key,required this.officers});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      children: [
        // Table Header
        Container(
          height: 35.h,
          decoration: BoxDecoration(
            color: AppColors.borderColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.r),
              topRight: Radius.circular(7.r),
            ),
            border: Border.all(
              color: AppColors.borderColor,
              width: 1.w,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    "اسم الضابط",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "التأسيس",
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
                  "الرصيد",
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
                  "المستهلك",
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
        // Table Animated Rows
        ...(officers??[]).asMap().entries.map((entry) {
          final index = entry.key;
          final e = entry.value;
          return FadeInUp(
            key: ValueKey(
              'row_${index}_${e.id}_${e.name}',
            ),
            duration: const Duration(
              milliseconds: 300,
            ),
            child: Container(
              height: 35.h,
              decoration: BoxDecoration(
                color: (index % 2 != 0)
                    ? AppColors.borderColor
                    : AppColors.cardBackground,
                borderRadius:
                (index == officers!.length - 1)
                    ? BorderRadius.only(
                  bottomLeft: Radius.circular(
                    7.r,
                  ),
                  bottomRight: Radius.circular(
                    7.r,
                  ),
                )
                    : null,
                border: Border.all(
                  color: AppColors.borderColor,
                  width: 1.w,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        e.name ,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '700',
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      e.amount.toString(),
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),   Expanded(
                    flex: 1,
                    child: Text(
                      "${700-e.amount}",
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                ],
              ),
            ),
          );
        }),

      ],
    );
  }
}
