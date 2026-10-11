import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mess_app/core/utils/app_colors.dart';
import 'package:mess_app/core/utils/app_enums.dart';
import 'package:mess_app/core/widgets/custom_app_bar.dart';
import 'package:mess_app/features/dispensing_items/presentation/cubit/dispensing_item_cubit.dart';
import '../widgets/dispensing_items_tab.dart';

class DispensingItemsScreen extends StatefulWidget {
  const DispensingItemsScreen({super.key});

  @override
  State<DispensingItemsScreen> createState() => _DispensingItemsScreenState();
}

class _DispensingItemsScreenState extends State<DispensingItemsScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: HeroTags.disburse.value,
        child: Material(
          color: AppColors.backgroundCanvas,
          child: BlocProvider(
            create: (context) => DispensingItemCubit(),
            child: Column(
              children: [
                CustomAppBar(title: "صرف أصناف"),
                TabBar(
                  indicatorColor: Colors.transparent,
                  dividerColor: Colors.transparent,
                  unselectedLabelStyle: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  labelStyle: TextStyle(
                    color: AppColors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  tabs: [
                    Tab(text: "صرف اصناف"),
                    Tab(text: 'وجبة مجمعة'),
                  ],
                  controller: tabController,
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      BlocConsumer<DispensingItemCubit, DispensingItemState>(
                        listener: (context, state) {
                          print(state.dispensingItemStatus);
                          if (state.dispensingItemStatus ==
                                  DispensingItemStatus.getOfficersError ||
                              state.dispensingItemStatus ==
                                  DispensingItemStatus.getAvailableFoodsError) {
                            if (!(state.dispensingItemStatus ==
                                DispensingItemStatus.getAvailableFoodsError)) {
                              Navigator.pop(context); // Dismiss loading dialog
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: AppColors.red,
                                content: Text(
                                  state.massage ?? "",
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            );
                          } else if (state.dispensingItemStatus ==
                              DispensingItemStatus.getOfficersSuccess) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppColors.invoiceAccent,
                                content: Text(
                                  "تم تحميل الضباط بنجاح",
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            );
                          } else if (state.dispensingItemStatus ==
                              DispensingItemStatus.getAvailableFoodsSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppColors.invoiceAccent,
                                content: Text(
                                  "تم تحميل الأصناف بنجاح",
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            );
                          } else if (state.dispensingItemStatus ==
                                  DispensingItemStatus.getOfficersLoading) {
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
                          return DispensingItemsTab(
                            onAddItem: () {
                              context.read<DispensingItemCubit>().addNewItem();
                            },
                            addItemValidator: (value) {
                              //todo add item validator
                            },
                            quantityController: context
                                .read<DispensingItemCubit>()
                                .quantityController,
                            items: state.items ?? [],
                            onDelete: (index) {
                              context.read<DispensingItemCubit>().deleteItem(
                                index,
                              );
                            },
                            dispensingItemsTabType:
                                state.dispensingItemsTabType ??
                                DispensingItemsTabType.init,
                            onCanteenChecked: () {
                              context
                                  .read<DispensingItemCubit>()
                                  .changeDispensingItemsTabType(
                                    DispensingItemsTabType.isCanteen,
                                  );
                            },
                            onHarmonyChecked: () {
                              context
                                  .read<DispensingItemCubit>()
                                  .changeDispensingItemsTabType(
                                    DispensingItemsTabType.isHarmony,
                                  );
                            },
                            onHospitalityChecked: () {
                              context
                                  .read<DispensingItemCubit>()
                                  .changeDispensingItemsTabType(
                                    DispensingItemsTabType.isHospitality,
                                  );
                            },
                            onOfficerChecked: () {
                              context
                                  .read<DispensingItemCubit>()
                                  .changeDispensingItemsTabType(
                                    DispensingItemsTabType.isOfficer,
                                  );
                            },
                            officers: state.officers ?? [],
                          );
                        },
                      ),
                      Container(color: Colors.green),
                    ],
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
