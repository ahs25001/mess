import 'package:flutter/material.dart';
import 'package:mess_app/core/utils/app_colors.dart';

class AppThemes {
 static ThemeData light = ThemeData(
  textSelectionTheme: TextSelectionThemeData(
   cursorColor: AppColors.primary,
   selectionHandleColor:AppColors.primary ,
   selectionColor: AppColors.primary.withOpacity(0.2),
  ),
  inputDecorationTheme: InputDecorationTheme(
    prefixIconColor: AppColors.primary,

  ),
  fontFamily: "Almarai",
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.backgroundCanvas
    ),
    scaffoldBackgroundColor: AppColors.backgroundCanvas,
  );
}