import 'package:dartz/dartz.dart';
import 'package:mess_app/core/errors/firebase_errors.dart';
import 'package:mess_app/core/models/month_end_closing_history_model.dart';
import 'package:mess_app/features/closing_out_the_months/data/data_source/closing_out_the_months_ds.dart';
import 'package:mess_app/features/closing_out_the_months/domain/repositories/closing_out_the_months_repo.dart';

class ClosingOutTheMonthsRepoImpl implements ClosingOutTheMonthsRepo {
  final ClosingOutTheMonthsDS _closingOutTheMonthsDS;
  const ClosingOutTheMonthsRepoImpl(this._closingOutTheMonthsDS);
  @override
  Future<Either<FirebaseErrors, List<MonthEndClosingHistoryModel>>>
  getClosingOutTheMonths() => _closingOutTheMonthsDS.getClosingOutTheMonths();
}
