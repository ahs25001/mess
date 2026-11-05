import 'package:dartz/dartz.dart';

import 'package:mess_app/core/errors/shared_preferences_errors.dart';
import 'package:mess_app/core/firebase/firebase_firestore_manager.dart';
import 'package:mess_app/core/utils/app_enums.dart';

import '../../../../core/errors/firebase_errors.dart';
import '../../../../core/models/food_model.dart';
import '../../../../core/models/officer_model.dart';
import '../../../../core/shared_preferences/shared_preferences_manager.dart';
import '../../../dispensing_items/data/models/dispensing_items_model.dart';
import 'home_ds.dart';

class HomeDSImpl implements HomeDS {
  final SharedPreferencesManager _sharedPreferencesManager;
  final FirebaseFirestoreManager _firestoreManager;
  HomeDSImpl(this._sharedPreferencesManager,this._firestoreManager);
  @override
  Future<Either<SharedPreferencesLocalErrors, void>> saveString({
    required String key,
    required String value,
  }) async{
    try {
      await _sharedPreferencesManager.saveString(key, value);
      return Right(null);
    } catch (e) {
      return Left(SharedPreferencesLocalErrors(e.toString()));
    }
  }

  @override
  Future<Either<FirebaseErrors,List<FoodModel?>>>getFood()async{
    try{
      final  result = await _firestoreManager.getFood();
      var food = result.docs.map((e) => FoodModel.fromJson(e.data()),).toList();
      return Right(food);
    }catch(e){
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }
   @override
  Future<Either<FirebaseErrors, List<OfficerModel?>>> getOfficers() async{
   try{
     var result = await _firestoreManager.getOfficers();
     List<OfficerModel> officers = result.docs.map((e) => OfficerModel.fromJson(e.data()),).toList();
     return Right(officers);
   }catch(e){
     return Left(FirebaseRemoteError(error: e.toString()));
   }
  }
  @override
  Future<Either<FirebaseErrors, void>> deleteOfficer({required OfficerModel officer}) async{
   try{
     await _firestoreManager.deleteOfficer(docId: officer.id);
     return Right(null);
   }catch(e){
     return Left(FirebaseRemoteError(error: e.toString()));
   }
  }
  @override
  Future<Either<FirebaseErrors, void>> updateOfficer({required OfficerModel officer}) async{
   try{
     await _firestoreManager.updateOfficer(officer: officer);
     return Right(null);
   }catch(e){
     return Left(FirebaseRemoteError(error: e.toString()));
   }
  }
  @override
  Future<Either<FirebaseRemoteError, List<DispensingItemsModel>>> getOfficersDispensedItems(String officerId) async{
   try{
    var items = await _firestoreManager.getOfficerDispensedItems( officerId);
     return Right(items);
   }catch(e){
     return Left(FirebaseRemoteError(error: e.toString()));
   }
  }
  @override
  Either<SharedPreferencesErrors, num> getCapital() {
   try{
     var stringCapital = _sharedPreferencesManager.getString(SharedPreferencesKeys.capital.value);
     num capital = num.tryParse(stringCapital)??0;
     return Right(capital);
   }catch(e){
     return Left(SharedPreferencesLocalErrors(e.toString()));
   }
  }
  @override
  Either<SharedPreferencesErrors, num> getOfficersAmount() {
    try{
      var stringOfficersBalance = _sharedPreferencesManager.getString(SharedPreferencesKeys.officersBalance.value);
      num officersBalance = num.tryParse(stringOfficersBalance)??0;
      return Right(officersBalance);
    }catch(e){
      return Left(SharedPreferencesLocalErrors(e.toString()));
    }
  }
}
