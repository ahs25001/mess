import 'package:dartz/dartz.dart';

import 'package:mess_app/core/errors/shared_preferences_errors.dart';
import 'package:mess_app/core/firebase/firebase_firestore_manager.dart';

import '../../../../core/errors/firebase_errors.dart';
import '../../../../core/models/food_model.dart';
import '../../../../core/shared_preferences/shared_preferences_manager.dart';
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
      final result = await _firestoreManager.getFood();
      var food = result.docs.map((e) => FoodModel.fromJson(e.data()),).toList();
      return Right(food);
    }catch(e){
      return Left(FirebaseRemoteError(error: e.toString()));
    }
  }
}
