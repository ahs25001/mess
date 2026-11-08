import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mess_app/core/utils/app_colors.dart';
import 'package:mess_app/core/utils/app_enums.dart';
import 'package:mess_app/core/widgets/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: HeroTags.aboutUs.value,
      child: Material(
        color: AppColors.backgroundCanvas,
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(title: 'عن المطور'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20.h,
                  children: [
                    Center(
                      child: Text(
                        'أحمد حسن محمد',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'ضابط احتياط الدفعة 168 تخرج من كلية العلوم جامعة الأزهر قسم الرياضيات البحته وعلوم الحاسب التحق بالكتيبة 571 نيران بتش ومن هنا بدأت فكرة التطبيق.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 20.w,
                      children: [
                        InkWell(
                          onTap: () {
                            _launchInBrowserView(
                              Uri(
                                scheme: 'https',
                                host: 'www.facebook.com',
                                path: 'share/18wGkhR4rW/',
                              ),
                              context,
                            );
                          },
                          child: SvgPicture.asset(
                            'assets/icons/facebook.svg',
                            width: 40.w,
                            height: 40.h,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _launchInBrowserView(
                              Uri(
                                scheme: 'https',
                                host: 'github.com',
                                path: 'ahs25001',
                              ),
                              context,
                            );
                          },
                          child: SvgPicture.asset(
                            'assets/icons/github-light.svg',
                            width: 40.w,
                            height: 40.h,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _launchInBrowserView(
                              Uri(
                                scheme: 'https',
                                host: 'www.linkedin.com',
                                path: '/in/ahmed-hassen-432931254/?lipi=urn%3Ali%3Apage%3Ad_flagship3_profile_view_base_contact_details%3B0t7j1YGYQJGURW3oTWozGA%3D%3D',
                              ),
                              context,
                            );
                          },
                          child: SvgPicture.asset(
                            'assets/icons/linkedin.svg',
                            width: 40.w,
                            height: 40.h,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _launchInBrowserView(
                              Uri(
                                scheme: 'https',
                                host: 'wa.me',
                                path: '201203682237',
                              ),
                              context,
                            );
                          },
                          child: SvgPicture.asset(
                            'assets/icons/whatsapp.svg',
                            width: 40.w,
                            height: 40.h,
                          ),
                        ),
                      ],
                    ),
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

Future<void> _launchInBrowserView(Uri url, BuildContext context) async {
  if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'حدث خطأ ما',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
