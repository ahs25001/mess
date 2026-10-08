import 'package:dartz/dartz.dart';
import 'package:mess_app/core/errors/firebase_errors.dart';
import 'package:mess_app/core/models/officer_model.dart';
import 'package:mess_app/features/financials/data/data_source/financials_ds.dart';
import 'package:mess_app/features/financials/domain/repositories/financials_repo.dart';

class FinancialsRepoImpl implements FinancialsRepo {
  FinancialsDs financialsDs;
  FinancialsRepoImpl(this.financialsDs);
  @override
  Future<Either<FirebaseErrors, List<OfficerModel>?>> getOfficers() =>
      financialsDs.getOfficers();

  @override
  Future<Either<FirebaseErrors, void>> addMoney({
    required String amount,
    required OfficerModel? officer,
  }) => financialsDs.addMoney(amount: amount, officer: officer);
}
