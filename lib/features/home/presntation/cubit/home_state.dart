part of 'home_cubit.dart';
class HomeState {
  HomeStatus? status;
  int? currentIndex;
  String ? errorMessage;
  List<FoodModel?>? food;
  HomeState({this.status, this.currentIndex,this.errorMessage,this.food});
  HomeState copyWith({HomeStatus? status,String ? errorMessage, int? currentIndex,List<FoodModel?>? food}) => HomeState(
    status: status ?? this.status,
    food: food ?? this.food,
    errorMessage: errorMessage??this.errorMessage,
    currentIndex: currentIndex ?? this.currentIndex,
  );
}

final class HomeInitial extends HomeState {
  HomeInitial():super(status: HomeStatus.init,currentIndex: 0);
}
