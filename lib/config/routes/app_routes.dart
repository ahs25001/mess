import 'package:flutter/material.dart';

import '../../features/add_new_invoice/presentation/pages/add_new_invoice_screen.dart';
import '../../features/adding_officers/presentation/pages/add_new_officer_screen.dart';
import '../../features/financials/presntation/pages/financials_screen.dart';
import '../../features/home/presntation/pages/home_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String addNewInvoice = '/add_new_invoice';
  static const String addNewOfficer = '/add_new_officer';
  static const String financials = '/financials';
  static const String disburse = '/disburse';
}
class Routes {
  static Route onGenerateRoute(RouteSettings settings){
    switch (settings.name){
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
        case AppRoutes.addNewInvoice:
        return MaterialPageRoute(
          builder: (context) => const AddNewInvoiceScreen(),
        );
      case AppRoutes.addNewOfficer:
        return MaterialPageRoute(builder:  (context) => const AddNewOfficerScreen(),);
        case AppRoutes.financials:
        return MaterialPageRoute(builder:  (context) => const FinancialsScreen(),);
        default:
        return MaterialPageRoute(
          builder: (context) => const ErrorScreen(),
        );
    }
  }
}
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Text("Error");
  }
}
