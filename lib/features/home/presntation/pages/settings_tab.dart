import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mess_app/config/routes/app_routes.dart';
import 'package:mess_app/core/utils/app_enums.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_list_tile.dart';
import '../cubit/home_cubit.dart';
import '../widgets/update_capital_dialog.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        print("${state.status} ${state.progress}");
        if (state.status == HomeStatus.exportDatabaseLoading ||
            state.status == HomeStatus.importDatabaseLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => PopScope(
              canPop: false,
              child: BlocProvider.value(
                value: context.read<HomeCubit>(),
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    final isExport = state.status == HomeStatus.exportDatabaseLoading;
                    final title = isExport
                        ? "جاري تصدير قاعدة البيانات..."
                        : "جاري استيراد قاعدة البيانات...";
                    final double progress = state.progress ?? 0.0;
                    final int percentage = (progress * 100).clamp(0, 100).toInt();

                    return AlertDialog(
                      backgroundColor: AppColors.cardBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      content: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 75.w,
                                  height: 75.w,
                                  child: CircularProgressIndicator(
                                    value: progress > 0 ? progress : null,
                                    color: AppColors.primary,
                                    backgroundColor: AppColors.primary.withOpacity(0.15),
                                    strokeWidth: 6.w,
                                  ),
                                ),
                                Text(
                                  "$percentage%",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: LinearProgressIndicator(
                                value: progress > 0 ? progress : null,
                                color: AppColors.primary,
                                backgroundColor: AppColors.primary.withOpacity(0.15),
                                minHeight: 6.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        } else if (state.status == HomeStatus.exportDatabaseSuccess) {
          Navigator.of(context, rootNavigator: true).pop(); // dismiss loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.invoiceAccent,
              content: Text(
                "تم تصدير قاعدة البيانات بنجاح",
                style: TextStyle(color: AppColors.white, fontSize: 14.sp),
              ),
            ),
          );
        } else if (state.status == HomeStatus.importDatabaseSuccess) {
          Navigator.of(context, rootNavigator: true).pop(); // dismiss loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.invoiceAccent,
              content: Text(
                "تم استيراد قاعدة البيانات وتحديثها بنجاح",
                style: TextStyle(color: AppColors.white, fontSize: 14.sp),
              ),
            ),
          );
        } else if (state.status == HomeStatus.exportDatabaseFailure ||
            state.status == HomeStatus.importDatabaseFailure) {
          Navigator.of(context, rootNavigator: true).pop(); // dismiss loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.red,
              content: Text(
                state.errorMessage ?? "حدث خطأ أثناء العملية",
                style: TextStyle(color: AppColors.white, fontSize: 14.sp),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            spacing: 10.h,
            children: [
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 100),
                child: CustomListTile(
                  title: 'تعديل بيانات ضابط',
                  animatedIconPath: 'assets/json/profile setup.json',
                  onTab: () {
                    Navigator.pushNamed(context, AppRoutes.updateOfficerScreen);
                  },
                ),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 200),
                child: CustomListTile(
                  title: 'تعديل التأسيس',
                  animatedIconPath: 'assets/json/money_animated_icon.json',
                  onTab: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (dialogContext) => BlocProvider.value(
                        value: context.read<HomeCubit>(),
                        child: BlocBuilder<HomeCubit, HomeState>(
                          builder: (context, state) {
                            return UpdateCapitalDialog(
                              controller: context
                                  .read<HomeCubit>()
                                  .updateCapitalController,
                              onSave: () {
                                if (context
                                        .read<HomeCubit>()
                                        .updateCapitalController
                                        .text
                                        .trim()
                                        .isNotEmpty &&
                                    context
                                            .read<HomeCubit>()
                                            .updateCapitalController
                                            .text
                                            .trim() !=
                                        '0') {
                                  context.read<HomeCubit>().setCapital();
                                } else {
                                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: AppColors.red,
                                      content: Text(
                                        'أدخل التأسيس',
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 200),
                child: CustomListTile(
                  title: 'تصدير قاعدة البيانات',
                  animatedIconPath: 'assets/json/money_animated_icon.json',
                  onTab: () {
                    context.read<HomeCubit>().exportDatabase();
                  },
                ),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 200),
                child: CustomListTile(
                  title: 'استيراد قاعدة البيانات',
                  animatedIconPath: 'assets/json/money_animated_icon.json',
                  onTab: () {
                    context.read<HomeCubit>().importDatabase();
                  },
                ),
              ),
              SizedBox(height: 20.h),
              FloatingActionButton(
                heroTag: HeroTags.aboutUs.value,
                backgroundColor: AppColors.backgroundCanvas,
                shape: CircleBorder(side: BorderSide(color: AppColors.primary)),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.aboutUs);
                },
                child: Icon(
                  Icons.question_mark,
                  color: AppColors.primary,
                  size: 30.sp,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
