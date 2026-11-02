import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'closing_out_the_months_state.dart';

class ClosingOutTheMonthsCubit extends Cubit<ClosingOutTheMonthsState> {
  ClosingOutTheMonthsCubit() : super(ClosingOutTheMonthsInitial());
}
