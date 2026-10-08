import 'package:dartz/dartz.dart';
import 'package:mess_app/core/errors/firebase_errors.dart';
import 'package:mess_app/core/models/officer_model.dart';

abstract class FinancialsDs {
Future<Either<FirebaseErrors,List<OfficerModel>?>>getOfficers();
Future<Either<FirebaseErrors,void>>addMoney({required String amount,required  OfficerModel? officer});
}