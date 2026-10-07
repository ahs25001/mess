part of 'add_new_officer_cubit.dart';

enum AddNewOfficerStateStatus { initial, loading, success, failure }

class AddNewOfficerState {
  String? message;
  AddNewOfficerStateStatus? status;
  String? selectedRank;
  AddNewOfficerState({this.message, this.status, this.selectedRank});
  AddNewOfficerState copyWith({
    String? message,
    String? selectedRank,
    AddNewOfficerStateStatus? status,
  }) => AddNewOfficerState(
    status: status ?? this.status,
    selectedRank: selectedRank ?? this.selectedRank,
    message: message ?? this.message,
  );
}

final class AddNewOfficerInitial extends AddNewOfficerState {
  AddNewOfficerInitial()
    : super(
        status: AddNewOfficerStateStatus.initial,
        selectedRank: AppConstants.rankList[9],
      );
}
