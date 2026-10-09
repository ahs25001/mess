import 'package:dartz/dartz.dart';

import 'package:mess_app/core/errors/shared_preferences_errors.dart';

import '../../../../core/shared_preferences/shared_preferences_manager.dart';
import 'home_ds.dart';

class HomeDSImpl implements HomeDS {
  SharedPreferencesManager sharedPreferencesManager;
  HomeDSImpl(this.sharedPreferencesManager);
  @override
  Future<Either<SharedPreferencesLocalErrors, void>> saveString({
    required String key,
    required String value,
  }) async{
    try {
      await sharedPreferencesManager.saveString(key, value);
      return Right(null);
    } catch (e) {
      return Left(SharedPreferencesLocalErrors(e.toString()));
    }
  }
}
