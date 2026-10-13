import 'package:dartz/dartz.dart';

import 'package:mess_app/core/errors/firebase_errors.dart';
import 'package:mess_app/core/firebase/firebase_firestore_manager.dart';
import 'package:mess_app/core/models/food_model.dart';

import 'package:mess_app/core/models/officer_model.dart';

import '../models/dispensing_items_model.dart';
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

  @override
  Future<Either<FirebaseRemoteError, void>> addDispensingItemsToHarmony({
    required DispensingItemsModel dispensingItems,
  }) async{
    try{
      await _firestore.addDispensingItemsToHarmony(dispensingItems: dispensingItems);
      return Right(null);
    }catch(e){
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseRemoteError, void>> addDispensingItemsToHospitality({
    required DispensingItemsModel dispensingItems,
  }) async{
    try{
      await _firestore.addDispensingItemsToHospitality(dispensingItems: dispensingItems);
      return Right(null);
    }catch(e){
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseRemoteError, void>> addDispensingItemsToOfficer({
    required DispensingItemsModel dispensingItems,
  })async {
    try{
      await _firestore.addDispensingItemsToOfficer(dispensingItems: dispensingItems);
      return Right(null);
    }catch(e){
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseRemoteError, void>> addDispensingItemsToCanteen({
    required DispensingItemsModel dispensingItems,
  }) async{
    try{
      await _firestore.addDispensingItemsToCanteen(dispensingItems: dispensingItems);
      return Right(null);
    }catch(e){
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseRemoteError, void>> updateOfficer(OfficerModel officer) async{
   try{
    await  _firestore.updateOfficer(officer: officer);
    return Right(null);
   }catch(e){
     return Left(FirebaseRemoteError(error: e.toString()));
   }
  }
  @override
  Future<Either<FirebaseErrors, void>> updateFood(FoodModel food)async {
    try{
      await _firestore.updateFood(food);
      return Right(null);
    }catch(e){
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }
}
