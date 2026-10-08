part of 'home_cubit.dart';

enum HomeStatus { inet ,loading, success, failure }

class HomeState {
  HomeStatus? status;
  int? currentIndex;
  HomeState({this.status, this.currentIndex});
  HomeState copyWith({HomeStatus? status, int? currentIndex}) => HomeState(
    status: status ?? this.status,
    currentIndex: currentIndex ?? this.currentIndex,
  );
}

final class HomeInitial extends HomeState {
  HomeInitial():super(status: HomeStatus.inet,currentIndex: 0);
}
