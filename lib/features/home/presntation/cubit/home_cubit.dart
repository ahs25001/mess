import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  PageController pageController = PageController();
  void changePage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    emit(state.copyWith(currentIndex: index));
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }

  HomeCubit() : super(HomeInitial());
}
