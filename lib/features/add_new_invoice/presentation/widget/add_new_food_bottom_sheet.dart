import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mess_app/core/utils/app_colors.dart';

class AddNewFoodBottomSheet extends StatelessWidget {
  final TextEditingController nameController;
  final bool isFixedMiscellaneousExpenses;
  final bool isVariableMiscellaneousExpenses;
  final Function(bool value) onFixedMiscellaneousExpensesChange;
  final Function(bool value) onVariableMiscellaneousExpensesChange;
  final VoidCallback onSave;
  const AddNewFoodBottomSheet({
    super.key,
    required this.nameController,
    required this.isFixedMiscellaneousExpenses,
    required this.onSave,
    required this.isVariableMiscellaneousExpenses,
    required this.onFixedMiscellaneousExpensesChange,
    required this.onVariableMiscellaneousExpensesChange,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                  color: AppColors.borderColor,
                  width: 2.sp,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: AppColors.primary, width: 2.sp),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                  color: AppColors.borderColor,
                  width: 2.sp,
                ),
              ),
              hintText: "اسم الصنف",
              hintStyle: TextStyle(
                color: AppColors.borderColor,
                fontSize: 16.sp,
              ),
            ),
            style: TextStyle(fontSize: 16.sp, color: AppColors.black),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Checkbox(
                checkColor: AppColors.white,
                activeColor: AppColors.primary,
                value: isVariableMiscellaneousExpenses,
                onChanged: (value) {
                  onVariableMiscellaneousExpensesChange(value ?? false);
                },
                semanticLabel: "نثريات متغيرة",
              ),
              SizedBox(width: 8.w),
              Text(
                "نثريات متغيرة",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                checkColor: AppColors.white,
                activeColor: AppColors.primary,
                value: isFixedMiscellaneousExpenses,
                onChanged: (value) =>
                    onFixedMiscellaneousExpensesChange(value ?? false),
                semanticLabel: "نثريات ثابتة",
              ),
              SizedBox(width: 8.w),
              Text(
                "نثريات ثابتة",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: Size(double.infinity, 50.h),
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10.r),
              ),
            ),
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.sizeOf(context).height / 2 - 90.h,
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.red,
                    content: Text(
                      "الاسم مطلوب",
                      style: TextStyle(color: AppColors.white, fontSize: 14.sp),
                    ),
                  ),
                );
              } else {
                onSave();
              }
            },
            child: Text(
              "حفظ",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
