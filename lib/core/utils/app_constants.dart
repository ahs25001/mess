
import 'package:flutter/material.dart';

import '../../features/home/presntation/pages/home_tab.dart';
import '../../features/home/presntation/pages/settings_tab.dart';
import 'app_colors.dart';

abstract class AppConstants {
  static List<String>rankList=[
    "مشير",
    "فريق أول",
    "فريق",
    "لواء",
    "عميد",
    "عقيد",
    "مقدم",
    "رائد",
    "نقيب",
    "ملازم أول",
    "ملازم",
  ];
  static List<Widget>tabs=[
    HomeTab(),
    Placeholder(
      color: AppColors.primary,
    ),SettingsTab(),
  ];
}