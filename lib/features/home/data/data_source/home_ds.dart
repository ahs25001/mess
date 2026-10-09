import 'package:dartz/dartz.dart';
import 'package:mess_app/core/errors/shared_preferences_errors.dart';

abstract class HomeDS {
  Future<Either<SharedPreferencesLocalErrors, void>> saveString({required String key, required String value});
}