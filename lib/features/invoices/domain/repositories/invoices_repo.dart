import 'package:dartz/dartz.dart';

import '../../../../core/errors/firebase_errors.dart';
import '../../../../core/models/ivoice_model.dart';

abstract class InvoicesRepo{
  Future<Either<FirebaseErrors,List<InvoiceModel>>> getInvoices();
}