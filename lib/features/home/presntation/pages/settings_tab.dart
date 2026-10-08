import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/custom_list_tile.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        spacing: 10.h,
        children: [
          CustomListTile(
            title: 'تعديل بيانات ضابط',
            animatedIconPath: 'assets/json/profile setup.json',
            onTab: () {},
          ),CustomListTile(
            title: 'تعديل التأسيس',
            animatedIconPath: 'assets/json/money_animated_icon.json',
            onTab: () {},
          ),CustomListTile(
            title: 'تعديل بيانات الوحدة',
            animatedIconPath: 'assets/json/update-data.json',
            onTab: () {},
          ),
        ],
      ),
    );
  }
}
