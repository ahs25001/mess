import 'package:animate_do/animate_do.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mess_app/core/utils/app_enums.dart';
import 'package:mess_app/core/widgets/custom_app_bar.dart';
import 'package:mess_app/features/home/presntation/cubit/home_cubit.dart';

import '../../../../core/models/officer_model.dart';
import '../../../../core/utils/app_colors.dart';

class ListOfCategoriesForOfficersScreen extends StatelessWidget {
  const ListOfCategoriesForOfficersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getOfficers(),
      child: Scaffold(
        backgroundColor: AppColors.cardBackground,
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            print(state.officerItems?.map((e) => e?.date).toList());
            return Column(
              children: [
                    const CustomAppBar(title: 'بيان اصناف للضباط'),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: CustomDropdown<OfficerModel?>(
                              headerBuilder: (context, selectedItem, enabled) =>
                                  Text(
                                    '${selectedItem?.rank} ${selectedItem?.name}',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                              decoration: CustomDropdownDecoration(
                                expandedBorderRadius: BorderRadius.circular(10.r),
                                expandedBorder: Border.all(
                                  color: AppColors.primary,
                                ),
                                closedBorderRadius: BorderRadius.circular(10.r),
                                closedBorder: Border.all(
                                  color: AppColors.borderColor,
                                  width: 2.sp,
                                ),
                              ),
                              hintText: "اختر الضابط",
                              listItemBuilder:
                                  (context, item, isSelected, onItemSelect) =>
                                      Text(
                                         '${item?.rank} ${item?.name}',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                              items: (state.officers ?? [])
                                  .whereType<OfficerModel>()
                                  .toList(),
                              onChanged: (officer) {
                                context.read<HomeCubit>().selectOfficer(officer);
                                context.read<HomeCubit>().getOfficerItems();
                              },
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            margin: EdgeInsets.only(left: 10.w, right: 10.w),
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
                                    "سعر الوحده",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "الاجمالي",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "التاريخ",
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
                          (state.status == HomeStatus.getOfficerItemsLoading)
                              ? CircularProgressIndicator(
                                  color: AppColors.primary,
                                )
                              : (state.status ==
                                    HomeStatus.getOfficerItemsFailure)
                              ? Text(
                                  state.errorMessage ?? "",
                                  style: TextStyle(color: AppColors.red),
                                )
                              : Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: state.officerItems?.length ?? 0,
                                    itemBuilder: (context, index)
                                    {
                                      var quantity =(state
                                      .officerItems?[index]
                                        ?.quantity??0)/(state.officerItems![index]!.officersIds.length);
                                      var priceOfItem =  ((state
                                          .officerItems?[index]
                                          ?.totalPrice ??
                                          0) /
                                          (state
                                              .officerItems?[index]
                                              ?.quantity ??
                                              1))/(state.officerItems![index]!.officersIds.length);
                                      var totalPrice =   priceOfItem*quantity
                                      ;
                                      return FadeInUp(
                                      key: ValueKey(
                                        'row_${index}_${state.food?[index]
                                            ?.id}_${state.food?[index]?.name}',
                                      ),
                                      duration: const Duration(
                                          milliseconds: 300),
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                        ),
                                        height: 35.h,
                                        decoration: BoxDecoration(
                                          color: (index % 2 != 0)
                                              ? AppColors.borderColor
                                              : AppColors.cardBackground,
                                          borderRadius:
                                          (index ==
                                              (state.food?.length ?? 0) - 1)
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
                                              child: Center(
                                                child: Text(
                                                  state
                                                      .officerItems?[index]
                                                      ?.name ??
                                                      "",
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
                                                quantity
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 14.sp),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                               priceOfItem
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 14.sp),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                              totalPrice.toString() ,
                                                style: TextStyle(
                                                    fontSize: 14.sp),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                state.officerItems?[index]?.date.toDate()
                                                    .toString()
                                                    .substring(0, 10) ??
                                                    '',
                                                style: TextStyle(
                                                    fontSize: 14.sp),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );},
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
  }
}
