import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mess_app/core/models/officer_model.dart';
import 'package:mess_app/core/utils/app_colors.dart';

import '../../../../core/utils/app_enums.dart';

class AddMoneyBottomSheet extends StatelessWidget {
  final List<OfficerModel> officers;
  final TextEditingController amountController;
  final VoidCallback onSubmit;
  final OfficerModel? selectedOfficer;
  final AddMoneyMode addMoneyMode;
  final Function(AddMoneyMode mode) changeAddMoneyMode;
  final Function(OfficerModel? officer) changeSelectedOfficer;
  const AddMoneyBottomSheet({
    super.key,
    required this.selectedOfficer,
    required this.changeAddMoneyMode,
    required this.addMoneyMode,
    required this.officers,
    required this.changeSelectedOfficer,
    required this.amountController,
    required this.onSubmit,
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
          Text(
            "تحصيل مبلغ",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 20.h),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: switch (addMoneyMode) {
              AddMoneyMode.init =>  Wrap(
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.start,
                alignment: WrapAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        checkColor: AppColors.white,
                        activeColor: AppColors.primary,
                        value: addMoneyMode == AddMoneyMode.addToCanteen,
                        onChanged: (bool? value) {
                          changeAddMoneyMode(AddMoneyMode.addToCanteen);
                        },
                      ),
                      Text(
                        'تحصيل من كانتين',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        checkColor: AppColors.white,
                        activeColor: AppColors.primary,
                        value: addMoneyMode == AddMoneyMode.addToOfficer,
                        onChanged: (bool? value) {
                          changeAddMoneyMode(AddMoneyMode.addToOfficer);
                        },
                      ),
                      Text(
                        'تحصيل من ضابط',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        checkColor: AppColors.white,
                        activeColor: AppColors.primary,
                        value: addMoneyMode == AddMoneyMode.addToHospitality,
                        onChanged: (bool? value) {
                          changeAddMoneyMode(AddMoneyMode.addToHospitality);
                        },
                      ),
                      Text(
                        'تحصيل من ضيافة',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              AddMoneyMode.addToCanteen => TextFormField(
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'المبلغ',
                  hintStyle: TextStyle(color: AppColors.hintColor),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 10.w,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.borderColor,
                      width: 2.sp,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.borderColor,
                      width: 2.sp,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),

              AddMoneyMode.addToOfficer => Column(
                children: [
                  CustomDropdown<OfficerModel>(
                    hintText: 'إختر الضابط',
                    headerBuilder: (context, officer, enabled) => Text(
                      "${officer.rank} ${officer.name}",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    listItemBuilder:
                        (context, officer, isSelected, onItemSelect) => Text(
                          "${officer.rank} ${officer.name}",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    initialItem: selectedOfficer,
                    decoration: CustomDropdownDecoration(
                      closedFillColor: Colors.transparent,
                      expandedBorderRadius: BorderRadius.circular(16.r),
                      expandedBorder: Border.all(color: AppColors.primary),
                      closedBorder: Border.all(
                        color: AppColors.borderColor,
                        width: 2.sp,
                      ),
                      closedBorderRadius: BorderRadius.circular(16.r),
                    ),
                    items: officers,
                    onChanged: (selectedOfficer) {
                      changeSelectedOfficer(selectedOfficer);
                    },
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'المبلغ',
                      hintStyle: TextStyle(color: AppColors.hintColor),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 10.w,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.borderColor,
                          width: 2.sp,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.borderColor,
                          width: 2.sp,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ],
              ),
              AddMoneyMode.addToHospitality => TextFormField(
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'المبلغ',
                  hintStyle: TextStyle(color: AppColors.hintColor),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 10.w,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.borderColor,
                      width: 2.sp,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.borderColor,
                      width: 2.sp,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
            },
          ),

          SizedBox(height: 20.h),
          FilledButton(
            onPressed: () {
              onSubmit();
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: Size(double.infinity, 40.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              "إضافة المبلغ",
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
