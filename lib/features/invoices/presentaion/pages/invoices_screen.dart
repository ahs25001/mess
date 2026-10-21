import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mess_app/core/utils/app_colors.dart';
import 'package:mess_app/core/widgets/custom_app_bar.dart';
import 'package:mess_app/features/invoices/presentaion/cubit/invoices_cubit.dart';
import 'package:mess_app/features/invoices/presentaion/cubit/invoices_cubit.dart';

import '../widget/invoice_list_tile.dart';

class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InvoicesCubit(),
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBar(title: 'الفواتير'),
            const SizedBox(height: 10),
            BlocBuilder<InvoicesCubit, InvoicesState>(
              builder: (context, state) {
                if (state.status == InvoicesStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                } else if (state.status == InvoicesStatus.failure) {
                  return Center(
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        state.message ?? "",
                        style: TextStyle(
                          color: AppColors.red,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) => InvoiceListTile(invoice: state.invoices?[index]),
                      itemCount: state.invoices?.length ?? 0,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
