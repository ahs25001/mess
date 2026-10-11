import 'package:dartz/dartz.dart';
import 'package:mess_app/core/errors/firebase_errors.dart';
import 'package:mess_app/core/models/officer_model.dart';

import '../../../../core/models/food_model.dart';

abstract class DispensingItemsDs {
  Future<Either<FirebaseErrors,List<OfficerModel>?>>getOfficers();
  Future<Either<FirebaseErrors,List<FoodModel>?>>getAvailableFoods();
}