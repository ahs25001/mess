import 'package:dartz/dartz.dart';

import 'package:mess_app/core/errors/firebase_errors.dart';
import 'package:mess_app/core/firebase/firebase_firestore_manager.dart';

import 'package:mess_app/core/models/month_end_closing_history_model.dart';

import 'closing_out_the_months_ds.dart';

class ClosingOutTheMonthsDSImpl implements ClosingOutTheMonthsDS {
  final FirebaseFirestoreManager _firebaseFirestoreManager;
  const ClosingOutTheMonthsDSImpl(this._firebaseFirestoreManager);
  @override
  Future<Either<FirebaseErrors, List<MonthEndClosingHistoryModel>>>
  getClosingOutTheMonths() async {
    try {
      var result = await _firebaseFirestoreManager.getMonthEndClosingHistory();
      return Right(result);
    } catch (e) {
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }
}
