import 'package:dartz/dartz.dart';
import 'package:mess_app/core/errors/firebase_errors.dart';
import 'package:mess_app/core/errors/shared_preferences_errors.dart';
import 'package:mess_app/core/models/officer_model.dart';
import 'package:mess_app/features/financials/data/data_source/financials_ds.dart';
import 'package:mess_app/features/financials/domain/repositories/financials_repo.dart';

import '../../../../core/models/food_model.dart';
import '../../../../core/models/invoice_model.dart';
import '../../../../core/models/month_end_closing_history_model.dart';
import '../../../dispensing_items/data/models/dispensing_items_model.dart';

class FinancialsRepoImpl implements FinancialsRepo {
  final FinancialsDs _financialsDs;
  const FinancialsRepoImpl(this._financialsDs);
  @override
  Future<Either<FirebaseErrors, List<OfficerModel>?>> getOfficers() =>
      _financialsDs.getOfficers();

  @override
  Future<Either<FirebaseErrors, void>> addMoney({
    required String amount,
    required OfficerModel? officer,
  }) => _financialsDs.addMoney(amount: amount, officer: officer);
  @override
  Future<Either<FirebaseErrors, void>> spendMoney({
    required String amount,
    required OfficerModel? officer,
  }) => _financialsDs.spendMoney(amount: amount, officer: officer);

  @override
  Either<SharedPreferencesErrors, num?> getCapital() =>
      _financialsDs.getCapital();
  @override
  Future<Either<FirebaseErrors, List<InvoiceModel>>> getInvoices() =>
      _financialsDs.getInvoices();
  @override
  Future<Either<FirebaseErrors, List<DispensingItemsModel>>> getPerishes() =>
      _financialsDs.getPerishes();
  @override
  Future<Either<FirebaseErrors, List<DispensingItemsModel>>> getHospitality() =>
      _financialsDs.getHospitality();
  @override
  Future<Either<FirebaseErrors, List<DispensingItemsModel>>> getCanteen() =>
      _financialsDs.getCanteen();

  @override
  Either<SharedPreferencesErrors, num> getCanteenTotal() =>
      _financialsDs.getCanteenTotal();

  @override
  Either<SharedPreferencesErrors, num> getHospitalityTotal() =>
      _financialsDs.getHospitalityTotal();

  @override
  Future<Either<SharedPreferencesErrors, void>> setCanteenTotal(num value) =>
      _financialsDs.setCanteenTotal(value);

  @override
  Future<Either<SharedPreferencesErrors, void>> setHospitalityTotal(
    num value,
  ) => _financialsDs.setHospitalityTotal(value);
  @override
  Future<Either<FirebaseErrors, List<FoodModel>>> getAvailableFood() =>
      _financialsDs.getAvailableFood();
  @override
  Future<Either<FirebaseErrors, void>> addPostedInvoice(InvoiceModel postedInvoice) =>
      _financialsDs.addPostedInvoice(postedInvoice);
  @override
  Future<Either<FirebaseErrors, void>> deleteAllInvoices() =>
      _financialsDs.deleteAllInvoices();
  @override
  Future<Either<FirebaseErrors, void>> saveMonthEndClosing(
    MonthEndClosingHistoryModel monthEndClosingHistoryModel,
  ) => _financialsDs.saveMonthEndClosing(monthEndClosingHistoryModel);
  @override
  Future<Either<FirebaseErrors, void>> deletePerishes({required String docId}) =>
      _financialsDs.deletePerishes(docId: docId);
}
