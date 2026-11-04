import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mess_app/core/models/invoice_item_model.dart';
import 'package:mess_app/core/models/invoice_model.dart';
import 'package:mess_app/core/models/month_end_closing_history_model.dart';
import 'package:mess_app/core/models/month_end_closing_hospitality_model.dart';
import 'package:mess_app/core/models/month_end_closing_officer_model.dart';
import 'package:mess_app/core/models/officer_model.dart';
import 'package:mess_app/core/models/price_model.dart';
import 'package:mess_app/core/shared_preferences/shared_preferences_manager.dart';
import 'package:mess_app/features/dispensing_items/data/models/dispensing_items_model.dart';
import 'package:mess_app/features/financials/data/data_source/financials_ds_impl.dart';
import 'package:mess_app/features/financials/data/models/month_end_closing_model.dart';
import '../../../../core/firebase/firebase_firestore_manager.dart';
import '../../../../core/utils/app_enums.dart';
import '../../data/repositories/financials_repo_impl.dart';
import '../../domain/repositories/financials_repo.dart';
part 'financials_state.dart';

class FinancialsCubit extends Cubit<FinancialsState> {
  TextEditingController amountController = TextEditingController();
  void changeSelectedOfficer(OfficerModel? officer) {
    emit(
      state.copyWith(
        selectedOfficer: officer,
        status: FinancialsStatus.initial,
      ),
    );
  }

  void changeAddMoneyMode(AddMoneyMode mode) {
    emit(
      state.copyWith(
        addMoneyMode: mode,
        status: FinancialsStatus.initial,
      ),
    );
  }

  Future<void> getOfficers() async {
    emit(state.copyWith(status: FinancialsStatus.getOfficersLoading));
    FinancialsRepo financialsRepo = FinancialsRepoImpl(
      FinancialsDsImpl(FirebaseFirestoreManager(), SharedPreferencesManager()),
    );
    var result = await financialsRepo.getOfficers();
    result.fold(
      (l) {
        emit(
          state.copyWith(
            status: FinancialsStatus.getOfficersFailure,
            errorMessage: l.error,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            status: FinancialsStatus.getOfficersSuccess,
            officers: r,
          ),
        );
      },
    );
  }

