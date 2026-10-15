import 'package:animate_do/animate_do.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/models/food_model.dart';
import '../../../../core/models/officer_model.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_enums.dart';
import '../../data/models/dispensing_items_model.dart';
import '../cubit/dispensing_item_cubit.dart';

class DispensingItemsTab extends StatelessWidget {
  final DispensingItemsTabType dispensingItemsTabType;
  final List<OfficerModel>? officers;
  final List<DispensingItemsModel> items;
  final Function(int index) onDelete;
  final TextEditingController quantityController;
  final ScrollController scrollController;
  final Function(String? value) addItemValidator;
  final Function(OfficerModel? officer) selectOfficer;
  final GlobalKey<FormState> fromKey;
  final VoidCallback onCanteenChecked,
      onHarmonyChecked,
      onHospitalityChecked,
      onAddItem,
      onSave,
      onOfficerChecked;

  const DispensingItemsTab({
    super.key,
    required this.selectOfficer,
    required this.onSave,
    required this.dispensingItemsTabType,
    required this.fromKey,
    required this.scrollController,
    required this.quantityController,
    required this.addItemValidator,
    required this.onAddItem,
    required this.items,
    required this.onDelete,
    required this.officers,
    required this.onCanteenChecked,
    required this.onHarmonyChecked,
    required this.onHospitalityChecked,
    required this.onOfficerChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      alignment: Alignment.center,
                      child: child,
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey(dispensingItemsTabType),
                    child: switch (dispensingItemsTabType) {
                      DispensingItemsTabType.isCanteen => Text(
                        'الكانتين',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DispensingItemsTabType.isHarmony => Text(
                        'هالك',
                        style: TextStyle(
                          color: AppColors.red,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DispensingItemsTabType.isHospitality => Text(
                        'ضيافة',
                        style: TextStyle(
                          color: AppColors.invoiceAccent,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DispensingItemsTabType.init => Wrap(
                        spacing: 8.w,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                checkColor: AppColors.white,
                                activeColor: AppColors.primary,
                                value:
                                    dispensingItemsTabType ==
                                    DispensingItemsTabType.isCanteen,
                                onChanged: (value) {
                                  onCanteenChecked();
                                },
                              ),
                              Text(
                                'كانتين',
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
                                value:
                                    dispensingItemsTabType ==
                                    DispensingItemsTabType.isHarmony,
                                onChanged: (value) {
                                  onHarmonyChecked();
                                },
                              ),
                              Text(
                                'هالك',
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
                                value:
                                    dispensingItemsTabType ==
                                    DispensingItemsTabType.isHospitality,
                                onChanged: (value) {
                                  onHospitalityChecked();
                                },
                              ),
                              Text(
                                'ضيافة',
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
                                value:
                                    dispensingItemsTabType ==
                                    DispensingItemsTabType.isOfficer,
                                onChanged: (value) {
                                  onOfficerChecked();
                                },
                              ),
                              Text(
                                'ضابط',
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
                      DispensingItemsTabType.isOfficer =>
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
                              (context, officer, isSelected, onItemSelect) =>
                                  Text(
                                    "${officer.rank} ${officer.name}",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                          decoration: CustomDropdownDecoration(
                            closedFillColor: Colors.transparent,
                            expandedBorderRadius: BorderRadius.circular(16.r),
                            expandedBorder: Border.all(
                              color: AppColors.primary,
                            ),
                            closedBorder: Border.all(
                              color: AppColors.borderColor,
                              width: 2.sp,
                            ),
                            closedBorderRadius: BorderRadius.circular(16.r),
                          ),
                          items: officers ?? [],
                          onChanged: (selectedOfficer) {
                            selectOfficer(selectedOfficer);
                          },
                        ),
                    },
                  ),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Container(
                        height: 35.h,
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
                              flex: 2,
                              child: Text(
                                "اسم الصنف",
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
                                "الكمية",
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
                                "إجراء",
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
                      ...items.asMap().entries.map((entry) {
                        final index = entry.key;
                        final e = entry.value;
                        return FadeInUp(
                          key: ValueKey('row_${index}_${e.id}_${e.name}'),
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            height: 35.h,
                            decoration: BoxDecoration(
                              color: (index % 2 != 0)
                                  ? AppColors.borderColor
                                  : AppColors.cardBackground,
                              borderRadius: (index == items.length - 1)
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
                                  flex: 2,
                                  child: Center(
                                    child: Text(
                                      e.name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    e.quantity.toString(),
                                    style: TextStyle(fontSize: 14.sp),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      onDelete(index);
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      size: 20.sp,
                                      color: AppColors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.r),
              bottomRight: Radius.circular(10.r),
            ),
            border: Border(
              bottom: BorderSide(color: AppColors.borderColor, width: 2.w),
              left: BorderSide(color: AppColors.borderColor, width: 2.w),
              right: BorderSide(color: AppColors.borderColor, width: 2.w),
            ),
            color: AppColors.softBlue,
          ),
          child: Form(
            key: fromKey,
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        onAddItem();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.r),
                          color: AppColors.invoiceAccent,
                        ),
                        child: Icon(
                          Icons.add,
                          color: AppColors.white,
                          size: 25.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    BlocBuilder<DispensingItemCubit, DispensingItemState>(
                      builder: (context, state) {
                        return Expanded(
                          flex: 3,
                          child: CustomDropdown<FoodModel>(
                            validator: (p0) {
                              if (p0 == null) {
                                return "إختر صنف";
                              }
                              return null;
                            },
                            hintText: "إختر الصنف",
                            initialItem: state.selectedFood,
                            headerBuilder: (context, selectedItem, enabled) =>
                                Text(
                                  selectedItem.name,
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14.sp,
                                  ),
                                ),

                            decoration: CustomDropdownDecoration(
                              closedFillColor: AppColors.cardBackground,
                              closedBorderRadius: BorderRadius.circular(10.r),
                            ),
                            listItemBuilder:
                                (context, item, isSelected, onItemSelect) =>
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                            items: state.availableFoods ?? [],
                            onChanged: (p0) {
                              context.read<DispensingItemCubit>().selectFood(
                                p0,
                              );
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: quantityController,
                        validator: (value) {
                          return addItemValidator(value);
                        },
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 12.sp),
                        decoration: InputDecoration(
                          hintText: 'الكمية',
                          hintStyle: TextStyle(fontSize: 12.sp),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 5.h,
                            horizontal: 10.w,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: AppColors.borderColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: AppColors.borderColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                FilledButton(
                  onPressed: () {
                    onSave();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: Size(double.infinity, 40.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    'حفظ',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
