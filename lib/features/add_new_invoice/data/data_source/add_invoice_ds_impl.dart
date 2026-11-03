import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import 'package:mess_app/core/errors/firebase_errors.dart';
import 'package:mess_app/core/errors/shared_preferences_errors.dart';
import 'package:mess_app/core/models/food_model.dart';

import 'package:mess_app/core/models/invoice_model.dart';
import 'package:mess_app/core/shared_preferences/shared_preferences_manager.dart';
import 'package:mess_app/core/utils/app_enums.dart';

import '../../../../core/firebase/firebase_firestore_manager.dart';
import 'add_invoice_ds.dart';

class AddInvoiceDSImpl implements AddInvoiceDS {
  final FirebaseFirestoreManager _firebaseFirestoreManager;
  final SharedPreferencesManager _sharedPreferencesManager;
  const AddInvoiceDSImpl(
    this._firebaseFirestoreManager,
    this._sharedPreferencesManager,
  );

  @override
  Future<Either<FirebaseErrors, void>> addNewInvoice({
    required InvoiceModel invoice,
  }) async {
    try {
      await _firebaseFirestoreManager.addInvoice(invoice: invoice);
      return const Right(null);
    } catch (e) {
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseErrors, void>> addNewFood({
    required FoodModel food,
  }) async {
    try {
      await _firebaseFirestoreManager.addFood(food: food);
      return const Right(null);
    } catch (e) {
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Either<Stream<QuerySnapshot<Map<String, dynamic>>>, FirebaseErrors>
  getFood() {
    try {
      return Left(_firebaseFirestoreManager.getAllFood());
    } catch (e) {
      return Right(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseErrors, void>> upDateFood({
    required FoodModel food,
  }) async {
    try {
      await _firebaseFirestoreManager.updateFood(food);
      return const Right(null);
    } catch (e) {
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Future<Either<SharedPreferencesErrors, void>> setInvoiceTotal(
    num value,
  ) async {
    try {
     String valueAsString = _sharedPreferencesManager.getString(SharedPreferencesKeys.invoicesBalance.value);
     num valueAsNumber = num.tryParse(valueAsString)??0;
     num total = value+valueAsNumber;
      await _sharedPreferencesManager.saveString(
        SharedPreferencesKeys.invoicesBalance.value,
        total.toString(),
      );
      return Right(null);
    } catch (e) {
      return Left(SharedPreferencesLocalErrors(e.toString()));
    }
  }
}