  void addMoney() async {
    emit(state.copyWith(status: FinancialsStatus.addMoneyLoading));
    FinancialsRepo financialsRepo = FinancialsRepoImpl(
      FinancialsDsImpl(FirebaseFirestoreManager(), SharedPreferencesManager()),
    );
    switch (state.addMoneyMode ?? AddMoneyMode.init) {
      case AddMoneyMode.addToCanteen:
        var canteenTotalResult = financialsRepo.getCanteenTotal();
        canteenTotalResult.fold(
          (l) {
            emit(
              state.copyWith(
                status: FinancialsStatus.addMoneyFailure,
                errorMessage: l.message,
              ),
            );
            return;
          },
          (r) async {
            num total = r - (num.tryParse(amountController.text) ?? 0);
            var setCanteenResult = await financialsRepo.setCanteenTotal(total);
            setCanteenResult.fold(
              (l) {
                emit(
                  state.copyWith(
                    status: FinancialsStatus.addMoneyFailure,
                    errorMessage: l.message,
                  ),
                );
                return;
              },
              (_) {
                emit(
                  state.copyWith(
                    status: FinancialsStatus.addMoneySuccess,
                    addMoneyMode: AddMoneyMode.init,
                  ),
                );
                return;
              },
            );
          },
        );
      case AddMoneyMode.init:
        return;
      case AddMoneyMode.addToOfficer:
        var result = await financialsRepo.addMoney(
          amount: amountController.text,
          officer: state.selectedOfficer,
        );
        result.fold(
          (l) {
            emit(
              state.copyWith(
                status: FinancialsStatus.addMoneyFailure,
                errorMessage: l.error,
              ),
            );
            return;
          },
          (r) {
            var getOldOfficersTotal = financialsRepo.getOfficersBalance();
            getOldOfficersTotal.fold(
              (l) {
                emit(
                  state.copyWith(
                    status: FinancialsStatus.addMoneyFailure,
                    errorMessage: l.message,
                  ),
                );
                return;
              },
              (r) async {
                num total =
                    (r ?? 0) - (num.tryParse(amountController.text) ?? 0);
                var setOfficersBalanceResult = await financialsRepo.setOfficersBalance(
                  total,
                );
                setOfficersBalanceResult.fold(
                  (l) {
                    emit(
                      state.copyWith(
                        status: FinancialsStatus.addMoneyFailure,
                        errorMessage: l.message,
                      ),
                    );
                    return;
                  },
                  (_) {
                    emit(
                      state.copyWith(
                        status: FinancialsStatus.addMoneySuccess,
                        addMoneyMode: AddMoneyMode.init,
                      ),
                    );
                    return;
                  },
                );
              },
            );
          },
        );
      case AddMoneyMode.addToHospitality:
        var hospitalityTotalResult = financialsRepo.getHospitalityTotal();
        hospitalityTotalResult.fold(
          (l) {
            emit(
              state.copyWith(
                status: FinancialsStatus.addMoneyFailure,
                errorMessage: l.message,
              ),
            );
            return;
          },
          (r) async {
            num total = r - (num.tryParse(amountController.text) ?? 0);
            var setHospitalityResult = await financialsRepo.setHospitalityTotal(
              total,
            );
            setHospitalityResult.fold(
              (l) {
                emit(
                  state.copyWith(
                    status: FinancialsStatus.addMoneyFailure,
                    errorMessage: l.message,
                  ),
                );
                return;
              },
              (_) {
                emit(
                  state.copyWith(
                    status: FinancialsStatus.addMoneySuccess,
                    addMoneyMode: AddMoneyMode.init,
                  ),
                );
                return;
              },
            );
          },
        );
    }
  }
void getTotalAmountAndConsumer() async {
  emit(state.copyWith(status: FinancialsStatus.getTotalAmountAndConsumerLoading));
  if(state.officers==null||state.officers!.isEmpty){
    getOfficers();
  }
  num totalAmount = 0,totalConsumer = 0;
  for(OfficerModel officer in state.officers!){
    totalAmount+=officer.amount;
    totalConsumer+=officer.consumer;
  }
  emit(state.copyWith(
    status: FinancialsStatus.getTotalAmountAndConsumerSuccess,
    totalOfficersAmount: totalAmount,
    totalConsumerAmount: totalConsumer,
  ));
}
  Future<void> getCapital() async {
    FinancialsRepo repo = FinancialsRepoImpl(
      FinancialsDsImpl(FirebaseFirestoreManager(), SharedPreferencesManager()),
    );
    var result = repo.getCapital();
    result.fold(
      (l) {
        emit(
          state.copyWith(
            status: FinancialsStatus.getCapitalFailure,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            status: FinancialsStatus.getCapitalSuccess,
            capital: r,
          ),
        );
      },
    );
  }

  void getCanteenBalance() async {
    FinancialsRepo repo = FinancialsRepoImpl(
      FinancialsDsImpl(FirebaseFirestoreManager(), SharedPreferencesManager()),
    );
    var result = repo.getCanteenTotal();
    result.fold(
      (l) {
        emit(
          state.copyWith(
            status: FinancialsStatus.getCanteenBalanceFailure,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            status: FinancialsStatus.getCanteenSuccess,
            canteenBalance: r,
          ),
        );
      },
    );
  }

  void getInvoicesBalance() {
    FinancialsRepo repo = FinancialsRepoImpl(
      FinancialsDsImpl(FirebaseFirestoreManager(), SharedPreferencesManager()),
    );
    var result = repo.getInvoicesBalance();
    result.fold(
      (l) {
        emit(
          state.copyWith(
            status: FinancialsStatus.getInvoicesBalanceFailure,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            status: FinancialsStatus.getInvoicesBalanceSuccess,
            invoicesBalance: r,
          ),
        );
      },
    );
  }

  void getHospitalityBalance() {
    FinancialsRepo repo = FinancialsRepoImpl(
      FinancialsDsImpl(FirebaseFirestoreManager(), SharedPreferencesManager()),
    );
    var result = repo.getHospitalityTotal();
    result.fold(
      (l) {
        emit(
          state.copyWith(
            status: FinancialsStatus.getHospitalityBalanceFailure,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            status: FinancialsStatus.getHospitalityBalanceSuccess,
            hospitalityBalance: r,
          ),
        );
      },
    );
  }

  void getOfficersBalance() {
    FinancialsRepo repo = FinancialsRepoImpl(
      FinancialsDsImpl(FirebaseFirestoreManager(), SharedPreferencesManager()),
    );
    var result = repo.getOfficersBalance();
    result.fold(
      (l) {
        emit(
          state.copyWith(
            status: FinancialsStatus.getOfficersBalanceFailure,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            status: FinancialsStatus.getOfficersBalanceSuccess,
            officersBalance: r,
          ),
        );
      },
    );
  }

