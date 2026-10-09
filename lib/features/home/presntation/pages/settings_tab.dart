import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_list_tile.dart';
import '../cubit/home_cubit.dart';
import '../widgets/update_capital_dialog.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        spacing: 10.h,
        children: [
          CustomListTile(
            title: 'تعديل بيانات ضابط',
            animatedIconPath: 'assets/json/profile setup.json',
            onTab: () {},
          ),
          CustomListTile(
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
                          if(context.read<HomeCubit>().updateCapitalController.text.trim().isNotEmpty) {
                            context.read<HomeCubit>().setCapital();
                          }else{
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
          CustomListTile(
            title: 'تعديل بيانات الوحدة',
            animatedIconPath: 'assets/json/update-data.json',
            onTab: () {},
          ),
        ],
      ),
    );
  }
}
