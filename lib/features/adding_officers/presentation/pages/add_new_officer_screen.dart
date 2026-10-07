import 'package:animate_do/animate_do.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mess_app/core/utils/app_colors.dart';
import 'package:mess_app/core/utils/app_constants.dart';
import 'package:mess_app/features/adding_officers/presentation/cubit/add_new_officer_cubit.dart';
import 'package:mess_app/features/adding_officers/presentation/widgets/custom_officer_text_field_data.dart';

import '../../../../core/utils/app_enums.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class AddNewOfficerScreen extends StatelessWidget {
  const AddNewOfficerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddNewOfficerCubit(),
      child: Scaffold(
        body: BlocConsumer<AddNewOfficerCubit, AddNewOfficerState>(
          listener: (context, state) {
            if (state.status == AddNewOfficerStateStatus.success) {
              Navigator.pop(context); // Dismiss loading dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.invoiceAccent,
                  content: Text(
                    "تم اضافة الضابط بنجاح",
                    style: TextStyle(color: AppColors.white, fontSize: 14.sp),
                  ),
                ),
              );
            } else if (state.status == AddNewOfficerStateStatus.failure) {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pop(); // Dismiss loading dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.red,
                  content: Text(
                    state.message ?? "",
                    style: TextStyle(color: AppColors.white, fontSize: 14.sp),
                  ),
                ),
              );
            } else if (state.status == AddNewOfficerStateStatus.loading) {
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
            }
          },
          builder: (context, state) {
            return Form(
              key: context.read<AddNewOfficerCubit>().formKey,
              child: Hero(
                tag: HeroTags.addNewOfficer.value,
                child: Material(
                  child: Column(
                    children: [
                      const CustomAppBar(title: "إضافة ضابط جديد"),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            spacing: 10.h,
                            children: [
                              CustomOfficerTextFieldData(
                                onSubmitted: () {
                                  context
                                      .read<AddNewOfficerCubit>()
                                      .militaryIDNumberFocusNode
                                      .requestFocus();
                                },
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "الاسم مطلوب";
                                  }
                                  return null;
                                },
                                controller: context
                                    .read<AddNewOfficerCubit>()
                                    .nameController,
                                focusNode: context
                                    .read<AddNewOfficerCubit>()
                                    .nameFocusNode,
                                label: "الاسم",
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
                                  context
                                      .read<AddNewOfficerCubit>()
                                      .selectedRank(rank ?? "");
                                },
                              ),
                              CustomOfficerTextFieldData(
                                onSubmitted: () {
                                  context
                                      .read<AddNewOfficerCubit>()
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
                                    .read<AddNewOfficerCubit>()
                                    .militaryIDNumberController,
                                focusNode: context
                                    .read<AddNewOfficerCubit>()
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
                                    .read<AddNewOfficerCubit>()
                                    .phoneController,
                                focusNode: context
                                    .read<AddNewOfficerCubit>()
                                    .phoneFocusNode,
                                isNumber: true,
                                label: "رقم التليفون",
                                textInputAction: TextInputAction.done,
                              ),
                              FilledButton(onPressed: (){
                                if(context.read<AddNewOfficerCubit>().formKey.currentState!.validate()){
                                  context.read<AddNewOfficerCubit>().addOfficer();
                                }
                              },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    minimumSize: Size(double.infinity, 40.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ), child: Text("إضافة الضابط",style: TextStyle(color: AppColors.white,fontWeight: FontWeight.bold,fontSize: 16.sp),))
                            ],
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
      ),
    );
  }
}
