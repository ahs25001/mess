import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mess_app/core/utils/app_enums.dart';

import '../../../../core/widgets/custom_app_bar.dart';
import '../widgets/financials_item.dart';

class FinancialsScreen extends StatelessWidget {
  const FinancialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: HeroTags.financials.value,
        child: Material(
          child: Column(
            children: [
              const CustomAppBar(title: 'إدارة الماليات'),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 20.w),
                child: Column(
                  spacing: 10.h,
                  children: [
                    FinancialsItem(title: 'تحصيل مبلغ',animatedIconPath: 'assets/json/add_money_animated_icon.json',),
                    FinancialsItem(title: 'المبلغ المتبقي',animatedIconPath: 'assets/json/the_remaining_amount_animated_icon.json',),
                    FinancialsItem(title: 'تقفيل الشهر',animatedIconPath: 'assets/json/closing_accounts_animated_icon.json',),
                    FinancialsItem(title: 'رصيد الضباط',animatedIconPath: 'assets/json/oficerres_amount_animated_icon.json',),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
