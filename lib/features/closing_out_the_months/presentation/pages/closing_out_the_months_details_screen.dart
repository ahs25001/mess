import 'package:accordion/accordion.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mess_app/core/models/month_end_closing_history_model.dart';
import 'package:mess_app/features/financials/presntation/pages/month_end_closing_screen.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class ClosingOutTheMonthsDetailsScreen extends StatelessWidget {
  final MonthEndClosingHistoryModel? monthEndClosingHistoryModel;
  const ClosingOutTheMonthsDetailsScreen({
    super.key,
    required this.monthEndClosingHistoryModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: 'تقفيل الشهر'),
          Text(monthEndClosingHistoryModel?.date.toDate().toString().substring(0,10)??'',style:TextStyle(
            color: AppColors.primary,fontSize: 16.sp,
            fontWeight: FontWeight.bold
          ) ,),
          SizedBox(height: 10.h,),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              children: [
                Container(
                  height: 45.h,
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
                        child: Text(
                          "اسم الضابط",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "الاجمالي",
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
                ...(monthEndClosingHistoryModel?.officers ?? [])
                    .asMap()
                    .entries
                    .map((entry) {
                      final index = entry.key;
                      final e = entry.value;
                      return Accordion(
                        disableScrolling: true,
                        rightIcon: const SizedBox(),
                        headerBorderColor: (index % 2 != 0)
                            ? AppColors.borderColor
                            : AppColors.cardBackground,
                        headerBackgroundColorOpened: (index % 2 != 0)
                            ? AppColors.borderColor
                            : AppColors.cardBackground,
                        headerBorderColorOpened: AppColors.borderColor,
                        contentBorderColor: AppColors.borderColor,
                        contentBorderWidth: 2.sp,
                        paddingBetweenClosedSections: 0,
                        paddingBetweenOpenSections: 0,
                        paddingListTop: 0,
                        paddingListBottom: 0,
                        paddingListHorizontal: 0,
                        contentBorderRadius: 0,
                        headerBorderRadius: 0,
                        children: [
                          AccordionSection(
                            headerPadding: EdgeInsets.symmetric(vertical: 10.h),
                            header: FadeInUp(
                              key: ValueKey(
                                'row_${index}_${e.name}_${e.total}',
                              ),
                              duration: const Duration(milliseconds: 300),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        e.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      (e.total.toDouble())
                                          .safeCeil()
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            paddingBetweenClosedSections: 0,
                            content: Column(
                              spacing: 10.h,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "استهلاك",
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
                                        "نثريات متغيرة",
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
                                        "نثريات ثابتة",
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
                                        "هالك",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        (monthEndClosingHistoryModel
                                                    ?.officers[index]
                                                    .consumer ??
                                                0)
                                            .safeCeil()
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        ((monthEndClosingHistoryModel
                                                    ?.officers[index]
                                                    .variable ??
                                                0))
                                            .safeCeil()
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        monthEndClosingHistoryModel
                                                ?.officers[index]
                                                .fixed
                                                .safeCeil()
                                                .toString() ??
                                            "0",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        monthEndClosingHistoryModel
                                                ?.officers[index]
                                                .perish
                                                .safeCeil()
                                                .toString() ??
                                            "0",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            contentBackgroundColor: (index % 2 != 0)
                                ? AppColors.borderColor
                                : AppColors.cardBackground,
                            headerBackgroundColor: (index % 2 != 0)
                                ? AppColors.borderColor
                                : AppColors.cardBackground,
                            contentBorderWidth: 2.sp,
                            contentBorderColor: AppColors.borderColor,
                            headerBorderColorOpened: AppColors.borderColor,
                            headerBorderColor: AppColors.borderColor,
                            headerBorderWidth: 2.sp,
                          ),
                        ],
                      );
                    }),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    'حسابات اخرى',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Accordion(
                  disableScrolling: true,
                  rightIcon: const SizedBox(),
                  headerBorderColor: AppColors.borderColor,
                  headerBackgroundColorOpened: AppColors.borderColor,
                  headerBorderColorOpened: AppColors.borderColor,
                  contentBorderColor: AppColors.borderColor,
                  contentBorderWidth: 2.sp,
                  paddingBetweenClosedSections: 0,
                  paddingBetweenOpenSections: 0,
                  paddingListHorizontal: 0,
                  contentBorderRadius: 7.r,
                  headerBorderRadius: 7.r,
                  children: [
                    AccordionSection(
                      headerPadding: EdgeInsets.symmetric(vertical: 10.h),
                      header: FadeInUp(
                        duration: const Duration(milliseconds: 300),
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  'ضيافة',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                ((monthEndClosingHistoryModel
                                            ?.monthEndClosingHospitalityModel
                                            .total ??
                                        0))
                                    .safeCeil()
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      paddingBetweenClosedSections: 0,
                      content: Column(
                        spacing: 10.h,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "استهلاك",
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
                                  "نثريات متغيرة",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  monthEndClosingHistoryModel
                                          ?.monthEndClosingHospitalityModel
                                          .consumer
                                          .safeCeil()
                                          .toString() ??
                                      '0',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  (monthEndClosingHistoryModel
                                          ?.monthEndClosingHospitalityModel
                                          .variable)
                                      .safeCeil()
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      contentBackgroundColor: AppColors.borderColor,
                      headerBackgroundColor: AppColors.borderColor,
                      contentBorderWidth: 2.sp,
                      contentBorderColor: AppColors.borderColor,
                      headerBorderColorOpened: AppColors.borderColor,
                      headerBorderColor: AppColors.borderColor,
                      headerBorderWidth: 2.sp,
                    ),
                  ],
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: AppColors.borderColor,
                      borderRadius: BorderRadius.circular(7.r),
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
                              'كانتين',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            monthEndClosingHistoryModel?.canteenBalance
                                    .safeCeil()
                                    .toString() ??
                                '0',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
