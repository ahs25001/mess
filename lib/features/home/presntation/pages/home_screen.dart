import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_enums.dart';
import '../widgets/curved_header.dart';
import '../widgets/dashboard_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CurvedHeader(
            title: 'مرحباً بك',
            subtitle: 'في نظام إدارة الميس',
            description: 'اختر ما تريد القيام به من الخيارات التالية',
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: GridView(
              padding: EdgeInsets.symmetric(horizontal:  20.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 59/85,
                crossAxisCount: 2,
              ),
              children: [
                DashboardCard(
                  heroTag: HeroTags.addNewInvoice.value,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.addNewInvoice);
                  },
                  iconPath: 'assets/icons/add_invoice_icon.svg',
                  backgroundColor: AppColors.invoiceCardBg,
                  title: 'إضافة فاتورة',
                  subtitle: 'إدخال وتسجيل الفواتير بكل سهولة',
                  iconColor: AppColors.invoiceAccent,
                ).slideInRight(), DashboardCard(
                  heroTag: HeroTags.addNewOfficer.value,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.addNewOfficer);
                  },
                  iconPath: 'assets/icons/add_officers_icon.svg',
                  backgroundColor: AppColors.softBlue,
                  title: 'إضافة ضباط جدد',
                  subtitle: 'تسجيل وإضافة ضباط جدد في النظام',
                  iconColor: AppColors.primary,
                ).slideInLeft(), DashboardCard(
                  heroTag: HeroTags.financials.value,
                  onTap: () {
                    //todo go to financials
                  },
                  iconPath: 'assets/icons/financials_icon.svg',
                  backgroundColor: AppColors.financialsIconBg,
                  title: 'ماليات',
                  subtitle: 'متابعة و إدارة الأمور المالية',
                  iconColor: AppColors.financialsIconAccent,
                ).slideInRight(), DashboardCard(
                  heroTag: HeroTags.disburse.value,
                  onTap: () {
                    //todo go to disburse
                  },
                  iconPath: 'assets/icons/package_icon.svg',
                  backgroundColor: AppColors.disburseIconBg,
                  title: 'صرف أصناف',
                  subtitle: 'صرف الأصناف و المستهلكات المتاحة',
                  iconColor: AppColors.disburseAccent,
                ).slideInLeft(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
