import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class CurvedHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  const CurvedHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HeaderClipper(),
      child: Container(
        decoration: BoxDecoration(color: AppColors.primary),
        child: Column(
          children: [
            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.softBlue,
                    backgroundImage: AssetImage(
                      "assets/icons/officer_icon.png",
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8.h,
                    children: [
                      Text(
                        title,
                        style:  TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        subtitle,
                        style:  TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        description,
                        style:  TextStyle(
                          color: Colors.white70,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40.h);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 40.h,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
