import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mess_app/core/utils/app_enums.dart';
import 'package:mess_app/features/financials/presntation/widgets/balance_bottom_sheet.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../cubit/financials_cubit.dart';
import '../widgets/add_money_bottom_sheet.dart';
import '../../../../core/widgets/custom_list_tile.dart';

class FinancialsScreen extends StatelessWidget {
  const FinancialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: HeroTags.financials.value,
        child: Material(
          child: BlocProvider(
            create: (context) => FinancialsCubit()..getOfficers(),
            child: BlocConsumer<FinancialsCubit, FinancialsState>(
              listener: (context, state) {
                if (state.status == FinancialsStatus.addMoneyLoading) {
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
                } else if (state.status ==
                    FinancialsStatus.getOfficersSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.invoiceAccent,
                      content: Text(
                        "تم تحميل الضباط بنجاح",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  );
                } else if (state.status == FinancialsStatus.addMoneySuccess) {
                  Navigator.pop(context); // Dismiss loading dialog
                  Navigator.pop(context); // Dismiss bottom sheet
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.invoiceAccent,
                      content: Text(
                        "تم اضافة المبلغ بنجاح",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  );
                } else if (state.status == FinancialsStatus.addMoneyFailure ||
                    state.status == FinancialsStatus.getOfficersFailure) {
                  Navigator.pop(context); // Dismiss loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      margin: EdgeInsets.only(
                        bottom: (MediaQuery.sizeOf(context).height / 3) + 70.h,
                      ),
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
                return Column(
                  children: [
                    const CustomAppBar(title: 'إدارة الماليات'),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 20.w),
                      child: Column(
                        spacing: 10.h,
                        children: [
                          CustomListTile(
                            onTab: () {
                              showModalBottomSheet(
                                showDragHandle: true,
                                isScrollControlled: true,
                                enableDrag: true,
                                context: context,
                                builder: (sheetContext) {
                                  return BlocProvider.value(
                                    value: context.read<FinancialsCubit>(),
                                    child:
                                        BlocBuilder<
                                          FinancialsCubit,
                                          FinancialsState
                                        >(
                                          builder: (context, state) {
                                            return AddMoneyBottomSheet(
                                              selectedOfficer:
                                                  state.selectedOfficer,
                                              changeSelectedOfficer: (officer) {
                                                context
                                                    .read<FinancialsCubit>()
                                                    .changeSelectedOfficer(
                                                      officer,
                                                    );
                                              },

                                              amountController: context
                                                  .read<FinancialsCubit>()
                                                  .amountController,
                                              officers: state.officers ?? [],
                                              onSubmit: () => _onAddMoneySubmit(
                                                context,
                                                state,
                                              ),
                                            );
                                          },
                                        ),
                                  );
                                },
                              );
                            },
                            title: 'تحصيل مبلغ',
                            animatedIconPath:
                                'assets/json/add_money_animated_icon.json',
                          ),
                          CustomListTile(
                            onTab: () {},
                            title: 'المبلغ المتبقي',
                            animatedIconPath:
                                'assets/json/the_remaining_amount_animated_icon.json',
                          ),
                          CustomListTile(
                            onTab: () {},
                            title: 'تقفيل الشهر',
                            animatedIconPath:
                                'assets/json/closing_accounts_animated_icon.json',
                          ),
                          CustomListTile(
                            onTab: () {
                              showModalBottomSheet(
                                context: context,
                                showDragHandle: true,
                                enableDrag: true,
                                builder: (contextSheet) {
                                  return BlocProvider.value(
                                    value: context.read<FinancialsCubit>(),
                                    child:
                                        BlocBuilder<
                                          FinancialsCubit,
                                          FinancialsState
                                        >(
                                          builder: (context, state) =>
                                              BalanceBottomSheet(
                                                officers: state.officers,
                                              ),
                                        ),
                                  );
                                },
                              );
                            },
                            title: 'رصيد الضباط',
                            animatedIconPath:
                                'assets/json/oficerres_amount_animated_icon.json',
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onAddMoneySubmit(BuildContext context, FinancialsState state) {
    if (state.selectedOfficer != null &&
        context
            .read<FinancialsCubit>()
            .amountController
            .text
            .trim()
            .isNotEmpty) {
      context.read<FinancialsCubit>().addMoney();
    } else if (state.selectedOfficer == null &&
        context
            .read<FinancialsCubit>()
            .amountController
            .text
            .trim()
            .isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: (MediaQuery.sizeOf(context).height / 3) + 70.h,
          ),
          backgroundColor: AppColors.red,
          content: Text(
            "اختر ضابط",
            style: TextStyle(color: AppColors.white, fontSize: 14.sp),
          ),
        ),
      );
    } else if (context
            .read<FinancialsCubit>()
            .amountController
            .text
            .trim()
            .isEmpty &&
        state.selectedOfficer != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: (MediaQuery.sizeOf(context).height / 3) + 70.h,
          ),
          backgroundColor: AppColors.red,
          content: Text(
            'ادخل المبلغ',
            style: TextStyle(color: AppColors.white, fontSize: 14.sp),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: (MediaQuery.sizeOf(context).height / 3) + 70.h,
          ),
          backgroundColor: AppColors.red,
          content: Text(
            'اختر الضابط وادخل المبلغ',
            style: TextStyle(color: AppColors.white, fontSize: 14.sp),
          ),
        ),
      );
    }
  }
}
