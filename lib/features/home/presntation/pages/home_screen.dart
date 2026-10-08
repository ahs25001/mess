import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mess_app/core/utils/app_constants.dart';
import 'package:mess_app/features/home/presntation/cubit/home_cubit.dart';

import '../../../../core/utils/app_colors.dart';
import '../widgets/curved_header.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => HomeCubit(),
  child: BlocBuilder<HomeCubit, HomeState>(
  builder: (context, state) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: AppColors.softBlue.withOpacity(0.5),
        currentIndex:state.currentIndex??0 ,
        onTap: (value) {
          context.read<HomeCubit>().changePage(value);
        },
        unselectedFontSize: 14.sp,
        selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.black.withOpacity(0.5),
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.sp
          ),
          items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset("assets/icons/home-svgrepo-com.svg",color: AppColors.black,width: 30.w,height: 30.h,),
          activeIcon: SvgPicture.asset('assets/icons/home_svgrepo-com_filled.svg',color: AppColors.primary,width: 30.w,height: 30.h),
          label: 'الرئيسية',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset("assets/icons/archive-svgrepo-com.svg",color: AppColors.black,width: 30.w,height: 30.h),
          activeIcon: SvgPicture.asset('assets/icons/archive-svgrepo-com_filled.svg',color: AppColors.primary,width: 30.w,height: 30.h),
          label: 'السجلات',
        ),BottomNavigationBarItem(
          icon: SvgPicture.asset("assets/icons/settings-minimalistic-svgrepo-com.svg",color: AppColors.black,width: 30.w,height: 30.h),
          activeIcon: SvgPicture.asset('assets/icons/settings-minimalistic-svgrepo-com_filled.svg',color: AppColors.primary,width: 30.w,height: 30.h),
          label: 'الاعدادات',
        ),
      ]),
      body: Column(
        children: [
          const CurvedHeader(
            title: 'مرحباً بك',
            subtitle: 'في نظام إدارة الميس',
            description: 'اختر ما تريد القيام به من الخيارات التالية',
          ),
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: context.read<HomeCubit>().pageController,
              children: AppConstants.tabs,),
          ),
        ],
      )
    );
  },
),
);
  }
}
