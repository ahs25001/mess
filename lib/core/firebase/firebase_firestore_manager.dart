import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mess_app/core/models/food_model.dart';
import 'package:mess_app/core/models/ivoice_model.dart';
import '../models/officer_model.dart';

 class FirebaseFirestoreManager {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
 Future <void> addInvoice({required InvoiceModel invoice}) async{
    var doc = _firebaseFirestore.collection("Invoices").doc();
    invoice.id = doc.id;
  await doc.set(invoice.toJson());
  }  Future <void> addFood({required FoodModel food}) async{
    var doc = _firebaseFirestore.collection("Food").doc();
    food.id = doc.id;
   await doc.set(food.toJson());
  }
  Future <void> updateData({required String collection, required Map<String, dynamic> data}) async{
   await _firebaseFirestore.collection(collection).doc(data['id']).update(data);
  }

  Future<void> deleteData({required String collection, required String docId})async {
    await _firebaseFirestore.collection(collection).doc(docId).delete();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>>getFood(){
   return _firebaseFirestore.collection("Food").snapshots();
  }
  Future<void>addOfficer({required OfficerModel officer}) async{
    var doc = _firebaseFirestore.collection("Officers").doc();
    officer.id = doc.id;
    await doc.set(officer.toJson());
  }
  Future <void>deleteOfficer({required String docId}) async{
    await _firebaseFirestore.collection("Officers").doc(docId).delete();
  }
  Future<QuerySnapshot<Map<String, dynamic>>>getOfficers()async{
    return await _firebaseFirestore.collection("Officers").get();
  }
  Future<void>updateOfficer({required OfficerModel officer}) async{
    await _firebaseFirestore.collection("Officers").doc(officer.id).update(officer.toJson());
  }
  Future<DocumentSnapshot<Map<String, dynamic>>>getOfficerById({required String docId}) async{
    return await _firebaseFirestore.collection("Officers").doc(docId).get();
  }
}