import 'package:dartz/dartz.dart';

import '../../../../core/errors/firebase_errors.dart';
import '../../../../core/models/food_model.dart';
import '../../../../core/models/officer_model.dart';
import '../../data/models/dispensing_items_model.dart';

abstract class DispensingItemsRepo {
  Future<Either<FirebaseErrors, List<OfficerModel>?>> getOfficers();
  Future<Either<FirebaseErrors, List<FoodModel>?>> getAvailableFoods();
  Future<Either<FirebaseErrors, void>> addDispensingItemsToOfficer({
    required DispensingItemsModel dispensingItems,
  });
  Future<Either<FirebaseErrors, void>> addDispensingItemsToHarmony({
    required DispensingItemsModel dispensingItems,
  });
  Future<Either<FirebaseErrors, void>> addDispensingItemsToCanteen({
    required DispensingItemsModel dispensingItems,
  });
  Future<Either<FirebaseErrors, void>> addDispensingItemsToHospitality({
    required DispensingItemsModel dispensingItems,
  });
  Future<Either<FirebaseErrors,void>>updateOfficer(OfficerModel officer);
  Future<Either<FirebaseErrors, void>> updateFood(FoodModel food);
}