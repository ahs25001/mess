import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mess_app/core/utils/app_colors.dart';
import 'package:mess_app/core/utils/app_enums.dart';
import 'package:mess_app/core/widgets/custom_app_bar.dart';
import 'package:mess_app/core/widgets/custom_empty_list_widget.dart';
import 'package:mess_app/features/closing_out_the_months/presentation/cubit/closing_out_the_months_cubit.dart';

import '../wigets/month_end_closing_item_list_tile.dart';

class ClosingOutTheMonthsScreen extends StatelessWidget {
  const ClosingOutTheMonthsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClosingOutTheMonthsCubit(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundCanvas,
        body: Column(
          children: [
            const CustomAppBar(title: 'تقفيلات الشهور'),
            BlocBuilder<ClosingOutTheMonthsCubit, ClosingOutTheMonthsState>(
              builder: (context, state) {
                if (state.status == ClosingOutTheMonthsStatus.loading) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                } else if ((state.closingOutTheMonths ?? []).isEmpty) {
                  return const Expanded(
                    child: CustomEmptyListWidget(
                      message: "لا توجد تقفيلات شهور",
                      subtitle: "لم يتم إنشاء تقفيل شهر حتى الآن",
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.closingOutTheMonths?.length ?? 0,
                    itemBuilder: (context, index) => FadeInUp(
                      key: ValueKey(
                        'closing_${index}_${state.closingOutTheMonths?[index].date}',
                      ),
                      duration: const Duration(milliseconds: 350),
                      child: MonthEndClosingItemListTile(
                        monthEndClosingHistoryModel:
                            state.closingOutTheMonths?[index],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
