import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/models/invoice_model.dart';
import '../../../../../../../core/utils/app_colors.dart';
import '../../../../config/routes/app_routes.dart';

class InvoiceListTile extends StatelessWidget {
 final InvoiceModel? invoice;
  const InvoiceListTile({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.invoiceDetails,arguments: invoice);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.sp),
            border: Border.all(
                width: 2.sp,
                color: AppColors.primary
            )
        ),
        child: Row(
          children: [
            Icon(Icons.list_alt,size: 25.sp,color: AppColors.primary,),
            SizedBox(width: 10,),
            Column(
              spacing: 10.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(invoice?.representativeName??"",style: TextStyle(
                  color: AppColors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),), Text(invoice?.date.toString().substring(0,10)??"",style: TextStyle(
                  color: AppColors.hintColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),),
              ],
            ),
            Spacer(),
            Text('${invoice?.total.ceil().toString()??0} جنية',style: TextStyle(
              color: AppColors.primary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            )),
            SizedBox(width: 10.w,),
            Icon(Icons.arrow_forward_ios_outlined,size: 20.sp,)
          ],
        ),
      ),
    );
  }
}
