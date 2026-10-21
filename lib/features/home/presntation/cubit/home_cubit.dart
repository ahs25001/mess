import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mess_app/core/firebase/firebase_firestore_manager.dart';
import 'package:mess_app/core/models/food_model.dart';
import 'package:mess_app/core/shared_preferences/shared_preferences_manager.dart';
import 'package:mess_app/features/home/data/data_source/home_ds_impl.dart';
import 'package:mess_app/features/home/data/repositories/home_repo_impl.dart';
import 'package:mess_app/features/home/domain/repositories/home_repo.dart';

import '../../../../core/utils/app_enums.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  PageController pageController = PageController();
  TextEditingController updateCapitalController = TextEditingController();
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

  @override
  Future<void> close() {
    pageController.dispose();
    updateCapitalController.dispose();
    return super.close();
  }

  HomeCubit() : super(HomeInitial());
}
