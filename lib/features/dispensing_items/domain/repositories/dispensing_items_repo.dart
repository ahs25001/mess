import 'package:dartz/dartz.dart';

import '../../../../core/errors/firebase_errors.dart';
import '../../../../core/models/food_model.dart';
import '../../../../core/models/officer_model.dart';

abstract class DispensingItemsRepo {
  Future<Either<FirebaseErrors, List<OfficerModel>?>> getOfficers();
  Future<Either<FirebaseErrors, List<FoodModel>?>> getAvailableFoods();
}