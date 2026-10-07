import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import 'package:mess_app/core/errors/firebase_errors.dart';
import 'package:mess_app/core/models/food_model.dart';

import 'package:mess_app/core/models/ivoice_model.dart';

import '../../domain/repositories/add_invoice_repository.dart';
import '../data_source/add_invoice_ds.dart';

class AddInvoiceRepositoryImpl implements AddInvoiceRepository {
  AddInvoiceDS addInvoiceDS;
  AddInvoiceRepositoryImpl({required this.addInvoiceDS});
  @override
  Future<Either<FirebaseErrors, void>> addNewInvoice({
    required InvoiceModel invoice,
  }) => addInvoiceDS.addNewInvoice(invoice: invoice);
  @override
  Future<Either<FirebaseErrors, void>> addNewFood({required FoodModel food}) =>
      addInvoiceDS.addNewFood(food: food);

  @override
  Either<Stream<QuerySnapshot<Map<String, dynamic>>>, FirebaseErrors>
  getFood() => addInvoiceDS.getFood();

  @override
  Future<Either<FirebaseErrors, void>> upDateFood({required FoodModel food}) =>
      addInvoiceDS.upDateFood(food: food);
}
