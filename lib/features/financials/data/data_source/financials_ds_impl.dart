import 'package:dartz/dartz.dart';
import 'package:mess_app/core/errors/firebase_errors.dart';
import 'package:mess_app/core/firebase/firebase_firestore_manager.dart';
import 'package:mess_app/core/models/officer_model.dart';
import 'package:mess_app/core/shared_preferences/shared_preferences_manager.dart';
import 'package:mess_app/core/utils/app_enums.dart';
import 'package:mess_app/features/financials/data/data_source/financials_ds.dart';

import '../../../../core/errors/shared_preferences_errors.dart';
import '../../../../core/models/food_model.dart';
import '../../../../core/models/invoice_model.dart';
import '../../../../core/models/month_end_closing_history_model.dart';
import '../../../dispensing_items/data/models/dispensing_items_model.dart';

class FinancialsDsImpl implements FinancialsDs {
  final FirebaseFirestoreManager _firebaseFirestoreManager;
  final SharedPreferencesManager _sharedPreferencesManager;
  const FinancialsDsImpl(
    this._firebaseFirestoreManager,
    this._sharedPreferencesManager,
  );

  @override
  Future<Either<FirebaseErrors, List<OfficerModel>?>> getOfficers() async {
    try {
      var result = await _firebaseFirestoreManager.getOfficers();
      List<OfficerModel> officers = result.docs
          .map((e) => OfficerModel.fromJson(e.data()))
          .toList();
      return Right(officers);
    } catch (e) {
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseErrors, void>> addMoney({
    required String amount,
    required OfficerModel? officer,
  }) async {
    try {
      officer?.amount += num.tryParse(amount) ?? 0;
      await _firebaseFirestoreManager.updateOfficer(officer: officer);
      return Right(null);
    } catch (e) {
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseErrors, void>> spendMoney({
    required String amount,
    required OfficerModel? officer,
  }) async {
    try {
      officer?.amount -= num.tryParse(amount) ?? 0;
      await _firebaseFirestoreManager.updateOfficer(officer: officer);
      return Right(null);
    } catch (e) {
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Either<SharedPreferencesErrors, num?> getCapital() {
    try {
      String capital = _sharedPreferencesManager.getString(
        SharedPreferencesKeys.capital.value,
      );
      return Right(num.tryParse(capital));
    } catch (e) {
      return Left(SharedPreferencesLocalErrors(e.toString()));
    }
  }

  @override
  Future<Either<FirebaseErrors, List<InvoiceModel>>> getInvoices() async {
    try {
      var docs = await _firebaseFirestoreManager.getInvoices();
      List<InvoiceModel> invoices = docs.docs.map((e) => e.data()).toList();
      return Right(invoices);
    } catch (e) {
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseErrors, List<DispensingItemsModel>>>
  getPerishes() async {
    try {
      var perishes = await _firebaseFirestoreManager.getPerishes();
      return Right(perishes);
    } catch (e) {
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseErrors, List<DispensingItemsModel>>>
  getHospitality() async {
    try {
      var data = await _firebaseFirestoreManager.getHospitality();
      return Right(data.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseErrors, List<DispensingItemsModel>>>
  getCanteen() async {
    try {
      var data = await _firebaseFirestoreManager.getCanteen();
      return Right(data.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Either<SharedPreferencesErrors, num> getCanteenTotal() {
    try {
      var data = _sharedPreferencesManager.getString(
        SharedPreferencesKeys.canteenBalance.value,
      );
      return Right(num.tryParse(data) ?? 0);
    } catch (e) {
      return Left(SharedPreferencesLocalErrors(e.toString()));
    }
  }

  @override
  Either<SharedPreferencesErrors, num> getHospitalityTotal() {
    try {
      var data = _sharedPreferencesManager.getString(
        SharedPreferencesKeys.hospitalityBalance.value,
      );
      return Right(num.tryParse(data) ?? 0);
    } catch (e) {
      return Left(SharedPreferencesLocalErrors(e.toString()));
    }
  }

  @override
  Future<Either<SharedPreferencesErrors, void>> setCanteenTotal(
    num value,
  ) async {
    try {
      await _sharedPreferencesManager.saveString(
        SharedPreferencesKeys.canteenBalance.value,
        value.toString(),
      );
      return Right(null);
    } catch (e) {
      return Left(SharedPreferencesLocalErrors(e.toString()));
    }
  }

  @override
  Future<Either<SharedPreferencesErrors, void>> setHospitalityTotal(
    num value,
  ) async {
    try {
      await _sharedPreferencesManager.saveString(
        SharedPreferencesKeys.hospitalityBalance.value,
        value.toString(),
      );
      return Right(null);
    } catch (e) {
      return Left(SharedPreferencesLocalErrors(e.toString()));
    }
  }

  @override
  Future<Either<FirebaseErrors, List<FoodModel>>> getAvailableFood() async {
    try {
      var date = await _firebaseFirestoreManager.getFood();
      var food = date.docs.map((e) => FoodModel.fromJson(e.data())).toList();
      return Right(food);
    } catch (e) {
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseErrors, void>> addPostedInvoice(
    InvoiceModel postedInvoice,
  ) async {
    try {
      _firebaseFirestoreManager.addInvoice(invoice: postedInvoice);
      return Right(null);
    } catch (e) {
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseErrors, void>> deleteAllInvoices() async {
    try {
      await _firebaseFirestoreManager.deleteAllInvoices();
      return Right(null);
    } catch (e) {
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseErrors, void>> saveMonthEndClosing(
    MonthEndClosingHistoryModel monthEndClosingHistoryModel,
  ) async {
    try {
      await _firebaseFirestoreManager.addMonthEndClosingHistory(
        monthEndClosingHistoryModel: monthEndClosingHistoryModel,
      );
      return Right(null);
    } catch (e) {
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }
  @override
  Future<Either<FirebaseErrors, void>> deletePerishes({required String docId})async {
   try{
     await _firebaseFirestoreManager.deletePerishes(docId: docId);
     return Right(null);
   }catch(e){
     return Left(FirebaseRemoteError(error: e.toString()));
   }
  }
}
