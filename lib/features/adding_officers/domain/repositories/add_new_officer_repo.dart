import 'package:dartz/dartz.dart';

import '../../../../core/errors/firebase_errors.dart';
import '../../../../core/errors/shared_preferences_errors.dart';
import '../../../../core/models/officer_model.dart';

abstract class AddNewOfficerRepo {
  Future<Either<FirebaseErrors, void>> addNewOfficer(OfficerModel officer);
  Future<Either<SharedPreferencesErrors, void>> setOfficersBalance(num balance);
  Either<SharedPreferencesErrors, num> getCapital();
}