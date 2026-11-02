import 'package:dartz/dartz.dart';
import 'package:mess_app/core/errors/firebase_errors.dart';

import 'package:mess_app/core/errors/shared_preferences_errors.dart';
import 'package:mess_app/core/models/food_model.dart';
import 'package:mess_app/features/home/data/data_source/home_ds.dart';

import '../../../../core/models/officer_model.dart';
import '../../domain/repositories/home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  HomeDS homeDS;
  HomeRepoImpl(this.homeDS);
  @override
  Future<Either<SharedPreferencesLocalErrors, void>> saveString({
    required String key,
    required String value,
  }) => homeDS.saveString(key: key, value: value);

  @override
  Future<Either<FirebaseErrors, List<FoodModel?>>> getFood() =>
      homeDS.getFood();
  @override
  Future<Either<FirebaseErrors, List<OfficerModel?>>> getOfficers() =>
      homeDS.getOfficers();
  @override
  Future<Either<FirebaseErrors, void>> updateOfficer({
    required OfficerModel officer,
  }) => homeDS.updateOfficer(officer: officer);
  @override
  Future<Either<FirebaseErrors, void>> deleteOfficer({
    required OfficerModel officer,
  }) => homeDS.deleteOfficer(officer: officer);
}
