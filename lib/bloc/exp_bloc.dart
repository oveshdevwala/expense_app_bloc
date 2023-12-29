import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:expense_app/Database/database_helper.dart';
import 'package:expense_app/app_constant/datetime_utile.dart';
import 'package:expense_app/bloc/exp_event.dart';
import 'package:expense_app/bloc/exp_state.dart';
import 'package:expense_app/models/expense_model.dart';
import 'package:expense_app/screen/add_expense.dart';
import 'package:flutter/material.dart';

class ExpBloc extends Bloc<ExpEvent, ExpState> {
  List<DateWiseExpenseModel> dateWiseExpenses = [];
  DataBaseHelper db;
  var amtController = TextEditingController();
  var titleController = TextEditingController();
  var discController = TextEditingController();
  ExpBloc({required this.db}) : super(ExpInitial()) {
    on<AddExpenseEvent>(addExpenseEvent);
    on<FetchExpenseEvent>(fetchExpenseEvent);
    on<UpdateExpenseEvent>(updateExpenseEvent);
    on<DeleteExpenseEvent>(deleteExpenseEvent);
    on<TotalExpAmountEvent>(totalExpAmountEvent);
  }
  FutureOr<void> addExpenseEvent(
      AddExpenseEvent event, Emitter<ExpState> emit) async {
    if (amtController.text.isNotEmpty &&
        titleController.text.isNotEmpty &&
        discController.text.isNotEmpty) {
      emit(ExpLoadingState());
      var mBalance = event.tBalance;
      if (selectedExpType == 'Debit') {
        mBalance -= int.parse(amtController.text.toString());
      } else {
        mBalance += int.parse(amtController.text.toString());
      }

      ExpenseModel mymodel = ExpenseModel(
          modelExpId: 0,
          modelExpAmount: double.parse(amtController.text.toString()),
          modelExpBalance: mBalance,
          modelExpCatagoryID:
              selectedCategoryIndex != -1 ? selectedCategoryIndex : 0,
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

  FutureOr<void> totalExpAmountEvent(
      TotalExpAmountEvent event, Emitter<ExpState> emit) {
    dateWiseExpenses.clear();
    var listUniqueDates = [];

    for (ExpenseModel eachExp in event.allExpenses) {
      var mDate =
          DateTimeUtils.getFormatedMilliS(int.parse(eachExp.modelExpTimeStamp));
      if (!listUniqueDates.contains(mDate)) {
        listUniqueDates.add(mDate);
      }
    }
    for (String date in listUniqueDates) {
      List<ExpenseModel> eachDateExp = [];
      var totalAmt = 0.0;

      for (ExpenseModel eachExp in event.allExpenses) {
        var mDate = DateTimeUtils.getFormatedMilliS(
            int.parse(eachExp.modelExpTimeStamp));
        if (date == mDate) {
          eachDateExp.add(eachExp);
          if (eachExp.modelExpType == 0) {
            totalAmt -= eachExp.modelExpAmount;
          } else {
            totalAmt += eachExp.modelExpAmount;
          }
        }
      }
      var today = DateTime.now();
      var yesterday = DateTime.now().subtract(const Duration(days: 1));
      if (date == DateTimeUtils.getFormateDateTime(today)) {
        date = 'Today';
      }
      if (date == DateTimeUtils.getFormateDateTime(yesterday)) {
        date = 'Yesterday';
      }

       
      dateWiseExpenses.add(
        
        DateWiseExpenseModel(
          data: date,
          totalAmount: totalAmt.toString(),
          allTransactions: eachDateExp));
    }
    emit(ExpLoadedState(data: event.allExpenses));



  }
}
