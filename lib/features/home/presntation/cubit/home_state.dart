part of 'home_cubit.dart';
class HomeState {
  HomeStatus? status;
  int? currentIndex;
  String ? errorMessage;
  HomeState({this.status, this.currentIndex,this.errorMessage});
  HomeState copyWith({HomeStatus? status,String ? errorMessage, int? currentIndex}) => HomeState(
    status: status ?? this.status,
    errorMessage: errorMessage??this.errorMessage,
    currentIndex: currentIndex ?? this.currentIndex,
  );
}

final class HomeInitial extends HomeState {
  HomeInitial():super(status: HomeStatus.init,currentIndex: 0);
}
