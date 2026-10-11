import 'package:dartz/dartz.dart';

import 'package:mess_app/core/errors/firebase_errors.dart';
import 'package:mess_app/core/models/food_model.dart';

import 'package:mess_app/core/models/officer_model.dart';
import 'package:mess_app/features/dispensing_items/data/data_source/dispensing_items_ds.dart';

import '../../domain/repositories/dispensing_items_repo.dart';

class DispensingItemsRepoImpl implements DispensingItemsRepo {
  final DispensingItemsDs _ds;
  const DispensingItemsRepoImpl(this._ds);
  @override
  Future<Either<FirebaseErrors, List<OfficerModel>?>> getOfficers() =>_ds.getOfficers();

  @override
  Future<Either<FirebaseErrors, List<FoodModel>?>> getAvailableFoods() => _ds.getAvailableFoods();
}