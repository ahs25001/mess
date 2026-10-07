import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/app_enums.dart';

class DashboardCard extends StatelessWidget {
  final String iconPath;
  final Color backgroundColor;
  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;
  final String heroTag;
  const DashboardCard({
    super.key,
    required this.iconPath,
    required this.onTap,
    required this.heroTag,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Hero(
        tag: heroTag,
        child: Material(
          child: Card(

            color: backgroundColor,
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10.h,
                children: [
                  SvgPicture.asset(iconPath,width: 70.w,height: 70.h,),
                  Text(title,style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: iconColor,
                    height: 1.3,
                  )),
                  Text(subtitle,textAlign: TextAlign.center,style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7C8BA1), // Muted Grey
                    height: 1.4,),),
                  CircleAvatar(
                    radius: 16.sp,
                    backgroundColor: iconColor.withOpacity(0.2),
                    child: Icon(Icons.arrow_back_rounded,color: iconColor,size: 16.sp,),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
