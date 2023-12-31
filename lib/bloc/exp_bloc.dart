import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:expense_app/Database/database_helper.dart';
import 'package:expense_app/app_constant/datetime_utile.dart';
import 'package:expense_app/app_constant/dummy_const.dart';
import 'package:expense_app/bloc/exp_event.dart';
import 'package:expense_app/bloc/exp_state.dart';
import 'package:expense_app/models/category_model.dart';
import 'package:expense_app/models/expense_model.dart';
import 'package:expense_app/models/filter_models.dart';
import 'package:expense_app/screen/add_expense.dart';
import 'package:flutter/material.dart';

class ExpBloc extends Bloc<ExpEvent, ExpState> {
  List<DateWiseExpenseModel> dateWiseExpenses = [];
  List<MonthWiseExpenseModel> monthWiseExpense = [];
  List<YearWiseExpenseModel> yearWiseExpense = [];
  List<CategoryWiseExpenseModel> categoryWiseExpense = [];
  DataBaseHelper db;
  var amtController = TextEditingController();
  var titleController = TextEditingController();
  var discController = TextEditingController();
  ExpBloc({required this.db}) : super(ExpInitial()) {
    on<AddExpenseEvent>(addExpenseEvent);
    on<FetchExpenseEvent>(fetchExpenseEvent);
    on<UpdateExpenseEvent>(updateExpenseEvent);
    on<DeleteExpenseEvent>(deleteExpenseEvent);
    on<FilterDayWiseExpenseEvent>(filterDayWiseExpenseEvent);
    on<FilterMonthWiseExpenseEvent>(filterMonthWiseExpenseEvent);
    on<FilterYearWiseExpenseEvent>(filterYearWiseExpenseEvent);
    on<FilterCategoryWiseExpenseEvent>(filterCategoryWiseExpenseEvent);
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

  FutureOr<void> filterDayWiseExpenseEvent(
      FilterDayWiseExpenseEvent event, Emitter<ExpState> emit) {
    dateWiseExpenses.clear();
    var listUniqueDates = [];
//Find and add unique Date
    for (ExpenseModel eachExp in event.allExpenses) {
      var mDate = DateTimeUtils.getFormatedDateMilliS(
          int.parse(eachExp.modelExpTimeStamp));
      if (!listUniqueDates.contains(mDate)) {
        listUniqueDates.add(mDate);
      }
    }
    for (String date in listUniqueDates) {
      List<ExpenseModel> eachDateExp = [];
      var totalofDayAmt = 0.0;

      for (ExpenseModel eachExp in event.allExpenses) {
        var mDate = DateTimeUtils.getFormatedDateMilliS(
            int.parse(eachExp.modelExpTimeStamp));
        if (date == mDate) {
          eachDateExp.add(eachExp);
          if (eachExp.modelExpType == 0) {
            totalofDayAmt -= eachExp.modelExpAmount;
          } else {
            totalofDayAmt += eachExp.modelExpAmount;
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

      dateWiseExpenses.add(DateWiseExpenseModel(
          data: date,
          totalAmount: totalofDayAmt.toString(),
          allTransactions: eachDateExp));
    }
    emit(ExpLoadedState(data: event.allExpenses));
  }

  FutureOr<void> filterMonthWiseExpenseEvent(
      FilterMonthWiseExpenseEvent event, Emitter<ExpState> emit) async {
    monthWiseExpense.clear();
    var listUniqueMonth = [];
    //Find and add unique Months
    for (ExpenseModel eachExp in event.allExpenses) {
      var mMonth = DateTimeUtils.getFormatedMonthFromMilli(
          int.parse(eachExp.modelExpTimeStamp));
      if (!listUniqueMonth.contains(mMonth)) {
        listUniqueMonth.add(mMonth);
      }
    }

    for (String month in listUniqueMonth) {
      List<ExpenseModel> eachMonthExpense = [];
      var totalOfMonth = 00.0;
      for (ExpenseModel eachExp in event.allExpenses) {
        var mMonth = DateTimeUtils.getFormatedMonthFromMilli(
            int.parse(eachExp.modelExpTimeStamp));

        if (month == mMonth) {
          eachMonthExpense.add(eachExp);
          if (eachExp.modelExpType == 0) {
            totalOfMonth -= eachExp.modelExpAmount;
          } else {
            totalOfMonth += eachExp.modelExpAmount;
          }
        }
      }
      var thisMonth = DateTime.now();
      var lastMonth = DateTime(DateTime.now().year, DateTime.now().month - 1);
      if (month == DateTimeUtils.getFormatedMonthFromDateTime(thisMonth)) {
        month = 'This Month';
      } else if (month ==
          DateTimeUtils.getFormatedMonthFromDateTime(lastMonth)) {
        month = 'Last Month';
      }
      monthWiseExpense.add(MonthWiseExpenseModel(
          data: month,
          totalAmount: totalOfMonth.toString(),
          allTransactions: eachMonthExpense));
    }
    emit(ExpLoadedState(data: event.allExpenses));
  }

  FutureOr<void> filterYearWiseExpenseEvent(
      FilterYearWiseExpenseEvent event, Emitter<ExpState> emit) {
    yearWiseExpense.clear();
    var listOfUniqueYear = [];
    // List Of Unique Year Check and add
    for (ExpenseModel eachexp in event.allExpenses) {
      var mYear = DateTimeUtils.getFromatedYearFromMilliSeconds(
          int.parse(eachexp.modelExpTimeStamp));
      if (!listOfUniqueYear.contains(mYear)) {
        listOfUniqueYear.add(mYear);
      }
    }
    for (String year in listOfUniqueYear) {
      List<ExpenseModel> eachYearExpense = [];
      var totalOfYear = 00.0;
      for (ExpenseModel eachexp in event.allExpenses) {
        var mYear = DateTimeUtils.getFromatedYearFromMilliSeconds(
            int.parse(eachexp.modelExpTimeStamp));
        if (year == mYear) {
          eachYearExpense.add(eachexp);
          if (eachexp.modelExpType == 0) {
            totalOfYear -= eachexp.modelExpAmount;
          } else {
            totalOfYear += eachexp.modelExpAmount;
          }
        }
      }
      var thisYear = DateTime.now();
      var lastYear = DateTime(DateTime.now().year - 1);
      if (year == DateTimeUtils.getFormatedYearFromDateTime(thisYear)) {
        year = 'This Year';
      } else if (year == DateTimeUtils.getFormatedYearFromDateTime(lastYear)) {
        year = 'Last Year';
      }

      yearWiseExpense.add(YearWiseExpenseModel(
          data: year,
          totalAmount: totalOfYear.toString(),
          allTransactions: eachYearExpense));
    }
    emit(ExpLoadedState(data: event.allExpenses));
  }

  FutureOr<void> filterCategoryWiseExpenseEvent(
      FilterCategoryWiseExpenseEvent event, Emitter<ExpState> emit) {
    categoryWiseExpense.clear();
    for (CategoryModel eachCate in ExpCategorys.mCategory) {
      var totalOfCategory = 00.0;
      var cateName = eachCate.catTitle;
      List<ExpenseModel> cateTransactions = [];
      for (ExpenseModel eachExp in event.allExpenses) {
        if (eachExp.modelExpCatagoryID == eachCate.catId) {
          cateTransactions.add(eachExp);

          if (eachExp.modelExpType == 0) {
            //Debit
            totalOfCategory -= eachExp.modelExpAmount;
          } else {
            //credit
            totalOfCategory += eachExp.modelExpAmount;
          }
        }
      }
      if (cateTransactions.isNotEmpty) {
        categoryWiseExpense.add(CategoryWiseExpenseModel(
            category: cateName,
            totalAmount: totalOfCategory.toString(),
            allTransactions: cateTransactions));
      }
    }
  }
}
