import 'package:dartz/dartz.dart';

import 'package:mess_app/core/errors/firebase_errors.dart';
import 'package:mess_app/core/errors/shared_preferences_errors.dart';
import 'package:mess_app/core/firebase/firebase_firestore_manager.dart';
import 'package:mess_app/core/shared_preferences/shared_preferences_manager.dart';
import 'package:mess_app/core/utils/app_enums.dart';

import '../../../../core/models/officer_model.dart';
import 'add_new_officer_ds.dart';

class AddNewOfficerDsImpl implements AddNewOfficerDs {
  final FirebaseFirestoreManager _firebaseFirestoreManager;
  final SharedPreferencesManager _sharedPreferencesManager;
  const AddNewOfficerDsImpl(
    this._firebaseFirestoreManager,
    this._sharedPreferencesManager,
  );

  @override
  Future<Either<FirebaseErrors, void>> addNewOfficer(
    OfficerModel officer,
  ) async {
    try {
      await _firebaseFirestoreManager.addOfficer(officer: officer);
      return Right(null);
    } catch (e) {
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Either<SharedPreferencesErrors, num> getCapital() {
    try {
      var stringCapital = _sharedPreferencesManager.getString(
        SharedPreferencesKeys.capital.value,
      );
      num capital = num.tryParse(stringCapital) ?? 0;
      return Right(capital);
    } catch (e) {
      return Left(SharedPreferencesLocalErrors(e.toString()));
    }
  }

  @override
  Future<Either<SharedPreferencesErrors, void>> setOfficersBalance(
    num balance,
  ) async {
    try {
      var officersBalance = _sharedPreferencesManager.getString(SharedPreferencesKeys.officersBalance.value);
      await _sharedPreferencesManager.saveString(
        SharedPreferencesKeys.officersBalance.value,
        (balance+(num.tryParse(officersBalance)??0)).toString(),
      );
      return Right(null);
    } catch (e) {
      return Left(SharedPreferencesLocalErrors(e.toString()));
    }
  }
}
