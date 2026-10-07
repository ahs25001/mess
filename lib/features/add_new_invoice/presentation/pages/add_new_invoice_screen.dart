import 'package:animate_do/animate_do.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mess_app/core/models/food_model.dart';
import 'package:mess_app/core/utils/app_colors.dart';
import 'package:mess_app/core/utils/app_enums.dart';
import 'package:mess_app/features/add_new_invoice/presentation/cubit/add_new_invoice_cubit.dart';
import 'package:mess_app/core/widgets/custom_app_bar.dart';
import 'package:mess_app/features/add_new_invoice/presentation/widget/add_new_food_bottom_sheet.dart';

class AddNewInvoiceScreen extends StatelessWidget {
  const AddNewInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: HeroTags.addNewInvoice.value,
        child: BlocProvider(
          create: (context) => AddNewInvoiceCubit(),
          child: Material(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(title: 'فاتورة جديدة'),
                SizedBox(height: 10.h),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      spacing: 10.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "اسم المندوب",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        BlocBuilder<AddNewInvoiceCubit, AddNewInvoiceState>(
                          buildWhen: (previous, current) => false,
                          builder: (context, state) {
                            return TextFormField(
                              controller: context
                                  .read<AddNewInvoiceCubit>()
                                  .representativeNameController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person, size: 30.sp),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 5.h,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                    width: 1.w,
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.black,
                                    width: 1.w,
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.black,
                                    width: 1.w,
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                            );
                          },
                        ),
                        Builder(
                          builder: (parentContext) {
                            return ElevatedButton(
                              onPressed: () {
                                final cubit = parentContext
                                    .read<AddNewInvoiceCubit>();
                                showModalBottomSheet(
                                  showDragHandle: true,
                                  enableDrag: true,
                                  isScrollControlled: true,
                                  sheetAnimationStyle: AnimationStyle(
                                    curve: Curves.ease,
                                  ),
                                  context: parentContext,
                                  backgroundColor: AppColors.cardBackground,
                                  builder: (sheetContext) => BlocProvider.value(
                                    value: cubit,
                                    child: BlocBuilder<AddNewInvoiceCubit, AddNewInvoiceState>(
                                      builder: (context, state) {
                                        return AddNewFoodBottomSheet(
                                          onSave: () => cubit.saveNewFood(),
                                          nameController:
                                              cubit.newFoodNameController,
                                          isFixedMiscellaneousExpenses:
                                              state
                                                  .newFoodIsFixedMiscellaneousExpenses ??
                                              false,
                                          isVariableMiscellaneousExpenses:
                                              state
                                                  .newFoodIsVariableMiscellaneousExpenses ??
                                              false,
                                          onFixedMiscellaneousExpensesChange:
                                              (value) {
                                                cubit
                                                    .changeFixedMiscellaneousExpenses(
                                                      value,
                                                    );
                                              },
                                          onVariableMiscellaneousExpensesChange:
                                              (value) {
                                                cubit
                                                    .changeVariableMiscellaneousExpenses(
                                                      value,
                                                    );
                                              },
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.invoiceCardBg,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.r),
                                  side: BorderSide(
                                    color: AppColors.invoiceAccent,
                                    width: 2.w,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_circle_outline_outlined,
                                    size: 24.sp,
                                    color: AppColors.invoiceAccent,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    "اضافة صنف جديد كلياً",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.invoiceAccent,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        BlocConsumer<AddNewInvoiceCubit, AddNewInvoiceState>(
                          listener: (context, state) {
                            //todo listen to status
                            if (state.status ==
                                    AddNewInvoiceStatus.addInvoiceLoading ||
                                state.status ==
                                    AddNewInvoiceStatus.addFoodLoading) {
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
                            } else if (state.status ==
                                AddNewInvoiceStatus.getFoodFailure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.red,
                                  content: Text(
                                    state.errorMessage ?? "",
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              );
                            } else if (state.status ==
                                AddNewInvoiceStatus.addInvoiceSuccess) {
                              Navigator.pop(context); // Dismiss loading dialog
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.invoiceAccent,
                                  content: Text(
                                    "تم اضافة الفاتورة",
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              );
                            } else if (state.status ==
                                AddNewInvoiceStatus.addFoodSuccess) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.invoiceAccent,
                                  content: Text(
                                    "تم اضافة الصنف",
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              );
                            } else if (state.status ==
                                    AddNewInvoiceStatus.addInvoiceFailure ||
                                state.status ==
                                    AddNewInvoiceStatus.addFoodFailure) {
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pop(); // Dismiss loading dialog
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.red,
                                  content: Text(
                                    state.errorMessage ?? "",
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          builder: (context, stat) {
                            final items = stat.items ?? [];
                            return SizedBox(
                              height: 230.h,
                              child: ListView(
                                controller: context
                                    .read<AddNewInvoiceCubit>()
                                    .scrollController,
                                children: [
                                  // Table Header
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
                                            "السعر",
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
                                  // Table Animated Rows
                                  ...items.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final e = entry.value;
                                    return FadeInUp(
                                      key: ValueKey(
                                        'row_${index}_${e.id}_${e.food}',
                                      ),
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: Container(
                                        height: 35.h,
                                        decoration: BoxDecoration(
                                          color: (index % 2 != 0)
                                              ? AppColors.borderColor
                                              : AppColors.cardBackground,
                                          borderRadius:
                                              (index == items.length - 1)
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
                                              flex: 2,
                                              child: Center(
                                                child: Text(
                                                  e.food?.name ?? "",
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
                                                e.quantity.toString(),
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                e.price.toString(),
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: InkWell(
                                                onTap: () {
                                                  context
                                                      .read<
                                                        AddNewInvoiceCubit
                                                      >()
                                                      .deleteItem(index);
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
                            );
                          },
                        ),
                        BlocBuilder<AddNewInvoiceCubit, AddNewInvoiceState>(
                          builder: (context, state) {
                            return Form(
                              key: context.read<AddNewInvoiceCubit>().formKey,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.h,
                                  horizontal: 10.w,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10.r),
                                    bottomRight: Radius.circular(10.r),
                                  ),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppColors.borderColor,
                                      width: 2.w,
                                    ),
                                    left: BorderSide(
                                      color: AppColors.borderColor,
                                      width: 2.w,
                                    ),
                                    right: BorderSide(
                                      color: AppColors.borderColor,
                                      width: 2.w,
                                    ),
                                  ),
                                  color: AppColors.softBlue,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            final formState = context
                                                .read<AddNewInvoiceCubit>()
                                                .formKey
                                                .currentState;
                                            if (formState != null &&
                                                formState.validate()) {
                                              context
                                                  .read<AddNewInvoiceCubit>()
                                                  .addNewItem();
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 5.w,
                                              vertical: 6.h,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7.r),
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
                                        BlocBuilder<
                                          AddNewInvoiceCubit,
                                          AddNewInvoiceState
                                        >(
                                          builder: (context, state) {
                                            return Expanded(
                                              child: CustomDropdown<FoodModel>(
                                                validator: (p0) {
                                                  if (p0 == null) {
                                                    return "إختر صنف";
                                                  }
                                                  return null;
                                                },
                                                hintText: "إختر الصنف",
                                                initialItem: state.selectedFood,
                                                headerBuilder:
                                                    (
                                                      context,
                                                      selectedItem,
                                                      enabled,
                                                    ) => Text(
                                                      selectedItem.name,
                                                      style: TextStyle(
                                                        color:
                                                            AppColors.primary,
                                                        fontSize: 14.sp,
                                                      ),
                                                    ),
                                                decoration:
                                                    CustomDropdownDecoration(
                                                      closedFillColor: AppColors
                                                          .cardBackground,
                                                      closedBorderRadius:
                                                          BorderRadius.circular(
                                                            10.r,
                                                          ),
                                                    ),
                                                listItemBuilder:
                                                    (
                                                      context,
                                                      item,
                                                      isSelected,
                                                      onItemSelect,
                                                    ) => Text(
                                                      item.name,
                                                      style: TextStyle(
                                                        color:
                                                            AppColors.primary,
                                                        fontSize: 14.sp,
                                                      ),
                                                    ),
                                                items:
                                                    state.availableItems ?? [],
                                                onChanged: (p0) {
                                                  context
                                                      .read<
                                                        AddNewInvoiceCubit
                                                      >()
                                                      .selectFood(p0);
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    BlocBuilder<
                                      AddNewInvoiceCubit,
                                      AddNewInvoiceState
                                    >(
                                      buildWhen: (previous, current) =>
                                          previous.selectedFood !=
                                          current.selectedFood,
                                      builder: (context, state) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller: context
                                                    .read<AddNewInvoiceCubit>()
                                                    .quantityController,

                                                validator:((state
                                                    .selectedFood
                                                    ?.isFixedMiscellaneousExpenses ??
                                                    false) ||
                                                    (state
                                                        .selectedFood
                                                        ?.isVariableMiscellaneousExpenses ??
                                                        false))?null: (value) {
                                                  if (value == null ||
                                                      value.trim().isEmpty) {
                                                    return "الكمية مطلوبة";
                                                  }
                                                  return null;
                                                },
                                                enabled:
                                                    !((state
                                                                .selectedFood
                                                                ?.isFixedMiscellaneousExpenses ??
                                                            false) ||
                                                        (state
                                                                .selectedFood
                                                                ?.isVariableMiscellaneousExpenses ??
                                                            false)),
                                                keyboardType:
                                                    TextInputType.number,
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: 'الكمية',
                                                  hintStyle: TextStyle(
                                                    fontSize: 12.sp,
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                        vertical: 5.h,
                                                        horizontal: 10.w,
                                                      ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10.r,
                                                        ),
                                                    borderSide: BorderSide(
                                                      color:
                                                          AppColors.borderColor,
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10.r,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: AppColors
                                                              .borderColor,
                                                        ),
                                                      ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10.r,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color:
                                                              AppColors.primary,
                                                        ),
                                                      ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            Expanded(
                                              child: TextFormField(
                                                controller: context
                                                    .read<AddNewInvoiceCubit>()
                                                    .priceController,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.trim().isEmpty) {
                                                    return "السعر مطلوب";
                                                  }
                                                  return null;
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: 'السعر',
                                                  hintStyle: TextStyle(
                                                    fontSize: 12.sp,
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                        vertical: 5.h,
                                                        horizontal: 10.w,
                                                      ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10.r,
                                                        ),
                                                    borderSide: BorderSide(
                                                      color:
                                                          AppColors.borderColor,
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10.r,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: AppColors
                                                              .borderColor,
                                                        ),
                                                      ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10.r,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color:
                                                              AppColors.primary,
                                                        ),
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        BlocBuilder<AddNewInvoiceCubit, AddNewInvoiceState>(
                          builder: (context, state) {
                            return FilledButton(
                              onPressed: () {
                                final itemsList = state.items ?? [];
                                final repName = context
                                    .read<AddNewInvoiceCubit>()
                                    .representativeNameController
                                    .text
                                    .trim();

                                if (itemsList.isNotEmpty &&
                                    repName.isNotEmpty) {
                                  context
                                      .read<AddNewInvoiceCubit>()
                                      .addInvoice();
                                } else if (repName.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: AppColors.red,
                                      content: Text(
                                        "ادخل اسم المندوب",
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: AppColors.red,
                                      content: Text(
                                        "الفاتورة فارغه",
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                minimumSize: Size(double.infinity, 40.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: const Text("إضافة الفاتورة"),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
