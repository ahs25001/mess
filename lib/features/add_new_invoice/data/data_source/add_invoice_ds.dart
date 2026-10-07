import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mess_app/core/errors/firebase_errors.dart';

import '../../../../core/models/food_model.dart';
import '../../../../core/models/ivoice_model.dart';
import 'package:dartz/dartz.dart';
abstract class  AddInvoiceDS {
  Future<Either<FirebaseErrors,void>>addNewInvoice({required InvoiceModel invoice}) ;
  Future<Either<FirebaseErrors,void>>addNewFood({required FoodModel food}) ;
  Either<Stream<QuerySnapshot<Map<String, dynamic>>>,FirebaseErrors>getFood();
  Future<Either<FirebaseErrors,void>>upDateFood({required FoodModel food}) ;
}