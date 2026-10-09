import 'package:dartz/dartz.dart';

import '../../../../core/errors/shared_preferences_errors.dart';

abstract class HomeRepo {
  Future<Either<SharedPreferencesLocalErrors, void>> saveString({
    required String key,
    required String value,
  });
}