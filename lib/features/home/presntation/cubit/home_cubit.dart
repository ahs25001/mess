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
import '../../../dispensing_items/data/models/dispensing_items_model.dart';
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
    var getOldCapitalResult = homeRepo.getCapital();
    getOldCapitalResult.fold(
      (l) {
        emit(
          state.copyWith(
            status: HomeStatus.setCapitalFailure,
            errorMessage: l.message,
          ),
        );
        return;
      },
      (oldCapital) async {
        if ((state.officers ?? []).isEmpty) {
          await getOfficers();
        }
        num newTotalCapital = (num.tryParse(updateCapitalController.text) ?? 0);
        num difference =
            (newTotalCapital - oldCapital) * (state.officers?.length ?? 0);
        var getOfficersAmountResult = homeRepo.getOfficersAmount();
        getOfficersAmountResult.fold(
          (l) {
            emit(
              state.copyWith(
                status: HomeStatus.setCapitalFailure,
                errorMessage: l.message,
              ),
            );
            return;
          },
          (oldAmount) async {
            var saveNewAmountResult = await homeRepo.saveString(
              key: SharedPreferencesKeys.officersBalance.value,
              value: (oldAmount + difference).toString(),
            );
            saveNewAmountResult.fold((l) {
              emit(
                state.copyWith(
                  status: HomeStatus.setCapitalFailure,
                  errorMessage: l.message,
                ),
              );
              return;
            }, (_) {});
          },
        );
      },
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
      (r) => emit(state.copyWith(status: HomeStatus.setCapitalSuccess,capital:num.tryParse(updateCapitalController.text) )),
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

  Future<void> getOfficers() async {
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
        formKey.currentState?.reset();
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
    var result = await repo.deleteOfficer(officer: state.selectedOfficer!);
    var getOfficersAmountResult = repo.getOfficersAmount();
    getOfficersAmountResult.fold(
      (l) {
        emit(
          state.copyWith(
            status: HomeStatus.deleteOfficerFailure,
            errorMessage: l.message,
          ),
        );
        return;
      },
      (officersBalance) {
        if ((state.capital ?? 0) == 0) {
          getCapital();
        }
        repo.saveString(
          key: SharedPreferencesKeys.officersBalance.value,
          value: (officersBalance - (state.capital ?? 0)).toString(),
        );
      },
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
        formKey.currentState?.reset();
        nameController.clear();
        militaryIDNumberController.clear();
        phoneController.clear();
        emit(state.copyWith(status: HomeStatus.deleteOfficerSuccess));
      },
    );
  }

  void getCapital() {
    Future.microtask(() {
      emit(state.copyWith(status: HomeStatus.getCapitalLoading));
      HomeRepo homeRepo = HomeRepoImpl(
        HomeDSImpl(SharedPreferencesManager(), FirebaseFirestoreManager()),
      );
      var result = homeRepo.getCapital();
      result.fold(
        (l) {
          print('fffffffffffffffffffffffffffffff ${l.message}');
          emit(state.copyWith(status: HomeStatus.getCapitalFailure,errorMessage: l.message));
        },
        (r) {
          emit(
            state.copyWith(status: HomeStatus.getCapitalSuccess, capital: r),
          );
        },
      );
    });
  }

  void getOfficerItems() async {
    emit(state.copyWith(status: HomeStatus.getOfficerItemsLoading));
    HomeRepo repo = HomeRepoImpl(
      HomeDSImpl(SharedPreferencesManager(), FirebaseFirestoreManager()),
    );
    var result = await repo.getOfficersDispensedItems(
      state.selectedOfficer?.id ?? '',
    );
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
          state.copyWith(
            status: HomeStatus.getOfficersSuccess,
            officerItems: r,
          ),
        );
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
