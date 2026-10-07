import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:mess_app/core/firebase/firebase_firestore_manager.dart';
import 'package:mess_app/features/adding_officers/data/data_source/add_new_officer_ds_impl.dart';
import 'package:mess_app/features/adding_officers/domain/repositories/add_new_officer_repo.dart';

import '../../../../core/models/officer_model.dart';
import '../../../../core/utils/app_constants.dart';
import '../../data/repositories/add_new_officer_repo_impl.dart';
part 'add_new_officer_state.dart';

class AddNewOfficerCubit extends Cubit<AddNewOfficerState> {
  TextEditingController militaryIDNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  FocusNode militaryIDNumberFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void selectedRank(String rank) {
    print("Selected rank in change $rank");
    emit(state.copyWith(selectedRank: rank, status: AddNewOfficerStateStatus.initial));
  }

  void addOfficer() async {
    emit(state.copyWith(status: AddNewOfficerStateStatus.loading));
    AddNewOfficerRepo addNewOfficerRepo = AddNewOfficerRepoImpl(
      AddNewOfficerDsImpl(FirebaseFirestoreManager()),
    );
    print("Selected rank in add ${state.selectedRank}");
    var result = await addNewOfficerRepo.addNewOfficer(
      OfficerModel(
        id: "",
        amount: 0,
        militaryIDNumber: int.tryParse(militaryIDNumberController.text) ?? 0,
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        rank: state.selectedRank ?? "",
      ),
    );
    result.fold(
      (l) {
        emit(
          state.copyWith(
            message: l.error,
            status: AddNewOfficerStateStatus.failure,
          ),
        );
      },
      (r) {
        nameController.clear();
        militaryIDNumberController.clear();
        phoneController.clear();
        emit(state.copyWith(status: AddNewOfficerStateStatus.success));
      },
    );
  }

  @override
  Future<void> close() {
    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    militaryIDNumberFocusNode.dispose();
    militaryIDNumberController.dispose();
    nameController.dispose();
    phoneController.dispose();
    return super.close();
  }

  AddNewOfficerCubit() : super(AddNewOfficerInitial());
}
