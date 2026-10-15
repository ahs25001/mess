import 'package:animate_do/animate_do.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/models/food_model.dart';
import '../../../../core/models/officer_model.dart';
import '../../../../core/utils/app_colors.dart';
import '../../data/models/dispensing_items_model.dart';
import '../cubit/dispensing_item_cubit.dart';

class ComboMealTab extends StatelessWidget {
  final ScrollController itemsScrollController;
  final List<DispensingItemsModel> items;
  final Function(int index) onItemDelete;
  final Function(int index) onOfficerDelete;
  final GlobalKey<FormState> itemFromKey,officerFormKey;
  final VoidCallback onAddItem,onSave,onAddOfficer;
 final  TextEditingController quantityController;
 final List<OfficerModel> officers;
  const ComboMealTab({
    super.key,
    required this.onOfficerDelete,
    required this.onAddItem,
    required this.officers,
    required this.officerFormKey,
    required this.onSave,
    required this.onAddOfficer,
    required this.quantityController,
    required this.items,
    required this.onItemDelete,
    required this.itemFromKey,
    required this.itemsScrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            "الأصناف",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            controller: itemsScrollController,
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
                              onItemDelete(index);
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
            key: itemFromKey,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    if(itemFromKey.currentState!.validate()) {
                      onAddItem();
                    }
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
                      if((value??"").trim().isEmpty){
                        return "الكمية مطلوبة";
                      }
                      return null;
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
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            "الضباط",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            controller: itemsScrollController,
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
              ...officers.asMap().entries.map((entry) {
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
                              '${e.rank} ${e.name}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              onOfficerDelete(index);
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
            key: officerFormKey,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    if(officerFormKey.currentState!.validate()) {
                      onAddOfficer();
                    }
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
                      child: CustomDropdown<OfficerModel>(
                        validator: (p0) {
                          if (p0 == null) {
                            return "إختر ضابط";
                          }
                          return null;
                        },
                        hintText: "إختر ضابط",
                        initialItem: state.selectedOfficer,
                        headerBuilder: (context, selectedOfficer, enabled) =>
                            Text(
                              '${selectedOfficer.rank} ${selectedOfficer.name}',
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
                            (context, officer, isSelected, onItemSelect) =>
                            Text(
                              '${officer.rank} ${officer.name}',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 14.sp,
                              ),
                            ),
                        items: state.officers ?? [],
                        onChanged: (p0) {
                          context.read<DispensingItemCubit>().selectOfficer(
                            p0,
                          );
                        },
                      ),
                    );
                  },
                ),

              ],
            ),
          ),
        ),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
          child: FilledButton(
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
        ),
      ],
    );
  }
}
