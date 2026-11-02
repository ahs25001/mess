import 'package:flutter/material.dart';
import 'package:mess_app/core/widgets/custom_app_bar.dart';

class ClosingOutTheMonthsScreen extends StatelessWidget {
  const ClosingOutTheMonthsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: 'تقفيلات الشهور')
        ],
      ),
    );
  }
}
