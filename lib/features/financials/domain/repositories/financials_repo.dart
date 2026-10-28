import 'package:dartz/dartz.dart';
import 'package:mess_app/core/errors/shared_preferences_errors.dart';
import 'package:mess_app/core/models/invoice_model.dart';
import '../../../../core/errors/firebase_errors.dart';
import '../../../../core/models/food_model.dart';
import '../../../../core/models/month_end_closing_history_model.dart';
import '../../../../core/models/officer_model.dart';
import '../../../dispensing_items/data/models/dispensing_items_model.dart';

abstract class FinancialsRepo {
  Future<Either<FirebaseErrors, List<OfficerModel>?>> getOfficers();
  Future<Either<FirebaseErrors, void>> addMoney({
    required String amount,
    required OfficerModel? officer,
  });
  Future<Either<FirebaseErrors, void>>  spendMoney({
    required String amount,
    required OfficerModel? officer,
  });
  Either<SharedPreferencesErrors, num?> getCapital();
  Future<Either<FirebaseErrors, List<InvoiceModel>>> getInvoices();
  Future<Either<FirebaseErrors, List<DispensingItemsModel>>> getPerishes();
  Future<Either<FirebaseErrors, void>> deletePerishes({required String docId});
  Future<Either<FirebaseErrors, List<DispensingItemsModel>>> getHospitality();
  Future<Either<FirebaseErrors, List<DispensingItemsModel>>> getCanteen();
  Either<SharedPreferencesErrors, num> getHospitalityTotal();
  Either<SharedPreferencesErrors, num> getCanteenTotal();
  Future<Either<SharedPreferencesErrors, void>> setCanteenTotal(num value);
  Future<Either<SharedPreferencesErrors, void>> setHospitalityTotal(num value);
  Future<Either<FirebaseErrors, List<FoodModel>>> getAvailableFood();
  Future<Either<FirebaseErrors, void>> addPostedInvoice(
    InvoiceModel postedInvoice,
  );
  Future<Either<FirebaseErrors, void>> deleteAllInvoices();
  Future<Either<FirebaseErrors, void>> saveMonthEndClosing(
    MonthEndClosingHistoryModel monthEndClosingHistoryModel,
  );
}
