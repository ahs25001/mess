import 'package:dartz/dartz.dart';

import 'package:mess_app/core/errors/firebase_errors.dart';

import 'package:mess_app/core/models/officer_model.dart';

import '../../domain/repositories/add_new_officer_repo.dart';
import '../data_source/add_new_officer_ds.dart';

class AddNewOfficerRepoImpl extends AddNewOfficerRepo {
  AddNewOfficerDs addNewOfficerDs;

  AddNewOfficerRepoImpl(this.addNewOfficerDs);

  @override
  Future<Either<FirebaseErrors, void>> addNewOfficer(OfficerModel officer) =>addNewOfficerDs.addNewOfficer(officer);
}