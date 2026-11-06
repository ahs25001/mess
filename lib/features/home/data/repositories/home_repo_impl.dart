import 'package:dartz/dartz.dart';
import 'package:mess_app/core/errors/firebase_errors.dart';

import 'package:mess_app/core/errors/shared_preferences_errors.dart';
import 'package:mess_app/core/models/food_model.dart';
import 'package:mess_app/features/home/data/data_source/home_ds.dart';

import '../../../../core/models/officer_model.dart';
import '../../../dispensing_items/data/models/dispensing_items_model.dart';
import '../../domain/repositories/home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  final HomeDS _homeDS;
 const HomeRepoImpl(this._homeDS);
  @override
  Future<Either<SharedPreferencesLocalErrors, void>> saveString({
    required String key,
    required String value,
  }) => _homeDS.saveString(key: key, value: value);

  @override
  Future<Either<FirebaseErrors, List<FoodModel?>>> getFood() =>
      _homeDS.getFood();
  @override
  Future<Either<FirebaseErrors, List<OfficerModel?>>> getOfficers() =>
      _homeDS.getOfficers();
  @override
  Future<Either<FirebaseErrors, void>> updateOfficer({
    required OfficerModel officer,
  }) => _homeDS.updateOfficer(officer: officer);
  @override
  Future<Either<FirebaseErrors, void>> deleteOfficer({
    required OfficerModel officer,
  }) => _homeDS.deleteOfficer(officer: officer);
  @override
  Future<Either<FirebaseRemoteError, List<DispensingItemsModel>>>
  getOfficersDispensedItems(String officerId) =>
      _homeDS.getOfficersDispensedItems(officerId);
  @override
  Either<SharedPreferencesErrors, num> getCapital()=>_homeDS.getCapital();
  @override
  Either<SharedPreferencesErrors, num> getOfficersAmount()=>_homeDS.getOfficersAmount();
}
