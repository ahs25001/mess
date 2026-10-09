import 'package:dartz/dartz.dart';
import 'package:mess_app/core/errors/shared_preferences_errors.dart';
import '../../../../core/errors/firebase_errors.dart';
import '../../../../core/models/officer_model.dart';

abstract class FinancialsRepo {
  Future<Either<FirebaseErrors, List<OfficerModel>?>> getOfficers();
  Future<Either<FirebaseErrors, void>> addMoney({required String amount, required OfficerModel? officer});
Either<SharedPreferencesErrors,num?>getCapital();
}