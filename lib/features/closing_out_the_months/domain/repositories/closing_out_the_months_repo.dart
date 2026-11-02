import 'package:dartz/dartz.dart';

import '../../../../core/errors/firebase_errors.dart';
import '../../../../core/models/month_end_closing_history_model.dart';

abstract class ClosingOutTheMonthsRepo {
  Future<Either<FirebaseErrors, List<MonthEndClosingHistoryModel>>>
  getClosingOutTheMonths();
}