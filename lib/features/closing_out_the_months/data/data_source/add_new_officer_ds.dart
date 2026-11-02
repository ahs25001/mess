import 'package:dartz/dartz.dart';
import 'package:mess_app/core/errors/firebase_errors.dart';
import 'package:mess_app/core/models/officer_model.dart';

abstract class AddNewOfficerDs {
  Future<Either<FirebaseErrors, void>> addNewOfficer(OfficerModel officer);
}