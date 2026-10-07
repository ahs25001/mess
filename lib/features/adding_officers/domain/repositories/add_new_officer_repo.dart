import 'package:dartz/dartz.dart';

import '../../../../core/errors/firebase_errors.dart';
import '../../../../core/models/officer_model.dart';

abstract class AddNewOfficerRepo {
  Future<Either<FirebaseErrors, void>> addNewOfficer(OfficerModel officer);
}