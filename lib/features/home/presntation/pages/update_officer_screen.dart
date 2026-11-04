import 'package:animate_do/animate_do.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mess_app/core/models/officer_model.dart';
import 'package:mess_app/core/widgets/custom_app_bar.dart';
import 'package:mess_app/features/home/presntation/cubit/home_cubit.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_enums.dart';
import '../../../../core/widgets/custom_officer_text_field_data.dart';

class UpdateOfficerScreen extends StatelessWidget {
  const UpdateOfficerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: HeroTags.updateOfficerScreen.value,
        child: Material(
          color: AppColors.backgroundCanvas,
          child: BlocProvider(
            create: (context) => HomeCubit()..getOfficers(),
            child: Column(
              children: [
                const CustomAppBar(title: 'تعديل بيانات الضابط'),
                BlocConsumer<HomeCubit, HomeState>(
                  listener: (context, state) {
                    if (state.status == HomeStatus.updateOfficerLoading ||
                        state.status == HomeStatus.deleteOfficerLoading) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const PopScope(
                          canPop: false,
                          child: AlertDialog(
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
                        HomeStatus.updateOfficerSuccess) {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pop(); // Dismiss loading dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.invoiceAccent,
                          content: Text(
                            "تم تحديث بيانات الضابط بنجاح",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      );
                      Navigator.pop(context); // Close screen
                    } else if (state.status ==
                        HomeStatus.deleteOfficerSuccess) {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pop(); // Dismiss loading dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.invoiceAccent,
                          content: Text(
                            "تم حذف الضابط بنجاح",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      );
                      Navigator.pop(context); // Close screen
                    } else if (state.status ==
                            HomeStatus.updateOfficerFailure ||
                        state.status == HomeStatus.deleteOfficerFailure) {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pop(); // Dismiss loading dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.red,
                          content: Text(
                            state.errorMessage ?? "حدث خطأ ما",
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
                    return Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Form(
                          key: context.read<HomeCubit>().formKey,
                          child: Column(
                            spacing: 10.h,
                            children: [
                              CustomDropdown<OfficerModel?>(
                                headerBuilder:
                                    (context, selectedItem, enabled) => Text(
                                        '${selectedItem?.rank} ${selectedItem?.name}',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                decoration: CustomDropdownDecoration(
                                  expandedBorderRadius: BorderRadius.circular(
                                    10.r,
                                  ),
                                  expandedBorder: Border.all(
                                    color: AppColors.primary,
                                  ),
                                  closedBorderRadius: BorderRadius.circular(
                                    10.r,
                                  ),
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
                                  context.read<HomeCubit>().selectOfficer(
                                    officer,
                                  );
                                },
                              ),
                              CustomOfficerTextFieldData(
                                onSubmitted: () {
                                  context
                                      .read<HomeCubit>()
                                      .militaryIDNumberFocusNode
                                      .requestFocus();
                                },
                                validator: (value) {
                                  if ((value ?? "").trim().isEmpty) {
                                    return 'الاسم مطلوب';
                                  }
                                  return null;
                                },
                                controller: context
                                    .read<HomeCubit>()
                                    .nameController,
                                focusNode: context
                                    .read<HomeCubit>()
                                    .nameFocusNode,
                                label: "اسم الضابط",
                                textInputAction: TextInputAction.next,
                              ),
                              CustomDropdown<String>(
                                headerBuilder:
                                    (context, selectedItem, enabled) => Text(
                                      selectedItem,
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                initialItem:
                                    state.selectedRank ??
                                    AppConstants.rankList[9],
                                decoration: CustomDropdownDecoration(
                                  expandedBorderRadius: BorderRadius.circular(
                                    10.r,
                                  ),
                                  expandedBorder: Border.all(
                                    color: AppColors.primary,
                                  ),
                                  closedBorderRadius: BorderRadius.circular(
                                    10.r,
                                  ),
                                  closedBorder: Border.all(
                                    color: AppColors.borderColor,
                                    width: 2.sp,
                                  ),
                                ),
                                items: AppConstants.rankList,
                                onChanged: (rank) {
                                  context.read<HomeCubit>().selectRank(
                                    rank ?? "",
                                  );
                                },
                              ),
                              CustomOfficerTextFieldData(
                                onSubmitted: () {
                                  context
                                      .read<HomeCubit>()
                                      .phoneFocusNode
                                      .requestFocus();
                                },
                                validator: (value) {
                                  if (!(RegExp(
                                    r'^\d+$',
                                  ).hasMatch(value ?? ""))) {
                                    return 'الرقم غير صالح';
                                  }
                                  return null;
                                },
                                controller: context
                                    .read<HomeCubit>()
                                    .militaryIDNumberController,
                                focusNode: context
                                    .read<HomeCubit>()
                                    .militaryIDNumberFocusNode,
                                label: "الرقم العسكري",
                                isNumber: true,
                                textInputAction: TextInputAction.next,
                              ),
                              CustomOfficerTextFieldData(
                                onSubmitted: () {
                                  FocusScope.of(context).unfocus();
                                },
                                maxLength: 11,
                                validator: (value) {
                                  if (!(RegExp(
                                    r'^01[0125]\d{8}$',
                                  ).hasMatch(value ?? ""))) {
                                    return 'أدخل رقم هاتف صحيح';
                                  }
                                  return null;
                                },
                                controller: context
                                    .read<HomeCubit>()
                                    .phoneController,
                                focusNode: context
                                    .read<HomeCubit>()
                                    .phoneFocusNode,
                                isNumber: true,
                                label: "رقم التليفون",
                                textInputAction: TextInputAction.done,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "نشاط الضابط",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Switch(
                                    activeTrackColor: AppColors.primary,
                                    value: state.isOfficerActive ?? true,
                                    onChanged: (value) {
                                      if (state.selectedOfficer == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            backgroundColor: AppColors.red,
                                            content: Text(
                                              "الرجاء اختيار الضابط أولاً",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        context
                                            .read<HomeCubit>()
                                            .changeOfficerActivity(value);
                                      }
                                    },
                                  ),
                                  const Spacer(),
                                  FilledButton(
                                    onPressed: () {
                                      if (state.selectedOfficer == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            backgroundColor: AppColors.red,
                                            content: Text(
                                              "الرجاء اختيار الضابط أولاً",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      showDialog(
                                        context: context,
                                        builder: (dialogContext) =>
                                            AlertDialog(
                                              title: Text(
                                                "تأكيد الحذف",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: AppColors.red,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              content: Text(
                                                "هل أنت تأكد من حذف هذا الضابط؟",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              actions: [
                                                FilledButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                        dialogContext,
                                                      ),
                                                  style: FilledButton.styleFrom(
                                                    side: BorderSide(
                                                      color: AppColors.primary,
                                                    ),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadiusGeometry.circular(
                                                            10.r,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "إلغاء",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16.sp,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                ),
                                                FilledButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                      dialogContext,
                                                    );
                                                    context
                                                        .read<HomeCubit>()
                                                        .deleteOfficer();
                                                  },
                                                  style: FilledButton.styleFrom(
                                                    side: BorderSide(
                                                      color: AppColors.red,
                                                    ),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadiusGeometry.circular(
                                                            10.r,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "حذف",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16.sp,
                                                      color: AppColors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ).zoomIn(
                                              duration: Duration(
                                                milliseconds: 300,
                                              ),
                                              curve: Curves.easeInOutBack,
                                            ),
                                      );
                                    },
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      minimumSize: Size(100.w, 40.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                        side: const BorderSide(
                                          color: AppColors.red,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      "حذف الضابط",
                                      style: TextStyle(
                                        color: AppColors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              FilledButton(
                                onPressed: () {
                                  if (state.selectedOfficer == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: AppColors.red,
                                        content: Text(
                                          "الرجاء اختيار الضابط أولاً",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  if (context
                                      .read<HomeCubit>()
                                      .formKey
                                      .currentState!
                                      .validate()) {
                                    context.read<HomeCubit>().updateOfficer();
                                  }
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  minimumSize: Size(double.infinity, 40.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                child: Text(
                                  "تحديث البيانات",
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
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
