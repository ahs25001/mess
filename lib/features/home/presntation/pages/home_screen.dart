import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mess_app/core/utils/app_constants.dart';
import 'package:mess_app/core/utils/app_enums.dart';
import 'package:mess_app/features/home/presntation/cubit/home_cubit.dart';

import '../../../../core/utils/app_colors.dart';
import '../widgets/curved_header.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => HomeCubit(),
  child: BlocConsumer<HomeCubit, HomeState>(
    listener: (context, state) {
      if(state.status==HomeStatus.setCapitalLoading){
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => PopScope(
            canPop: false,
            child: const AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        );
      }else if (state.status==HomeStatus.setCapitalSuccess){
        Navigator.pop(context); // Dismiss loading dialog
        Navigator.pop(context); // Dismiss dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.invoiceAccent,
            content: Text(
              "تم تعديل المبلغ بنجاح",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
        );
      }else if (state.status==HomeStatus.setCapitalFailure){
        Navigator.pop(context); // Dismiss loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.red,
            content: Text(
              state.errorMessage ?? "",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
        );
      }
    },
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
