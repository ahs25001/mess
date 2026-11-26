import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mess_app/core/firebase/firebase_firestore_manager.dart';
import 'package:mess_app/core/models/food_model.dart';
import 'package:mess_app/core/models/invoice_model.dart';
import 'package:mess_app/core/models/month_end_closing_history_model.dart';
import 'package:mess_app/core/models/officer_model.dart';
import 'package:mess_app/core/shared_preferences/shared_preferences_manager.dart';
import 'package:mess_app/features/home/data/data_source/home_ds_impl.dart';
import 'package:mess_app/features/home/data/repositories/home_repo_impl.dart';
import 'package:mess_app/features/home/domain/repositories/home_repo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/utils/app_enums.dart';
import '../../../dispensing_items/data/models/dispensing_items_model.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  PageController pageController = PageController();
  TextEditingController updateCapitalController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController militaryIDNumberController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  FocusNode nameFocusNode = FocusNode();
  FocusNode militaryIDNumberFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();

  void changePage(int index) {
    emit(state.copyWith(status: HomeStatus.init));
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    emit(state.copyWith(currentIndex: index));
  }

  void setCapital() async {
    emit(state.copyWith(status: HomeStatus.setCapitalLoading));
    HomeRepo homeRepo = HomeRepoImpl(
      HomeDSImpl(SharedPreferencesManager(), FirebaseFirestoreManager()),
    );
    var getOldCapitalResult = homeRepo.getCapital();
    getOldCapitalResult.fold(
      (l) {
        emit(
          state.copyWith(
            status: HomeStatus.setCapitalFailure,
            errorMessage: l.message,
          ),
        );
        return;
      },
      (oldCapital) async {
        if ((state.officers ?? []).isEmpty) {
          await getOfficers();
        }
        num newTotalCapital = (num.tryParse(updateCapitalController.text) ?? 0);
        num difference =
            (newTotalCapital - oldCapital) * (state.officers?.length ?? 0);
        var getOfficersAmountResult = homeRepo.getOfficersAmount();
        getOfficersAmountResult.fold(
          (l) {
            emit(
              state.copyWith(
                status: HomeStatus.setCapitalFailure,
                errorMessage: l.message,
              ),
            );
            return;
          },
          (oldAmount) async {
            var saveNewAmountResult = await homeRepo.saveString(
              key: SharedPreferencesKeys.officersBalance.value,
              value: (oldAmount + difference).toString(),
            );
            saveNewAmountResult.fold((l) {
              emit(
                state.copyWith(
                  status: HomeStatus.setCapitalFailure,
                  errorMessage: l.message,
                ),
              );
              return;
            }, (_) {});
          },
        );
      },
    );
    var result = await homeRepo.saveString(
      key: SharedPreferencesKeys.capital.value,
      value: updateCapitalController.text,
    );
    result.fold(
      (l) => emit(
        state.copyWith(
          status: HomeStatus.setCapitalFailure,
          errorMessage: l.message,
        ),
      ),
      (r) => emit(
        state.copyWith(
          status: HomeStatus.setCapitalSuccess,
          capital: num.tryParse(updateCapitalController.text),
        ),
      ),
    );
  }

  void getFood() async {
    emit(state.copyWith(status: HomeStatus.getFoodLoading));
    HomeRepo homeRepo = HomeRepoImpl(
      HomeDSImpl(SharedPreferencesManager(), FirebaseFirestoreManager()),
    );
    var result = await homeRepo.getFood();
    result.fold(
      (l) {
        emit(
          state.copyWith(
            errorMessage: l.error,
            status: HomeStatus.getFoodFailure,
          ),
        );
      },
      (r) {
        emit(state.copyWith(status: HomeStatus.getFoodSuccess, food: r));
      },
    );
  }

  Future<void> getOfficers() async {
    HomeRepo repo = HomeRepoImpl(
      HomeDSImpl(SharedPreferencesManager(), FirebaseFirestoreManager()),
    );
    var result = await repo.getOfficers();
    result.fold(
      (l) {
        emit(
          state.copyWith(
            status: HomeStatus.getOfficersFailure,
            errorMessage: l.error,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(officers: r, status: HomeStatus.getOfficersSuccess),
        );
      },
    );
  }

  void selectRank(String rank) {
    emit(state.copyWith(selectedRank: rank));
  }

  void selectOfficer(OfficerModel? officer) {
    nameController.text = officer?.name ?? '';
    militaryIDNumberController.text =
        officer?.militaryIDNumber.toString() ?? '';
    phoneController.text = officer?.phone ?? '';
    emit(
      state.copyWith(
        selectedOfficer: officer,
        isOfficerActive: officer?.isActive,
        selectedRank: officer?.rank,
      ),
    );
  }

  void changeOfficerActivity(bool value) {
    emit(state.copyWith(isOfficerActive: value));
  }

  void updateOfficer() async {
    emit(state.copyWith(status: HomeStatus.updateOfficerLoading));
    HomeRepo repo = HomeRepoImpl(
      HomeDSImpl(SharedPreferencesManager(), FirebaseFirestoreManager()),
    );
    var result = await repo.updateOfficer(
      officer: OfficerModel(
        id: state.selectedOfficer?.id ?? '',
        consumer: state.selectedOfficer?.consumer ?? 0,
        amount: state.selectedOfficer?.amount ?? 0,
        isActive: state.isOfficerActive ?? true,
        name: nameController.text,
        rank: state.selectedRank ?? (state.selectedOfficer?.rank ?? ''),
        phone: phoneController.text,
        militaryIDNumber:
            int.tryParse(militaryIDNumberController.text) ??
            (state.selectedOfficer?.militaryIDNumber ?? 0),
      ),
    );
    result.fold(
      (l) {
        emit(
          state.copyWith(
            status: HomeStatus.updateOfficerFailure,
            errorMessage: l.error,
          ),
        );
      },
      (r) {
        formKey.currentState?.reset();
        nameController.clear();
        militaryIDNumberController.clear();
        phoneController.clear();
        emit(state.copyWith(status: HomeStatus.updateOfficerSuccess));
      },
    );
  }

  void deleteOfficer() async {
    if (state.selectedOfficer == null) return;
    emit(state.copyWith(status: HomeStatus.deleteOfficerLoading));
    HomeRepo repo = HomeRepoImpl(
      HomeDSImpl(SharedPreferencesManager(), FirebaseFirestoreManager()),
    );
    var result = await repo.deleteOfficer(officer: state.selectedOfficer!);
    var getOfficersAmountResult = repo.getOfficersAmount();
    getOfficersAmountResult.fold(
      (l) {
        emit(
          state.copyWith(
            status: HomeStatus.deleteOfficerFailure,
            errorMessage: l.message,
          ),
        );
        return;
      },
      (officersBalance) {
        if ((state.capital ?? 0) == 0) {
          getCapital();
        }
        repo.saveString(
          key: SharedPreferencesKeys.officersBalance.value,
          value: (officersBalance - (state.capital ?? 0)).toString(),
        );
      },
    );
    result.fold(
      (l) {
        emit(
          state.copyWith(
            status: HomeStatus.deleteOfficerFailure,
            errorMessage: l.error,
          ),
        );
      },
      (r) {
        formKey.currentState?.reset();
        nameController.clear();
        militaryIDNumberController.clear();
        phoneController.clear();
        emit(state.copyWith(status: HomeStatus.deleteOfficerSuccess));
      },
    );
  }

  void getCapital() {
    Future.microtask(() {
      emit(state.copyWith(status: HomeStatus.getCapitalLoading));
      HomeRepo homeRepo = HomeRepoImpl(
        HomeDSImpl(SharedPreferencesManager(), FirebaseFirestoreManager()),
      );
      var result = homeRepo.getCapital();
      result.fold(
        (l) {
          print('fffffffffffffffffffffffffffffff ${l.message}');
          emit(
            state.copyWith(
              status: HomeStatus.getCapitalFailure,
              errorMessage: l.message,
            ),
          );
        },
        (r) {
          emit(
            state.copyWith(status: HomeStatus.getCapitalSuccess, capital: r),
          );
        },
      );
    });
  }

  void getOfficerItems() async {
    emit(state.copyWith(status: HomeStatus.getOfficerItemsLoading));
    HomeRepo repo = HomeRepoImpl(
      HomeDSImpl(SharedPreferencesManager(), FirebaseFirestoreManager()),
    );
    var result = await repo.getOfficersDispensedItems(
      state.selectedOfficer?.id ?? '',
    );
    result.fold(
      (l) {
        emit(
          state.copyWith(
            status: HomeStatus.getOfficersFailure,
            errorMessage: l.error,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            status: HomeStatus.getOfficersSuccess,
            officerItems: r,
          ),
        );
      },
    );
  }

  Future<void> exportDatabase() async {
    emit(
      state.copyWith(status: HomeStatus.exportDatabaseLoading, progress: 0.0),
    );
    try {
      final firestore = FirebaseFirestore.instance;
      final collectionsToExport = [
        "Food",
        "Officers",
        "Invoices",
        "DispensingItemsToOfficer",
        "DispensingItemsToCanteen",
        "Hospitality",
        "Harmony",
        "MonthEndClosingHistory",
      ];

      final Map<String, dynamic> collectionsData = {};

      for (int i = 0; i < collectionsToExport.length; i++) {
        final colName = collectionsToExport[i];
        final querySnapshot = await firestore.collection(colName).get();
        final List<Map<String, dynamic>> docsData = querySnapshot.docs.map((
          doc,
        ) {
          final data = Map<String, dynamic>.from(doc.data());
          data['id'] = doc.id;
          return _jsonifyMap(data);
        }).toList();
        collectionsData[colName] = docsData;

        final double collectionProgress =
            ((i + 1) / collectionsToExport.length) * 0.75;
        emit(
          state.copyWith(status: HomeStatus.init, progress: collectionProgress),
        );
      }

      final prefsManager = SharedPreferencesManager();
      final Map<String, String> prefsData = {};
      for (var key in SharedPreferencesKeys.values) {
        prefsData[key.value] = prefsManager.getString(key.value);
      }
      emit(state.copyWith(progress: 0.85));

      final Map<String, dynamic> fullBackupMap = {
        "version": 1,
        "exportDate": DateTime.now().toIso8601String(),
        "sharedPreferences": prefsData,
        "collections": collectionsData,
      };

      final jsonString = jsonEncode(
        fullBackupMap,
        toEncodable: _toEncodableFallback,
      );
      emit(state.copyWith(progress: 0.90));

      final directory = await getTemporaryDirectory();
      final dateStr = DateTime.now()
          .toString()
          .split('.')[0]
          .replaceAll(':', '-')
          .replaceAll(' ', '_');
      final filePath = '${directory.path}/mess_backup_$dateStr.json';
      final file = File(filePath);
      await file.writeAsString(jsonString);
      emit(state.copyWith(progress: 0.95));

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'تصدير قاعدة بيانات تطبيق حسابات الميس',
        subject: 'نسخة احتياطية لقاعدة البيانات',
      );

      emit(
        state.copyWith(status: HomeStatus.exportDatabaseSuccess, progress: 1.0),
      );
    } catch (e) {
      print('>>> [exportDatabase] ERROR: $e');
      emit(
        state.copyWith(
          status: HomeStatus.exportDatabaseFailure,
          errorMessage: 'فشل تصدير قاعدة البيانات: ${e.toString()}',
        ),
      );
    }
  }

  dynamic _toEncodableFallback(dynamic nonEncodable) {
    if (nonEncodable is Timestamp) {
      return {
        'type': 'Timestamp',
        'seconds': nonEncodable.seconds,
        'nanoseconds': nonEncodable.nanoseconds,
      };
    } else if (nonEncodable is DateTime) {
      return {
        'type': 'Timestamp',
        'seconds': nonEncodable.millisecondsSinceEpoch ~/ 1000,
        'nanoseconds': (nonEncodable.millisecondsSinceEpoch % 1000) * 1000000,
      };
    }
    return nonEncodable.toString();
  }

  Map<String, dynamic> _jsonifyMap(Map<String, dynamic> map) {
    return map.map((key, value) => MapEntry(key, _jsonifyValue(value)));
  }

  dynamic _jsonifyValue(dynamic value) {
    if (value is Timestamp) {
      return {
        'type': 'Timestamp',
        'seconds': value.seconds,
        'nanoseconds': value.nanoseconds,
      };
    } else if (value is DateTime) {
      return {
        'type': 'Timestamp',
        'seconds': value.millisecondsSinceEpoch ~/ 1000,
        'nanoseconds': (value.millisecondsSinceEpoch % 1000) * 1000000,
      };
    } else if (value is DocumentReference) {
      return {'type': 'DocumentReference', 'path': value.path};
    } else if (value is Map) {
      return _jsonifyMap(Map<String, dynamic>.from(value));
    } else if (value is List) {
      return value.map((e) => _jsonifyValue(e)).toList();
    }
    return value;
  }

  Map<String, dynamic> _dejsonifyMap(Map<String, dynamic> map) {
    return map.map((key, value) => MapEntry(key, _dejsonifyValue(value, key)));
  }

  dynamic _dejsonifyValue(dynamic value, [String? keyName]) {
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      final type = map['type'] ?? map['__type__'];
      if (type == 'Timestamp' &&
          map.containsKey('seconds') &&
          map.containsKey('nanoseconds')) {
        return Timestamp(map['seconds'] as int, map['nanoseconds'] as int);
      } else if (type == 'DocumentReference' && map.containsKey('path')) {
        return FirebaseFirestore.instance.doc(map['path'] as String);
      }
      return _dejsonifyMap(map);
    } else if (value is List) {
      return value.map((e) => _dejsonifyValue(e)).toList();
    } else if (value is int && (keyName == 'date' || keyName == 'timestamp')) {
      if (value > 1000000000000000) {
        return Timestamp.fromMicrosecondsSinceEpoch(value);
      } else if (value > 100000000000) {
        return Timestamp.fromMillisecondsSinceEpoch(value);
      } else {
        return Timestamp(value, 0);
      }
    } else if (value is String &&
        (keyName == 'date' || keyName == 'timestamp')) {
      final dt = DateTime.tryParse(value);
      if (dt != null) return Timestamp.fromDate(dt);
    }
    return value;
  }

  Map<String, dynamic> _convertDocToModelJson(
    String colName,
    Map<String, dynamic> docMap,
  ) {
    try {
      switch (colName) {
        case "Food":
          if (docMap.containsKey("quantity") && docMap["quantity"] is num) {
            docMap["quantity"] = (docMap["quantity"] as num).toDouble();
          }
          docMap["prices"] ??= [];
          docMap["isFixedMiscellaneousExpenses"] ??= false;
          docMap["isVariableMiscellaneousExpenses"] ??= false;
          final model = FoodModel.fromJson(docMap);
          final json = model.toJson();
          if (docMap.containsKey("id") && docMap["id"] != null) {
            json["id"] = docMap["id"];
          }
          return json;

        case "Officers":
          docMap['consumer'] = (docMap['consumer'] as num?) ?? 0;
          docMap['amount'] = (docMap['amount'] as num?) ?? 0;
          docMap['militaryIDNumber'] =
              (docMap['militaryIDNumber'] as num?) ?? 0;
          docMap['isActive'] = docMap['isActive'] ?? true;
          final model = OfficerModel.fromJson(docMap);
          final json = model.toJson();
          if (docMap.containsKey("id") && docMap["id"] != null) {
            json["id"] = docMap["id"];
          }
          return json;

        case "Invoices":
          if (docMap['date'] is DateTime) {
            docMap['date'] = Timestamp.fromDate(docMap['date'] as DateTime);
          } else if (docMap['date'] is String) {
            final dt = DateTime.tryParse(docMap['date'] as String);
            docMap['date'] = dt != null
                ? Timestamp.fromDate(dt)
                : Timestamp.now();
          } else if (docMap['date'] is! Timestamp) {
            docMap['date'] = Timestamp.now();
          }
          final model = InvoiceModel.fromJson(docMap);
          final json = model.toJson();
          if (docMap.containsKey("id") && docMap["id"] != null) {
            json["id"] = docMap["id"];
          }
          return json;

        case "DispensingItemsToOfficer":
        case "DispensingItemsToCanteen":
        case "Hospitality":
        case "Harmony":
          if (docMap['date'] is DateTime) {
            docMap['date'] = Timestamp.fromDate(docMap['date'] as DateTime);
          } else if (docMap['date'] is String) {
            final dt = DateTime.tryParse(docMap['date'] as String);
            docMap['date'] = dt != null
                ? Timestamp.fromDate(dt)
                : Timestamp.now();
          } else if (docMap['date'] is! Timestamp) {
            docMap['date'] = Timestamp.now();
          }

          if (docMap['food'] is Map) {
            final foodMap = Map<String, dynamic>.from(docMap['food'] as Map);
            if (foodMap.containsKey("quantity") && foodMap["quantity"] is num) {
              foodMap["quantity"] = (foodMap["quantity"] as num).toDouble();
            }
            foodMap["prices"] ??= [];
            docMap['food'] = foodMap;
          }

          if (docMap['officersIds'] is List) {
            docMap['officersIds'] = (docMap['officersIds'] as List)
                .map((e) => e.toString())
                .toList();
          } else {
            docMap['officersIds'] = <String>[];
          }

          final model = DispensingItemsModel.fromJson(docMap);
          final json = model.toJson();
          if (docMap.containsKey("id") && docMap["id"] != null) {
            json["id"] = docMap["id"];
          }
          return json;

        case "MonthEndClosingHistory":
          if (docMap['date'] is DateTime) {
            docMap['date'] = Timestamp.fromDate(docMap['date'] as DateTime);
          } else if (docMap['date'] is String) {
            final dt = DateTime.tryParse(docMap['date'] as String);
            docMap['date'] = dt != null
                ? Timestamp.fromDate(dt)
                : Timestamp.now();
          } else if (docMap['date'] is! Timestamp) {
            docMap['date'] = Timestamp.now();
          }

          final model = MonthEndClosingHistoryModel.fromJson(docMap);
          final json = model.toJson();
          if (docMap.containsKey("id") && docMap["id"] != null) {
            json["id"] = docMap["id"];
          }
          return json;

        default:
          return docMap;
      }
    } catch (e) {
      print('>>> [importDatabase] Model conversion fallback for $colName: $e');
      return docMap;
    }
  }

  void importDatabase() async {
    try {
      print('>>> [importDatabase] Opening file picker...');
      final result = await FilePickerPlatform.instance.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if ( result.single.path == null) {
        print('>>> [importDatabase] File picking cancelled by user.');
        return;
      }

      print('>>> [importDatabase] File selected: ${result.single.path}');
      emit(
        state.copyWith(
          status: HomeStatus.importDatabaseLoading,
          progress: 0.05,
        ),
      );

      print('>>> [importDatabase] Reading file from disk...');
      final file = File(result.single.path!);
      final content = await file.readAsString();
      print(
        '>>> [importDatabase] File read (${(content.length / 1024).toStringAsFixed(1)} KB). Parsing JSON in isolate...',
      );

      final Map<String, dynamic> fullBackupMap = await compute(
        _parseJsonIsolate,
        content,
      );
      print('>>> [importDatabase] JSON decoded successfully.');
      emit(state.copyWith(status: HomeStatus.init, progress: 0.15));

      // 1. Restore SharedPreferences
      if (fullBackupMap.containsKey("sharedPreferences")) {
        final prefsData = Map<String, dynamic>.from(
          fullBackupMap["sharedPreferences"],
        );
        print(
          '>>> [importDatabase] Restoring SharedPreferences (${prefsData.length} keys)...',
        );
        final prefsManager = SharedPreferencesManager();
        await Future.wait(
          prefsData.entries.map(
            (entry) =>
                prefsManager.saveString(entry.key, entry.value.toString()),
          ),
        );
        print('>>> [importDatabase] SharedPreferences restored successfully.');
      }
      emit(state.copyWith(status: HomeStatus.init, progress: 0.25));

      final firestore = FirebaseFirestore.instance;
      const defaultCollections = [
        "Food",
        "Officers",
        "Invoices",
        "DispensingItemsToOfficer",
        "DispensingItemsToCanteen",
        "Hospitality",
        "Harmony",
        "MonthEndClosingHistory",
      ];

      // 2. Delete existing collections in Firestore
      print('>>> [importDatabase] Deleting old Firestore collections...');

           await Future.wait( defaultCollections.map((collectionName) async {
           await _deleteCollection(collectionName);
            }));
      print('>>> [importDatabase] Data deleted successfully.');
      emit(state.copyWith(progress: 0.50));

      // 3. Write imported collections using dejsonify & model validation
      if (fullBackupMap.containsKey("collections")) {
        final collectionsData = Map<String, dynamic>.from(
          fullBackupMap["collections"],
        );
        print(
          '>>> [importDatabase] Preparing Firestore writes for ${collectionsData.length} collections...',
        );

        int totalCollections = defaultCollections.length;
        int currentCollectionIndex = 0;

        for (String collectionName in defaultCollections) {
          currentCollectionIndex++;
          final docsList = collectionsData[collectionName] as List<dynamic>?;
          if (docsList == null || docsList.isEmpty) continue;

          for (final rawDoc in docsList) {
            if (rawDoc is! Map) continue;
            final Map<String, dynamic> rawMap = Map<String, dynamic>.from(
              rawDoc,
            );

            // De-jsonify special types like Timestamps & DocumentReferences
            final Map<String, dynamic> dejsonifiedMap = _dejsonifyMap(rawMap);

            // Convert to model json to validate types against app models & rules
            final Map<String, dynamic> formattedDoc = _convertDocToModelJson(
              collectionName,
              dejsonifiedMap,
            );

            final String docId = (formattedDoc['id'] ?? rawMap['id'] ?? '')
                .toString();
            final docRef = docId.isNotEmpty
                ? firestore.collection(collectionName).doc(docId)
                : firestore.collection(collectionName).doc();

            formattedDoc['id'] ??= docRef.id;
            firestore.collection(collectionName).doc(formattedDoc['id']).set(formattedDoc);
          }

          final double currentProgress =
              0.50 + ((currentCollectionIndex / totalCollections) * 0.45);
          emit(state.copyWith(progress: currentProgress));
        }

        print(
          '>>> [importDatabase] All new Firestore collections restored successfully.',
        );
      }

      // 4. Refresh local cubit state
      print(
        '>>> [importDatabase] Refreshing local cubit state (capital, food, officers)...',
      );
      getCapital();
      getFood();
      await getOfficers();

      print('>>> [importDatabase] Import database finished successfully!');
      emit(
        state.copyWith(status: HomeStatus.importDatabaseSuccess, progress: 1.0),
      );
    } catch (e, stackTrace) {
      print(">>> [importDatabase] ERROR: $e\n$stackTrace");
      emit(
        state.copyWith(
          status: HomeStatus.importDatabaseFailure,
          errorMessage: 'فشل استيراد قاعدة البيانات: ${e.toString()}',
        ),
      );
    }
  }
  Future<void> _deleteCollection(String collectionPath) async {
    final firestore = FirebaseFirestore.instance;
    final collectionRef = firestore.collection(collectionPath);

    // Firestore batch limit is 500
    const batchSize = 500;

    while (true) {
      // Only fetch a limited number of documents each time
      final querySnapshot = await collectionRef.limit(batchSize).get();

      if (querySnapshot.docs.isEmpty) {
        break; // No more documents, exit loop
      }

      final batch = firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      print('before commit ====================');
       batch.commit();
      print('after commit ====================');
      // Optional: Add a short delay to avoid frequent requests
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
  @override
  Future<void> close() {
    pageController.dispose();
    updateCapitalController.dispose();
    nameController.dispose();
    militaryIDNumberController.dispose();
    phoneController.dispose();
    nameFocusNode.dispose();
    militaryIDNumberFocusNode.dispose();
    phoneFocusNode.dispose();
    return super.close();
  }

  HomeCubit() : super(HomeInitial());
}

Map<String, dynamic> _parseJsonIsolate(String content) {
  return jsonDecode(content) as Map<String, dynamic>;
}
