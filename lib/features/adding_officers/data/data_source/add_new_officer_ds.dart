import 'package:dartz/dartz.dart';
import 'package:mess_app/core/errors/firebase_errors.dart';
import 'package:mess_app/core/models/officer_model.dart';

import '../../../../core/errors/shared_preferences_errors.dart';

abstract class AddNewOfficerDs {
  Future<Either<FirebaseErrors, void>> addNewOfficer(OfficerModel officer);
  Future<Either<SharedPreferencesErrors, void>> setOfficersBalance(num balance);
  Either<SharedPreferencesErrors, num> getCapital();
}