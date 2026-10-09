import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mess_app/core/utils/app_colors.dart';

class UpdateCapitalDialog extends StatelessWidget {
 final TextEditingController controller;
  final VoidCallback onSave;
  const UpdateCapitalDialog({super.key,required this.controller,required this.onSave});

  @override
  Widget build(BuildContext context) {
    return  PopScope(
      canPop: false,
      child: AlertDialog(
        actions: [
          FilledButton(onPressed: (){
            Navigator.pop(context);
          }, style: FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            minimumSize: Size((MediaQuery.sizeOf(context).width/2)-70.w, 40.h),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: AppColors.red),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ), child: Text("إلغاء",style: TextStyle(
            color: AppColors.red,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold
          ),)),
          FilledButton(onPressed: (){
            onSave();
          }, style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: Size((MediaQuery.sizeOf(context).width/2)-70.w, 40.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ), child: Text("حفظ",style: TextStyle(
            color: AppColors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold
          ))),
        ],
        title: Center(
          child: Text('تعديل التأسيس',style: TextStyle(
            color: AppColors.primary,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold
          )),
        ),
        content:TextFormField(
          keyboardType: TextInputType.number,
          controller: controller,
          decoration: InputDecoration(
            hintText: 'التأسيس',
            hintStyle: TextStyle(
              color: AppColors.hintColor,
              fontWeight: FontWeight.w700,
              fontSize: 14.sp
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 10.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.borderColor)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.primary)
            ),
            enabledBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: AppColors.borderColor,width: 2.sp)
            ),
          ),
          style: TextStyle(color: AppColors.primary,fontSize: 14.sp,fontWeight: FontWeight.w500),
        ),

      ).zoomIn(duration: Duration(milliseconds: 300),curve: Curves.easeInOutBack),
    );
  }
}
