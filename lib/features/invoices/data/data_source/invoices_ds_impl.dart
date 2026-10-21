import 'package:dartz/dartz.dart';
import 'package:mess_app/core/firebase/firebase_firestore_manager.dart';

import '../../../../core/errors/firebase_errors.dart';
import '../../../../core/models/ivoice_model.dart';
import 'invoices_ds.dart';

class InvoicesDsImpl implements InvoicesDs {
  final FirebaseFirestoreManager _firebaseFirestoreManager;
  const InvoicesDsImpl(this._firebaseFirestoreManager);
  @override
  Future<Either<FirebaseErrors, List<InvoiceModel>>> getInvoices() async {
    try {
      var docs = await _firebaseFirestoreManager.getInvoices();
      List<InvoiceModel> invoices = docs.docs.map((e) => e.data()).toList();
      return Right(invoices);
    } catch (e) {
      print(e);
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }
}
