part of 'closing_out_the_months_cubit.dart';

class ClosingOutTheMonthsState {
  ClosingOutTheMonthsStatus? status;
  String? message;
  List<MonthEndClosingHistoryModel>? closingOutTheMonths;
  ClosingOutTheMonthsState({
    this.status,
    this.message,
    this.closingOutTheMonths,
  });
  ClosingOutTheMonthsState copyWith({
    ClosingOutTheMonthsStatus? status,
    String? message,
    List<MonthEndClosingHistoryModel>? closingOutTheMonths,
  }) => ClosingOutTheMonthsState(
    status: status,
    message: message,
    closingOutTheMonths: closingOutTheMonths,
  );
}

final class ClosingOutTheMonthsInitial extends ClosingOutTheMonthsState {
   ClosingOutTheMonthsInitial():super(status: ClosingOutTheMonthsStatus.init);
}
