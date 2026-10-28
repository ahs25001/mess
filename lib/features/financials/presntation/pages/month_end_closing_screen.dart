import 'package:accordion/accordion.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mess_app/core/widgets/custom_app_bar.dart';
import 'package:mess_app/features/financials/presntation/cubit/financials_cubit.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_enums.dart';

class MonthEndClosingScreen extends StatelessWidget {
  const MonthEndClosingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FinancialsCubit(),
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBar(title: 'تقفيل الشهر'),
            BlocConsumer<FinancialsCubit, FinancialsState>(
              listener: (context, state) {
                if(state.status==FinancialsStatus.saveMonthEndClosingSuccess){
                  Navigator.pop(context); // Dismiss loading dialog
                  Navigator.pop(context); // Dismiss bottom sheet
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.invoiceAccent,
                      content: Text(
                        "تم إتمام العملية بنجاح",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  );
                }else if(state.status==FinancialsStatus.saveMonthEndClosingLoading){
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => PopScope(
                      canPop: false,
                      child: const AlertDialog(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        content: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  );
                }else if (state.status==FinancialsStatus.saveMonthEndClosingFailure){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.red,
                      content: Text(
                        state.errorMessage ?? "",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.status ==
                    FinancialsStatus.createMonthEndClosingSuccess||state.status==FinancialsStatus.saveMonthEndClosingFailure) {
                  return Expanded(
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
                        ...(state.monthEndClosing?.officers ?? []).asMap().entries.map((
                          entry,
                        ) {
                          final index = entry.key;
                          final e = entry.value;
                          return Accordion(
                            disableScrolling: true,
                            rightIcon: SizedBox(),
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
                                headerPadding: EdgeInsets.symmetric(
                                  vertical: 10.h,
                                ),
                                header: FadeInUp(
                                  key: ValueKey(
                                    'row_${index}_${e?.id ?? ''}_${e?.name}',
                                  ),
                                  duration: const Duration(milliseconds: 300),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            '${e?.rank} ${e?.name}',
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
                                          ((state.capital ?? 0) -
                                                  ((state
                                                              .officers?[index]
                                                              .amount ??
                                                          0) -
                                                      ((state
                                                                      .monthEndClosing
                                                                      ?.variable ??
                                                                  0) *
                                                              (state
                                                                      .officers?[index]
                                                                      .consumer ??
                                                                  0) +
                                                          (state
                                                                  .monthEndClosing
                                                                  ?.fixed ??
                                                              0) +
                                                          (state
                                                                  .monthEndClosing
                                                                  ?.perishes ??
                                                              0))))
                                              .ceil()
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
                                            (state.officers?[index].consumer ??
                                                    0)
                                                .ceil()
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
                                            ((state.monthEndClosing?.variable ??
                                                        0) *
                                                    (state
                                                            .officers?[index]
                                                            .consumer ??
                                                        0))
                                                .ceil()
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
                                            state.monthEndClosing?.fixed
                                                    .toString() ??
                                                "",
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
                                            state.monthEndClosing?.perishes
                                                    .ceil()
                                                    .toString() ??
                                                "",
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
                          rightIcon: SizedBox(),
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
                              headerPadding: EdgeInsets.symmetric(
                                vertical: 10.h,
                              ),
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
                                        ((state.monthEndClosing?.hospitality ??
                                                    0) *
                                                (1 +
                                                    (state
                                                            .monthEndClosing
                                                            ?.variable ??
                                                        0)))
                                            .ceil()
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
                                          state.monthEndClosing?.hospitality
                                                  .ceil()
                                                  .toString() ??
                                              '',
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
                                          ((state
                                                          .monthEndClosing
                                                          ?.hospitality ??
                                                      0) *
                                                  (state
                                                              .monthEndClosing
                                                              ?.variable ??
                                                          0)
                                                      .ceil())
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
                                    state.monthEndClosing?.canteen.toString() ??
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
                  );
                }
                else if (state.status ==
                        FinancialsStatus.createMonthEndClosingLoading ||
                    state.status == FinancialsStatus.getInvoicesLoading ||
                    state.status == FinancialsStatus.getOfficersLoading ||
                    state.status == FinancialsStatus.getPerishesLoading ||
                    state.status == FinancialsStatus.getCapitalLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                } else {
                  return Center(
                    child: Text(
                      state.errorMessage ?? '',
                      style: TextStyle(
                        color: AppColors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.sp,
                      ),
                    ),
                  );
                }
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: BlocBuilder<FinancialsCubit, FinancialsState>(
                builder: (context, state) {
                  return FilledButton(
                    onPressed: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (dialogContext) {
                          return BlocProvider.value(
                            value: context.read<FinancialsCubit>(),
                            child: PopScope(
                              canPop: false,
                              child:
                                  BlocBuilder<FinancialsCubit, FinancialsState>(
                                    builder: (context, state) {
                                      return AlertDialog(
                                        title: Center(
                                          child: Text(
                                            'تنبيه',
                                            style: TextStyle(
                                              color: AppColors.red,
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          FilledButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: FilledButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              minimumSize: Size(
                                                (MediaQuery.sizeOf(
                                                          context,
                                                        ).width /
                                                        2) -
                                                    70.w,
                                                40.h,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  color: AppColors.red,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                              ),
                                            ),
                                            child: Text(
                                              "إلغاء",
                                              style: TextStyle(
                                                color: AppColors.red,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          FilledButton(
                                            onPressed: () {
                                              context
                                                  .read<FinancialsCubit>()
                                                  .saveMonthEndClosing();
                                            },
                                            style: FilledButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primary,
                                              minimumSize: Size(
                                                (MediaQuery.sizeOf(
                                                          context,
                                                        ).width /
                                                        2) -
                                                    70.w,
                                                40.h,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                              ),
                                            ),
                                            child: Text(
                                              "تمام",
                                              style: TextStyle(
                                                color: AppColors.white,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                        content: Text(
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          'عند إتمام هذه العملية سيتم حذف جميع الفواتير وإنشاء فاتورة مرحله وتعديل رصيد الضباط!',
                                        ),
                                      );
                                    },
                                  ).zoomIn(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOutBack,
                                  ),
                            ),
                          );
                        },
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: Size(double.infinity, 40.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'إتمام العملية',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
