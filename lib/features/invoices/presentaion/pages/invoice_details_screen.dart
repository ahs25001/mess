import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mess_app/core/widgets/custom_app_bar.dart';

import '../../../../core/models/invoice_model.dart';
import '../../../../core/utils/app_colors.dart';

class InvoiceDetailsScreen extends StatelessWidget {
  final InvoiceModel? invoice;
  const InvoiceDetailsScreen({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: invoice?.representativeName ?? ""),
          SizedBox(height: 10.h),
          Text(
            invoice?.date.toString().substring(0, 10) ?? "",
            style: TextStyle(fontSize: 18.sp, color: AppColors.primary),
          ),
          SizedBox(height: 10.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            height: 35.h,
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
                  child: Center(
                    child: Text(
                      "اسم الصنف",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "الكمية",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "السعر",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "سعر الوحدة",
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
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: invoice?.items.length ?? 0,
              itemBuilder: (context, index) => FadeInUp(
                key: ValueKey(
                  'row_${index}_${invoice?.id}_${invoice?.representativeName}',
                ),
                duration: const Duration(milliseconds: 300),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  height: 35.h,
                  decoration: BoxDecoration(
                    color: (index % 2 != 0)
                        ? AppColors.borderColor
                        : AppColors.cardBackground,
                    borderRadius: (index == (invoice?.items.length ?? 0) - 1)
                        ? BorderRadius.only(
                            bottomLeft: Radius.circular(7.r),
                            bottomRight: Radius.circular(7.r),
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
                        child: Center(
                          child: Text(
                            invoice?.items[index].food?.name ?? "",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          invoice?.items[index].quantity.toString() ?? '',
                          style: TextStyle(fontSize: 14.sp),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          invoice?.items[index].price.ceil().toString() ?? '0',
                          style: TextStyle(fontSize: 14.sp),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          (invoice
                                      ?.items[index]
                                      .food
                                      ?.isFixedMiscellaneousExpenses ??
                                  false)
                              ? 'نثريات ثابتة'
                              : (invoice
                                        ?.items[index]
                                        .food
                                        ?.isVariableMiscellaneousExpenses ??
                                    false)
                              ? 'نثريات متغيرة'
                              : ((invoice?.items[index].price ?? 0) /
                                        (invoice?.items[index].quantity ?? 1))
                                    .toString(),
                          style: TextStyle(fontSize: 14.sp),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: AppColors.primary,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
            child: Row(
              children: [
                Text(
                  'الإجمالي',
                  style: TextStyle(fontSize: 20.sp, color: AppColors.white),
                ),
                Spacer(),
                Text(
                  '${invoice?.total.toString() ?? 0} جنيه',
                  style: TextStyle(fontSize: 20.sp, color: AppColors.white),
                ),
              ],
            ),
          ).slideUp(duration: Duration(milliseconds: 500)),
        ],
      ),
    );
  }
}
