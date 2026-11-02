import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mess_app/core/widgets/custom_app_bar.dart';
import 'package:mess_app/features/closing_out_the_months/presentation/cubit/closing_out_the_months_cubit.dart';

import '../wigets/month_end_closing_item_list_tile.dart';

class ClosingOutTheMonthsScreen extends StatelessWidget {
  const ClosingOutTheMonthsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClosingOutTheMonthsCubit(),
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBar(title: 'تقفيلات الشهور'),
            BlocBuilder<ClosingOutTheMonthsCubit, ClosingOutTheMonthsState>(
              builder: (context, state) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.closingOutTheMonths?.length ?? 0,
                    itemBuilder: (context, index) => MonthEndClosingItemListTile(monthEndClosingHistoryModel: state.closingOutTheMonths?[index],),
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
