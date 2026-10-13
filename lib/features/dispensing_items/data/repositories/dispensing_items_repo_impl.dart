import 'package:dartz/dartz.dart';

import 'package:mess_app/core/errors/firebase_errors.dart';
import 'package:mess_app/core/models/food_model.dart';

import 'package:mess_app/core/models/officer_model.dart';
import 'package:mess_app/features/dispensing_items/data/data_source/dispensing_items_ds.dart';

import '../../domain/repositories/dispensing_items_repo.dart';
import '../models/dispensing_items_model.dart';

class DispensingItemsRepoImpl implements DispensingItemsRepo {
  final DispensingItemsDs _ds;
  const DispensingItemsRepoImpl(this._ds);
  @override
  Future<Either<FirebaseErrors, List<OfficerModel>?>> getOfficers() =>
      _ds.getOfficers();

  @override
  Future<Either<FirebaseErrors, List<FoodModel>?>> getAvailableFoods() =>
      _ds.getAvailableFoods();

  @override
  Future<Either<FirebaseErrors, void>> addDispensingItemsToCanteen({
    required DispensingItemsModel dispensingItems,
  }) => _ds.addDispensingItemsToCanteen(dispensingItems: dispensingItems);

  @override
  Future<Either<FirebaseErrors, void>> addDispensingItemsToHarmony({
    required DispensingItemsModel dispensingItems,
  }) => _ds.addDispensingItemsToHarmony(dispensingItems: dispensingItems);

  @override
  Future<Either<FirebaseErrors, void>> addDispensingItemsToHospitality({
    required DispensingItemsModel dispensingItems,
  }) => _ds.addDispensingItemsToHospitality(dispensingItems: dispensingItems);

  @override
  Future<Either<FirebaseErrors, void>> addDispensingItemsToOfficer({
    required DispensingItemsModel dispensingItems,
  }) => _ds.addDispensingItemsToOfficer(dispensingItems: dispensingItems);

  @override
  Future<Either<FirebaseErrors, void>> updateOfficer(OfficerModel officer) =>
      _ds.updateOfficer(officer);
  @override
  Future<Either<FirebaseErrors, void>> updateFood(FoodModel food) =>_ds.updateFood(food);
}
