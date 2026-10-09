import 'package:dartz/dartz.dart';

import 'package:mess_app/core/errors/shared_preferences_errors.dart';
import 'package:mess_app/features/home/data/data_source/home_ds.dart';

import '../../domain/repositories/home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  HomeDS homeDS;
  HomeRepoImpl(this.homeDS);
  @override
  Future<Either<SharedPreferencesLocalErrors, void>> saveString({
    required String key,
    required String value,
  }) => homeDS.saveString(key: key, value: value);
}
