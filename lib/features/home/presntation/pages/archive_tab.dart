import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mess_app/core/widgets/custom_list_tile.dart';
import '../../../../config/routes/app_routes.dart';
class ArchiveTab extends StatelessWidget {
  const ArchiveTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      children: [
        CustomListTile(
          title: 'الفواتير',
          animatedIconPath: 'assets/json/Billing.json',
          onTab: () {
            Navigator.pushNamed(context, AppRoutes.invoices);
          },
        ),
        SizedBox(height: 10.h),
        CustomListTile(
          title: 'تقفيلات الشهور',
          animatedIconPath: 'assets/json/Files.json',
          onTab: () {

          },
        ),
        SizedBox(height: 10.h),
        CustomListTile(
          title: 'جرد الاصناف',
          animatedIconPath: 'assets/json/Shopping Bag Lottie Animation.json',
          onTab: () {
            Navigator.pushNamed(context, AppRoutes.inventoryOfItems );
          },
        ),
        SizedBox(height: 10.h),
        CustomListTile(
          title: 'بيان اصناف للضباط',
          animatedIconPath: 'assets/json/Profile Creation Loader.json',
          onTab: () {

          },
        ),
      ],
    );
  }
}
