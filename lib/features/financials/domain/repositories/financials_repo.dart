import 'package:dartz/dartz.dart';
import '../../../../core/errors/firebase_errors.dart';
import '../../../../core/models/officer_model.dart';

abstract class FinancialsRepo {
  Future<Either<FirebaseErrors, List<OfficerModel>?>> getOfficers();
  Future<Either<FirebaseErrors, void>> addMoney({required String amount, required OfficerModel? officer});
}