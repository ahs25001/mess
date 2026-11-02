import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mess_app/core/firebase/firebase_firestore_manager.dart';
import 'package:mess_app/core/models/food_model.dart';
import 'package:mess_app/core/models/officer_model.dart';
import 'package:mess_app/core/shared_preferences/shared_preferences_manager.dart';
import 'package:mess_app/features/home/data/data_source/home_ds_impl.dart';
import 'package:mess_app/features/home/data/repositories/home_repo_impl.dart';
import 'package:mess_app/features/home/domain/repositories/home_repo.dart';

import '../../../../core/utils/app_enums.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  PageController pageController = PageController();
  TextEditingController updateCapitalController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController militaryIDNumberController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  FocusNode nameFocusNode = FocusNode();
  FocusNode militaryIDNumberFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();

  void changePage(int index) {
    emit(state.copyWith(status: HomeStatus.init));
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    emit(state.copyWith(currentIndex: index));
  }

  void setCapital() async {
    emit(state.copyWith(status: HomeStatus.setCapitalLoading));
    HomeRepo homeRepo = HomeRepoImpl(
      HomeDSImpl(SharedPreferencesManager(), FirebaseFirestoreManager()),
    );
    var result = await homeRepo.saveString(
      key: SharedPreferencesKeys.capital.value,
      value: updateCapitalController.text,
    );
    result.fold(
      (l) => emit(
        state.copyWith(
          status: HomeStatus.setCapitalFailure,
          errorMessage: l.message,
        ),
      ),
      (r) => emit(state.copyWith(status: HomeStatus.setCapitalSuccess)),
    );
  }

  void getFood() async {
    emit(state.copyWith(status: HomeStatus.getFoodLoading));
    HomeRepo homeRepo = HomeRepoImpl(
      HomeDSImpl(SharedPreferencesManager(), FirebaseFirestoreManager()),
    );
    var result = await homeRepo.getFood();
    result.fold(
      (l) {
        emit(
          state.copyWith(
            errorMessage: l.error,
            status: HomeStatus.getFoodFailure,
          ),
        );
      },
      (r) {
        emit(state.copyWith(status: HomeStatus.getFoodSuccess, food: r));
      },
    );
  }

  void getOfficers() async {
    HomeRepo repo = HomeRepoImpl(
      HomeDSImpl(SharedPreferencesManager(), FirebaseFirestoreManager()),
    );
    var result = await repo.getOfficers();
    result.fold(
      (l) {
        emit(
          state.copyWith(
            status: HomeStatus.getOfficersFailure,
            errorMessage: l.error,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(officers: r, status: HomeStatus.getOfficersSuccess),
        );
      },
    );
  }

  void selectRank(String rank) {
    emit(state.copyWith(selectedRank: rank));
  }

  void selectOfficer(OfficerModel? officer) {
    nameController.text = officer?.name ?? '';
    militaryIDNumberController.text =
        officer?.militaryIDNumber.toString() ?? '';
    phoneController.text = officer?.phone ?? '';
    emit(
      state.copyWith(
        selectedOfficer: officer,
        isOfficerActive: officer?.isActive,
        selectedRank: officer?.rank,
      ),
    );
  }

  void changeOfficerActivity(bool value) {
    emit(state.copyWith(isOfficerActive: value));
  }

  void updateOfficer() async {
    emit(state.copyWith(status: HomeStatus.updateOfficerLoading));
    HomeRepo repo = HomeRepoImpl(
      HomeDSImpl(SharedPreferencesManager(), FirebaseFirestoreManager()),
    );
    var result = await repo.updateOfficer(
      officer: OfficerModel(
        id: state.selectedOfficer?.id ?? '',
        consumer: state.selectedOfficer?.consumer ?? 0,
        amount: state.selectedOfficer?.amount ?? 0,
        isActive: state.isOfficerActive ?? true,
        name: nameController.text,
        rank: state.selectedRank ?? (state.selectedOfficer?.rank ?? ''),
        phone: phoneController.text,
        militaryIDNumber:
            int.tryParse(militaryIDNumberController.text) ??
            (state.selectedOfficer?.militaryIDNumber ?? 0),
      ),
    );
    result.fold(
      (l) {
        emit(
          state.copyWith(
            status: HomeStatus.updateOfficerFailure,
            errorMessage: l.error,
          ),
        );
      },
      (r) {
        nameController.clear();
        militaryIDNumberController.clear();
        phoneController.clear();
        emit(state.copyWith(status: HomeStatus.updateOfficerSuccess));
      },
    );
  }

  void deleteOfficer() async {
    if (state.selectedOfficer == null) return;
    emit(state.copyWith(status: HomeStatus.deleteOfficerLoading));
    HomeRepo repo = HomeRepoImpl(
      HomeDSImpl(SharedPreferencesManager(), FirebaseFirestoreManager()),
    );
    var result = await repo.deleteOfficer(
      officer: state.selectedOfficer!,
    );
    result.fold(
      (l) {
        emit(
          state.copyWith(
            status: HomeStatus.deleteOfficerFailure,
            errorMessage: l.error,
          ),
        );
      },
      (r) {
        nameController.clear();
        militaryIDNumberController.clear();
        phoneController.clear();
        emit(state.copyWith(status: HomeStatus.deleteOfficerSuccess));
      },
    );
  }

  @override
  Future<void> close() {
    pageController.dispose();
    updateCapitalController.dispose();
    nameController.dispose();
    militaryIDNumberController.dispose();
    phoneController.dispose();
    nameFocusNode.dispose();
    militaryIDNumberFocusNode.dispose();
    phoneFocusNode.dispose();
    return super.close();
  }

  HomeCubit() : super(HomeInitial());
}
