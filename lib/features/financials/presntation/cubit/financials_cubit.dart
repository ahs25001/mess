import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:mess_app/core/models/officer_model.dart';
import 'package:mess_app/features/financials/data/data_source/financials_ds_impl.dart';
import '../../../../core/firebase/firebase_firestore_manager.dart';
import '../../data/repositories/financials_repo_impl.dart';
import '../../domain/repositories/financials_repo.dart';

part 'financials_state.dart';

class FinancialsCubit extends Cubit<FinancialsState> {
  TextEditingController amountController = TextEditingController();
  void changeSelectedOfficer(OfficerModel? officer) {
    emit(state.copyWith(selectedOfficer: officer,status: FinancialsStatus.initial));
  }
  void getOfficers() async{
    emit(state.copyWith(status: FinancialsStatus.getOfficersLoading));
    FinancialsRepo financialsRepo = FinancialsRepoImpl(FinancialsDsImpl(FirebaseFirestoreManager()));
    var result = await financialsRepo.getOfficers();
    result.fold((l) {
      emit(state.copyWith(status: FinancialsStatus.getOfficersFailure,errorMessage: l.error));
    }, (r) {
      emit(state.copyWith(status: FinancialsStatus.getOfficersSuccess,officers: r));
    },);
  }
  void addMoney()async{
    emit(state.copyWith(status: FinancialsStatus.addMoneyLoading));
    FinancialsRepo financialsRepo = FinancialsRepoImpl(FinancialsDsImpl(FirebaseFirestoreManager()));
   var result =await financialsRepo.addMoney(amount: amountController.text, officer: state.selectedOfficer);
 result.fold((l) {
   emit(state.copyWith(status: FinancialsStatus.addMoneyFailure,errorMessage: l.error));
 }, (r) {
   emit(state.copyWith(status: FinancialsStatus.addMoneySuccess));
 },);

  }
@override
  Future<void> close() {
  amountController.dispose();
    return super.close();
  }
  FinancialsCubit() : super(FinancialsInitial());
}
