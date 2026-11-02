import 'package:dartz/dartz.dart';
import 'package:mess_app/core/errors/shared_preferences_errors.dart';
import '../../../../core/errors/firebase_errors.dart';
import '../../../../core/models/food_model.dart';
import '../../../../core/models/officer_model.dart';

abstract class HomeDS {
  Future<Either<SharedPreferencesLocalErrors, void>> saveString({required String key, required String value});
  Future<Either<FirebaseErrors,List<FoodModel?>>>getFood();
  Future<Either<FirebaseErrors,List<OfficerModel?>>>getOfficers();
  Future<Either<FirebaseErrors,void>>updateOfficer({required OfficerModel officer});
  Future<Either<FirebaseErrors,void>>deleteOfficer({required OfficerModel officer});
}