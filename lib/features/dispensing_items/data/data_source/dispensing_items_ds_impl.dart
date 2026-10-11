import 'package:dartz/dartz.dart';

import 'package:mess_app/core/errors/firebase_errors.dart';
import 'package:mess_app/core/firebase/firebase_firestore_manager.dart';
import 'package:mess_app/core/models/food_model.dart';

import 'package:mess_app/core/models/officer_model.dart';

import 'dispensing_items_ds.dart';

class DispensingItemsDsImpl implements DispensingItemsDs {
  final FirebaseFirestoreManager _firestore;
  DispensingItemsDsImpl(this._firestore);

  @override
  Future<Either<FirebaseErrors, List<OfficerModel>?>> getOfficers() async {
    try {
      var data = await _firestore.getOfficers();
      List<OfficerModel> officers = data.docs
          .map((e) => OfficerModel.fromJson(e.data()))
          .toList();
      return Right(officers);
    } catch (e) {
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseErrors, List<FoodModel>?>> getAvailableFoods() async {
    try {
      var data = await _firestore.getFood();
      List<FoodModel> foods = data.docs
          .map((e) => FoodModel.fromJson(e.data()))
          .toList();
      return Right(foods);
    } catch (e) {
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }
}
