import 'package:dartz/dartz.dart';
import 'package:mess_app/core/errors/firebase_errors.dart';
import 'package:mess_app/core/models/month_end_closing_history_model.dart';

abstract class ClosingOutTheMonthsDS  {
  Future<Either<FirebaseErrors,List<MonthEndClosingHistoryModel>>>getClosingOutTheMonths();
}