  Future<void> _getInvoices() async {
    FinancialsRepo financialsRepo = FinancialsRepoImpl(
      FinancialsDsImpl(FirebaseFirestoreManager(), SharedPreferencesManager()),
    );
    var result = await financialsRepo.getInvoices();
    result.fold(
      (l) {
        emit(
          state.copyWith(
            status: FinancialsStatus.getInvoicesFailure,
            errorMessage: l.error,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            status: FinancialsStatus.getInvoicesSuccess,
            invoices: r,
          ),
        );
      },
    );
  }

  Future<void> _getPerishes() async {
    FinancialsRepo financialsRepo = FinancialsRepoImpl(
      FinancialsDsImpl(FirebaseFirestoreManager(), SharedPreferencesManager()),
    );
    var result = await financialsRepo.getPerishes();
    result.fold(
      (l) {
        emit(
          state.copyWith(
            status: FinancialsStatus.getPerishesFailure,
            errorMessage: l.error,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            status: FinancialsStatus.getPerishesSuccess,
            perishes: r,
          ),
        );
      },
    );
  }

  void createMonthEndClosing() async {
    emit(state.copyWith(status: FinancialsStatus.createMonthEndClosingLoading));
    await getCapital();
    await getOfficers();
    getHospitalityBalance();
    getCanteenBalance();
    await _getInvoices();
    await _getPerishes();
    await _getCanteen();
    await _getHospitality();
    emit(state.copyWith(status: FinancialsStatus.createMonthEndClosingLoading));
    List<InvoiceModel> invoices = state.invoices ?? [];
    List<DispensingItemsModel> perishesList = state.perishes ?? [];
    double fixed = 0,
        perishes = 0,
        variable = 0,
        consumer = 0,
        hospitality = 0,
        canteen = 0;
    for (InvoiceModel invoice in invoices) {
      for (InvoiceItemModel item in invoice.items) {
        if (item.food?.isVariableMiscellaneousExpenses ?? false) {
          variable += item.price;
        } else if (item.food?.isFixedMiscellaneousExpenses ?? false) {
          fixed += item.price;
        }
      }
    }
    for (DispensingItemsModel perish in perishesList) {
      perishes += perish.totalPrice;
    }
    for (OfficerModel officer in state.officers ?? []) {
      consumer += officer.consumer;
    }
    for (DispensingItemsModel item in state.hospitality ?? []) {
      hospitality += item.totalPrice;
    }
    for (DispensingItemsModel item in state.canteen ?? []) {
      canteen += item.totalPrice;
    }

    double consumerAndHospitality = consumer + hospitality;
    variable = consumerAndHospitality > 0 ? (variable / consumerAndHospitality) : 0.0;

    int officersCount = 0;
    for (OfficerModel officer in state.officers ?? []) {
      if(officer.isActive) {
        officersCount++;
      }
    }
    perishes = officersCount > 0 ? (perishes / officersCount) : 0.0;
    fixed = officersCount > 0 ? (fixed / officersCount) : 0.0;

    MonthEndClosingModel monthEndClosing = MonthEndClosingModel(
      officers: state.officers ?? [],
      hospitality: hospitality+(state.hospitalityBalance??0),
      canteen: canteen+(state.canteenBalance??0),
      fixed: fixed,
      perishes: perishes,
      variable: variable,
      date: Timestamp.fromDate(DateTime.now()),
    );
    emit(
      state.copyWith(
        status: FinancialsStatus.createMonthEndClosingSuccess,
        monthEndClosing: monthEndClosing,
      ),
    );
  }

