import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:expense_app/Database/database_helper.dart';
import 'package:expense_app/bloc/exp_event.dart';
import 'package:expense_app/bloc/exp_state.dart';
import 'package:expense_app/models/expense_model.dart';
import 'package:expense_app/screen/add_expense.dart';
import 'package:flutter/material.dart';

class ExpBloc extends Bloc<ExpEvent, ExpState> {
  DataBaseHelper db;
  var amtController = TextEditingController();
  var titleController = TextEditingController();
  var discController = TextEditingController();
  ExpBloc({required this.db}) : super(ExpInitial()) {
    on<AddExpenseEvent>(addExpenseEvent);
    on<FetchExpenseEvent>(fetchExpenseEvent);
    on<UpdateExpenseEvent>(updateExpenseEvent);
    on<DeleteExpenseEvent>(deleteExpenseEvent);
  }
  FutureOr<void> addExpenseEvent(
      AddExpenseEvent event, Emitter<ExpState> emit) async {
    emit(ExpLoadingState());
    ExpenseModel mymodel = ExpenseModel(
        modelExpId: 0,
        modelExpAmount: double.parse(amtController.text.toString()),
        modelExpBalance: 2,
        modelExpCatagoryID: selectedCategoryIndex != -1 ? selectedCategoryIndex : 0,
        modelExpDescription: discController.text.toString(),
        modelExpTimeStamp: expDate.millisecondsSinceEpoch.toString(),
        modelExpTitle: titleController.text.toString(),
        modelExpType: selectedExpType == 'Debit' ? 0 : 1);

    var check = await db.addExpense(mymodel);
    if (check) {
      emit(ExpLoadedState(data: await db.fetchExpens()));
    } else {
      emit(ExpErrorstate(errorMsg: 'Expense Not Added'));
    }
  }

  FutureOr<void> fetchExpenseEvent(
      FetchExpenseEvent event, Emitter<ExpState> emit) async {
    emit(ExpLoadingState());
    emit(ExpLoadedState(data: await db.fetchExpens()));
  }

  FutureOr<void> updateExpenseEvent(
      UpdateExpenseEvent event, Emitter<ExpState> emit) async {
    var mymodel = ExpenseModel(
        // modelUserId: 0,
        modelExpId: 0,
        modelExpAmount: int.parse(amtController.text.toString()),
        modelExpBalance: 0,
        modelExpCatagoryID:
            selectedCategoryIndex != -1 ? selectedCategoryIndex : 0,
        modelExpDescription: discController.text.toString(),
        modelExpTimeStamp: expDate.millisecondsSinceEpoch.toString(),
        modelExpTitle: titleController.text.toString(),
        modelExpType: selectedExpType == 'Debit' ? 0 : 1);
    emit(ExpLoadingState());
    var check = await db.updateExp(mymodel);
    if (check) {
      emit(ExpLoadedState(data: await db.fetchExpens()));
    } else {
      emit(ExpErrorstate(errorMsg: 'Expense Not Updated'));
    }
  }

  FutureOr<void> deleteExpenseEvent(
      DeleteExpenseEvent event, Emitter<ExpState> emit) async {
    emit(ExpLoadingState());
    var check = await db.deleteExp(event.expId);
    if (check) {
      emit(ExpLoadedState(data: await db.fetchExpens()));
    } else {
      emit(ExpErrorstate(errorMsg: 'Expense Not Deleted'));
    }
  }
}
