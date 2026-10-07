import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import 'package:mess_app/core/errors/firebase_errors.dart';
import 'package:mess_app/core/models/food_model.dart';

import 'package:mess_app/core/models/ivoice_model.dart';

import '../../../../core/firebase/firebase_firestore_manager.dart';
import 'add_invoice_ds.dart';

class AddInvoiceDSImpl implements AddInvoiceDS {
  FirebaseFirestoreManager firebaseFirestoreManager;
  AddInvoiceDSImpl({required this.firebaseFirestoreManager});
  @override
  Future<Either<FirebaseErrors, void>> addNewInvoice({
    required InvoiceModel invoice,
  }) async {
    try {
      await firebaseFirestoreManager.addInvoice(invoice: invoice);
      return Right(null);
    } catch (e) {
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseErrors, void>> addNewFood({
    required FoodModel food,
  }) async {
    try {
      await firebaseFirestoreManager.addFood(food: food);
      return Right(null);
    } catch (e) {
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Either<Stream<QuerySnapshot<Map<String, dynamic>>>, FirebaseErrors>
  getFood() {
    try {
      return Left(firebaseFirestoreManager.getFood());
    } catch (e) {
      return Right(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseErrors, void>> upDateFood({
    required FoodModel food,
  }) async {
    try {
      await firebaseFirestoreManager.updateData(
        collection: "Food",
        data: food.toJson(),
      );
      return Right(null);
    } catch (e) {
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }
}
