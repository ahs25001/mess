import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:mess_app/core/errors/firebase_errors.dart';
import 'package:mess_app/core/firebase/firebase_firestore_manager.dart';
import 'package:mess_app/core/models/officer_model.dart';
import 'package:mess_app/features/financials/data/data_source/financials_ds.dart';

class FinancialsDsImpl implements FinancialsDs {
  FirebaseFirestoreManager firebaseFirestoreManager;
  FinancialsDsImpl(this.firebaseFirestoreManager);

  @override
  Future<Either<FirebaseErrors, List<OfficerModel>?>> getOfficers() async {
    try {
      var result = await firebaseFirestoreManager.getOfficers();
      List<OfficerModel> officers = result.docs
          .map((e) => OfficerModel.fromJson(e.data()))
          .toList();
      return Right(officers);
    } catch (e) {
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }

  @override
  Future<Either<FirebaseErrors, void>> addMoney({
    required String amount,
    required OfficerModel? officer,
  }) async {
    try {
      officer?.amount += num.tryParse(amount) ?? 0;
      await firebaseFirestoreManager.updateOfficer(officer: officer);
      return Right(null);
    } catch (e) {
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }
}
