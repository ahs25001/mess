import 'package:dartz/dartz.dart';

import 'package:mess_app/core/errors/firebase_errors.dart';
import 'package:mess_app/core/firebase/firebase_firestore_manager.dart';

import '../../../../core/models/officer_model.dart';
import 'add_new_officer_ds.dart';

class AddNewOfficerDsImpl implements AddNewOfficerDs {
  FirebaseFirestoreManager firebaseFirestoreManager;

  AddNewOfficerDsImpl(this.firebaseFirestoreManager);

  @override
  Future<Either<FirebaseErrors, void>> addNewOfficer(OfficerModel officer) async{
    try{
      await firebaseFirestoreManager.addOfficer(officer: officer);
      return Right(null);
    }catch(e){
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }

}