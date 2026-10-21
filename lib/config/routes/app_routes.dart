import 'package:flutter/material.dart';

import '../../core/models/food_model.dart';
import '../../core/models/ivoice_model.dart';
import '../../features/add_new_invoice/presentation/pages/add_new_invoice_screen.dart';
import '../../features/adding_officers/presentation/pages/add_new_officer_screen.dart';
import '../../features/dispensing_items/presentation/pages/dispensing_items_screen.dart';
import '../../features/financials/presntation/pages/financials_screen.dart';
import '../../features/home/presntation/pages/home_screen.dart';
import '../../features/home/presntation/pages/inventory_of_items_screen.dart';
import '../../features/invoices/presentaion/pages/invoice_details_screen.dart';
import '../../features/invoices/presentaion/pages/invoices_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String addNewInvoice = '/add_new_invoice';
  static const String addNewOfficer = '/add_new_officer';
  static const String inventoryOfItems = '/inventory_of_items';
  static const String financials = '/financials';
  static const String dispensingItems = '/dispensing_items';
  static const String invoices = '/invoices';
  static const String invoiceDetails = '/invoice_details';
}
class Routes {
  static Route onGenerateRoute(RouteSettings settings){
    switch (settings.name){
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
        case AppRoutes.dispensingItems:
        return MaterialPageRoute(
          builder: (context) => const DispensingItemsScreen(),
        );
        case AppRoutes.addNewInvoice:
        return MaterialPageRoute(
          builder: (context) => const AddNewInvoiceScreen(),
        );
      case AppRoutes.addNewOfficer:
        return MaterialPageRoute(builder:  (context) => const AddNewOfficerScreen(),);
        case AppRoutes.financials:
        return MaterialPageRoute(builder:  (context) => const FinancialsScreen(),);
        case AppRoutes.invoices:
        return MaterialPageRoute(builder:  (context) => const InvoicesScreen(),);
        case AppRoutes.invoiceDetails:
        return MaterialPageRoute(builder:  (context) =>  InvoiceDetailsScreen(invoice: settings.arguments as InvoiceModel,),);
        case AppRoutes.inventoryOfItems:
        return MaterialPageRoute(builder:  (context) => const InventoryOfItemsScreen(),);
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
