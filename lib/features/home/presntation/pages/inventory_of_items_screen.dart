import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mess_app/core/utils/app_enums.dart';
import 'package:mess_app/features/home/presntation/cubit/home_cubit.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class InventoryOfItemsScreen extends StatelessWidget {
  const InventoryOfItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getFood(),
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBar(title: "جرد الأصناف"),
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
                ],
              ),
            ),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return (state.status == HomeStatus.getFoodLoading)
                    ? CircularProgressIndicator(color: AppColors.primary)
                    :(state.status == HomeStatus.getFoodFailure)?Text(state.errorMessage??"",style: TextStyle(color: AppColors.red,),): Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: state.food?.length ?? 0,
                          itemBuilder: (context, index) => FadeInUp(
                            key: ValueKey(
                              'row_${index}_${state.food?[index]?.id}_${state.food?[index]?.name}',
                            ),
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.w),
                              height: 35.h,
                              decoration: BoxDecoration(
                                color: (index % 2 != 0)
                                    ? AppColors.borderColor
                                    : AppColors.cardBackground,
                                borderRadius:
                                    (index == (state.food?.length ?? 0) - 1)
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
                                        state.food?[index]?.name ?? "",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      state.food?[index]?.quantity.toString() ??
                                          '',
                                      style: TextStyle(fontSize: 14.sp),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