  void saveMonthEndClosing() async {
    emit(state.copyWith(status: FinancialsStatus.saveMonthEndClosingLoading));
    //update officers amount
    FinancialsRepo financialsRepo = FinancialsRepoImpl(
      FinancialsDsImpl(FirebaseFirestoreManager(), SharedPreferencesManager()),
    );
    for (OfficerModel? officer in (state.monthEndClosing?.officers) ?? []) {
      officer?.consumer = 0;
      var updateOfficerResult = await financialsRepo.spendMoney(
        amount:
            ((state.monthEndClosing?.variable ?? 0) * (officer!.consumer) +
                    (state.monthEndClosing?.fixed ?? 0) +
                    (state.monthEndClosing?.perishes ?? 0))
                .toString(),
        officer: officer,
      );
      updateOfficerResult.fold((l) {
        emit(
          state.copyWith(
            errorMessage: l.error,
            status: FinancialsStatus.saveMonthEndClosingFailure,
          ),
        );
        return;
      }, (_) {});
    }
    //update hospitality amount
    var getHospitalityResult = financialsRepo.getHospitalityTotal();
    getHospitalityResult.fold(
      (l) {
        emit(
          state.copyWith(
            errorMessage: l.message,
            status: FinancialsStatus.saveMonthEndClosingFailure,
          ),
        );
        return;
      },
      (value) async {
        var setHospitalityResult = await financialsRepo.setHospitalityTotal(
          state.monthEndClosing?.hospitality ?? 0,
        );
        setHospitalityResult.fold((l) {
          emit(
            state.copyWith(
              errorMessage: l.message,
              status: FinancialsStatus.saveMonthEndClosingFailure,
            ),
          );
          return;
        }, (_) {});
      },
    );
    var deleteHospitalityResult = await financialsRepo.deleteHospitality();
    deleteHospitalityResult.fold((l) {
      emit(
        state.copyWith(
          errorMessage: l.error,
          status: FinancialsStatus.saveMonthEndClosingFailure,
        ),
      );
      return;
    }, (_) {});

    //update canteen amount
    var getCanteenResult = financialsRepo.getCanteenTotal();
    getCanteenResult.fold(
      (l) {
        emit(
          state.copyWith(
            errorMessage: l.message,
            status: FinancialsStatus.saveMonthEndClosingFailure,
          ),
        );
        return;
      },
      (value) async {
        var setCanteenResult = await financialsRepo.setCanteenTotal(
          state.monthEndClosing?.canteen ?? 0,
        );
        setCanteenResult.fold((l) {
          emit(
            state.copyWith(
              errorMessage: l.message,
              status: FinancialsStatus.saveMonthEndClosingFailure,
            ),
          );
          return;
        }, (_) {});
      },
    );
    var deleteCanteenResult = await financialsRepo.deleteCanteen();
    deleteCanteenResult.fold((l) {
      emit(
        state.copyWith(
          errorMessage: l.error,
          status: FinancialsStatus.saveMonthEndClosingFailure,
        ),
      );
      return;
    }, (_) {});
    // clear all invoice and create new month invoice
    for (DispensingItemsModel item in (state.perishes) ?? []) {
      var deletePerishesResult = await financialsRepo.deletePerishes(
        docId: item.id,
      );
      deletePerishesResult.fold((l) {
        emit(
          state.copyWith(
            status: FinancialsStatus.saveMonthEndClosingFailure,
            errorMessage: l.error,
          ),
        );
        return;
      }, (_) {});
    }
    var getFoodResult = await financialsRepo.getAvailableFood();
    getFoodResult.fold(
      (l) {
        emit(
          state.copyWith(
            errorMessage: l.error,
            status: FinancialsStatus.saveMonthEndClosingFailure,
          ),
        );
        return;
      },
      (food) async {
        var deleteAllInvoicesResult = await financialsRepo.deleteAllInvoices();
        deleteAllInvoicesResult.fold(
          (l) {
            emit(
              state.copyWith(
                errorMessage: l.error,
                status: FinancialsStatus.saveMonthEndClosingFailure,
              ),
            );
            return;
          },
          (_) async {
            List<InvoiceItemModel> items = food.map((e) {
              double price = 0;
              for (PriceModel priceModel in e.prices) {
                price = price + (priceModel.price * priceModel.quantity);
              }
              return InvoiceItemModel(
                food: e,
                quantity: e.quantity,
                id: '',
                price: price,
              );
            }).toList();
            double total = 0;
            for (InvoiceItemModel itemModel in items) {
              total += itemModel.price;
            }
            var setInvoicesBalanceResult = await financialsRepo
                .setInvoicesBalance(total);
            setInvoicesBalanceResult.fold((l) {
              emit(
                state.copyWith(
                  errorMessage: l.message,
                  status: FinancialsStatus.saveMonthEndClosingFailure,
                ),
              );
            }, (_) {});
            var addPostedInvoiceResult = await financialsRepo.addPostedInvoice(
              InvoiceModel(
                items: items,
                id: '',
                date: DateTime.now(),
                total: total,
                representativeName: 'فاتورة مرحله',
              ),
            );
            addPostedInvoiceResult.fold((l) {
              emit(
                state.copyWith(
                  errorMessage: l.error,
                  status: FinancialsStatus.saveMonthEndClosingFailure,
                ),
              );
              return;
            }, (r) {});
          },
        );
      },
    );
    //save month end closing
    List<MonthEndClosingOfficerModel> officers = (state.officers ?? []).map((
      e,
    ) {
      num rawTotal =
          ((state.capital ?? 0) -
          ((e.amount) -
              ((state.monthEndClosing?.variable ?? 0) * (e.consumer) +
                  (state.monthEndClosing?.fixed ?? 0) +
                  (state.monthEndClosing?.perishes ?? 0))));
      var total = (rawTotal.isNaN || rawTotal.isInfinite) ? 0 : rawTotal.ceil();

      num rawVariable = ((state.monthEndClosing?.variable ?? 0) * (e.consumer));
      num variable = (rawVariable.isNaN || rawVariable.isInfinite)
          ? 0
          : rawVariable.ceil();

      return MonthEndClosingOfficerModel(
        name: "${e.rank} ${e.name}",
        total: total,
        fixed: state.monthEndClosing?.fixed ?? 0,
        variable: variable,
        consumer: e.consumer,
        perish: state.monthEndClosing?.perishes ?? 0,
      );
    }).toList();
    num officersTotal = 0;
    for (MonthEndClosingOfficerModel officer in officers) {
      officersTotal += officer.total;
    }
    var setOfficersBalanceResult = await financialsRepo.setOfficersBalance(
      officersTotal,
    );
    setOfficersBalanceResult.fold((l) {
      emit(
        state.copyWith(
          errorMessage: l.message,
          status: FinancialsStatus.saveMonthEndClosingFailure,
        ),
      );
    }, (_) {});
    num rawHospitalityTotal =
        ((state.monthEndClosing?.hospitality ?? 0) *
        (1 + (state.monthEndClosing?.variable ?? 0)));
    num hospitalityTotal =
        (rawHospitalityTotal.isNaN || rawHospitalityTotal.isInfinite)
        ? 0
        : rawHospitalityTotal.ceil();

    var saveMonthEndClosingResult = await financialsRepo.saveMonthEndClosing(
      MonthEndClosingHistoryModel(
        officers: officers,
        date: Timestamp.fromDate(DateTime.now()),
        canteenBalance: state.monthEndClosing?.canteen ?? 0,
        monthEndClosingHospitalityModel: MonthEndClosingHospitalityModel(
          variable: state.monthEndClosing?.fixed ?? 0,
          consumer: state.monthEndClosing?.hospitality ?? 0,
          total: hospitalityTotal,
        ),
      ),
    );
    saveMonthEndClosingResult.fold((l) {
      emit(state.copyWith(status: FinancialsStatus.saveMonthEndClosingFailure));
      return;
    }, (r) {});
    emit(state.copyWith(status: FinancialsStatus.saveMonthEndClosingSuccess));
  }

