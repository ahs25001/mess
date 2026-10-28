import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mess_app/core/models/food_model.dart';
import 'package:mess_app/core/models/invoice_model.dart';
import '../../features/dispensing_items/data/models/dispensing_items_model.dart';
import '../models/month_end_closing_history_model.dart';
import '../models/officer_model.dart';

class FirebaseFirestoreManager {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<void> addInvoice({required InvoiceModel invoice}) async {
    var doc = _firebaseFirestore.collection("Invoices").doc();
    invoice.id = doc.id;
    await doc.set(invoice.toJson());
  }

  Future<QuerySnapshot<InvoiceModel>> getInvoices() async {
    var docs = await _firebaseFirestore
        .collection("Invoices")
        .withConverter(
          fromFirestore: (snapshot, options) =>
              InvoiceModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        )
        .orderBy('date', descending: true)
        .get();
    return docs;
  }

  Future<void> deleteAllInvoices() async {
    var docs = await _firebaseFirestore
        .collection("Invoices")
        .withConverter(
          fromFirestore: (snapshot, options) =>
              InvoiceModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        )
        .get();
    List<InvoiceModel> invoices = docs.docs.map((e) => e.data()).toList();
    for (InvoiceModel invoice in invoices) {
      await _firebaseFirestore.collection("Invoices").doc(invoice.id).delete();
    }
  }

  Future<void> addFood({required FoodModel food}) async {
    var doc = _firebaseFirestore.collection("Food").doc();
    food.id = doc.id;
    await doc.set(food.toJson());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllFood() {
    return _firebaseFirestore.collection("Food").snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getFood() async {
    return await _firebaseFirestore
        .collection("Food")
        .where('isVariableMiscellaneousExpenses', isEqualTo: false)
        .where('isFixedMiscellaneousExpenses', isEqualTo: false)
        .where('quantity', isNotEqualTo: 0)
        .get();
  }

  Future<void> updateFood(FoodModel? food) async {
    await _firebaseFirestore
        .collection("Food")
        .doc(food?.id)
        .update(food?.toJson() ?? {});
  }

  Future<void> addDispensingItemsToOfficer({
    required DispensingItemsModel dispensingItems,
  }) async {
    var doc = _firebaseFirestore.collection("DispensingItemsToOfficer").doc();
    dispensingItems.id = doc.id;
    await doc.set(dispensingItems.toJson());
  }

  Future<void> addDispensingItemsToCanteen({
    required DispensingItemsModel dispensingItems,
  }) async {
    var doc = _firebaseFirestore.collection("DispensingItemsToCanteen").doc();
    dispensingItems.id = doc.id;
    await doc.set(dispensingItems.toJson());
  }

  Future<void> addDispensingItemsToHospitality({
    required DispensingItemsModel dispensingItems,
  }) async {
    var doc = _firebaseFirestore.collection("Hospitality").doc();
    dispensingItems.id = doc.id;
    await doc.set(dispensingItems.toJson());
  }

  Future<QuerySnapshot<DispensingItemsModel>> getHospitality() async {
    var data = await _firebaseFirestore
        .collection("Hospitality")
        .withConverter(
          fromFirestore: (snapshot, options) =>
              DispensingItemsModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        )
        .get();
    return data;
  }

  Future<QuerySnapshot<DispensingItemsModel>> getCanteen() async {
    var data = await _firebaseFirestore
        .collection("DispensingItemsToCanteen")
        .withConverter(
          fromFirestore: (snapshot, options) =>
              DispensingItemsModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        )
        .get();
    return data;
  }

  Future<void> addDispensingItemsToHarmony({
    required DispensingItemsModel dispensingItems,
  }) async {
    var doc = _firebaseFirestore.collection("Harmony").doc();
    dispensingItems.id = doc.id;
    await doc.set(dispensingItems.toJson());
  }

  Future<List<DispensingItemsModel>> getPerishes() async {
    var doc = await _firebaseFirestore
        .collection("Harmony")
        .withConverter(
          fromFirestore: (snapshot, options) =>
              DispensingItemsModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        )
        .get();
    List<DispensingItemsModel> items = doc.docs.map((e) => e.data()).toList();
    return items;
  }

  Future<void> deletePerishes({required String docId}) async {
    await _firebaseFirestore.collection("Harmony").doc(docId).delete();
  }

  Future<void> addOfficer({required OfficerModel officer}) async {
    var doc = _firebaseFirestore.collection("Officers").doc();
    officer.id = doc.id;
    await doc.set(officer.toJson());
  }

  Future<void> deleteOfficer({required String docId}) async {
    await _firebaseFirestore.collection("Officers").doc(docId).delete();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getOfficers() async {
    return await _firebaseFirestore
        .collection("Officers")
        .orderBy('militaryIDNumber', descending: false)
        .get();
  }

  Future<void> updateOfficer({required OfficerModel? officer}) async {
    await _firebaseFirestore
        .collection("Officers")
        .doc(officer?.id)
        .update(officer?.toJson() ?? {});
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getOfficerById({
    required String docId,
  }) async {
    return await _firebaseFirestore.collection("Officers").doc(docId).get();
  }

  Future<void> addMonthEndClosingHistory({
    required MonthEndClosingHistoryModel monthEndClosingHistoryModel,
  }) async {
    var doc = _firebaseFirestore.collection("MonthEndClosingHistory").doc();
    monthEndClosingHistoryModel.id = doc.id;
    await doc.set(monthEndClosingHistoryModel.toJson());
  }

  Future<MonthEndClosingHistoryModel> getMonthEndClosingHistory() async {
    var data = await _firebaseFirestore
        .collection("MonthEndClosingHistory")
        .doc()
        .get();
    return MonthEndClosingHistoryModel.fromJson(data.data()!);
  }
}
