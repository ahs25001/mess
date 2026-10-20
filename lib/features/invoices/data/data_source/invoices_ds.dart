import 'package:dartz/dartz.dart';
import 'package:mess_app/core/errors/firebase_errors.dart';

import '../../../../core/models/ivoice_model.dart';

abstract class InvoicesDs {
  Future<Either<FirebaseErrors,List<InvoiceModel>>> getInvoices();
}