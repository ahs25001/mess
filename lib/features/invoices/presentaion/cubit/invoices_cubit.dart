import 'package:bloc/bloc.dart';
import 'package:mess_app/core/firebase/firebase_firestore_manager.dart';
import 'package:mess_app/core/models/invoice_model.dart';
import 'package:mess_app/features/invoices/domain/repositories/invoices_repo.dart';
import '../../data/data_source/invoices_ds_impl.dart';
import '../../data/repositories/invoices_repo_impl.dart';
part 'invoices_state.dart';

class InvoicesCubit extends Cubit<InvoicesState> {
  Future<void> getInvoices() async {
    emit(InvoicesState(status: InvoicesStatus.loading));
    InvoicesRepo repo = InvoicesRepoImpl(
      InvoicesDsImpl(FirebaseFirestoreManager()),
    );
    var result = await repo.getInvoices();
    result.fold(
      (l) {
        emit(state.copyWith(status: InvoicesStatus.failure, message: l.error));
      },
      (r) {
        emit(state.copyWith(status: InvoicesStatus.success, invoices: r));
      },
    );
  }

  InvoicesCubit() : super(InvoicesInitial()){
    getInvoices();
  }
}
