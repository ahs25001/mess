import 'package:dartz/dartz.dart';
import 'package:mess_app/features/invoices/domain/repositories/invoices_repo.dart';

import '../../../../core/errors/firebase_errors.dart';
import '../../../../core/models/invoice_model.dart';
import '../data_source/invoices_ds.dart';

class InvoicesRepoImpl implements InvoicesRepo{
  final InvoicesDs _invoicesDs;
  const InvoicesRepoImpl(this._invoicesDs);
  @override
  Future<Either<FirebaseErrors, List<InvoiceModel>>> getInvoices()=>_invoicesDs.getInvoices();
}