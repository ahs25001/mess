import 'package:bloc/bloc.dart';
import 'package:mess_app/core/firebase/firebase_firestore_manager.dart';
import 'package:mess_app/features/closing_out_the_months/data/data_source/closing_out_the_months_ds_impl.dart';
import 'package:mess_app/features/closing_out_the_months/data/repositories/closing_out_the_months_repo_impl.dart';
import 'package:mess_app/features/closing_out_the_months/domain/repositories/closing_out_the_months_repo.dart';

import '../../../../core/models/month_end_closing_history_model.dart';
import '../../../../core/utils/app_enums.dart';
part 'closing_out_the_months_state.dart';

class ClosingOutTheMonthsCubit extends Cubit<ClosingOutTheMonthsState> {
  Future<void> getClosingOutTheMonths() async {
    emit(state.copyWith(status: ClosingOutTheMonthsStatus.loading));
    ClosingOutTheMonthsRepo closingOutTheMonthsRepo =
        ClosingOutTheMonthsRepoImpl(
          ClosingOutTheMonthsDSImpl(FirebaseFirestoreManager()),
        );
    var result = await closingOutTheMonthsRepo.getClosingOutTheMonths();
    result.fold(
      (l) {
        emit(
          state.copyWith(
            status: ClosingOutTheMonthsStatus.failure,
            message: l.error,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            status: ClosingOutTheMonthsStatus.success,
            closingOutTheMonths: r,
          ),
        );
      },
    );
  }

  ClosingOutTheMonthsCubit() : super(ClosingOutTheMonthsInitial()) {
    getClosingOutTheMonths();
  }
}