  @override
  Future<void> close() {
    amountController.dispose();
    return super.close();
  }

  FinancialsCubit() : super(FinancialsInitial());

  Future<void> _getCanteen() async {
    emit(state.copyWith(status: FinancialsStatus.getCanteenLoading));
    FinancialsRepo financialsRepo = FinancialsRepoImpl(
      FinancialsDsImpl(FirebaseFirestoreManager(), SharedPreferencesManager()),
    );
    var result = await financialsRepo.getCanteen();
    result.fold(
      (l) {
        emit(
          state.copyWith(
            status: FinancialsStatus.getCanteenFailure,
            errorMessage: l.error,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            status: FinancialsStatus.getCanteenSuccess,
            canteen: r,
          ),
        );
      },
    );
  }

  Future<void> _getHospitality() async {
    emit(state.copyWith(status: FinancialsStatus.getHospitalityLoading));
    FinancialsRepo financialsRepo = FinancialsRepoImpl(
      FinancialsDsImpl(FirebaseFirestoreManager(), SharedPreferencesManager()),
    );
    var result = await financialsRepo.getHospitality();
    result.fold(
      (l) {
        emit(
          state.copyWith(
            status: FinancialsStatus.getHospitalityFailure,
            errorMessage: l.error,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            status: FinancialsStatus.getHospitalitySuccess,
            hospitality: r,
          ),
        );
      },
    );
  }
}
