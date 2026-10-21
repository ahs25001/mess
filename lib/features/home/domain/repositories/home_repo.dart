import 'package:dartz/dartz.dart';
import 'package:mess_app/core/errors/firebase_errors.dart';
import 'package:mess_app/core/models/food_model.dart';

import '../../../../core/errors/shared_preferences_errors.dart';

abstract class HomeRepo {
  Future<Either<SharedPreferencesLocalErrors, void>> saveString({
    required String key,
    required String value,
  });
  Future<Either<FirebaseErrors,List<FoodModel?>>>getFood();
}