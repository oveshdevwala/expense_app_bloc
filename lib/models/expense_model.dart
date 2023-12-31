// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:expense_app/Database/database_helper.dart';

class ExpenseModel {
// Variables
  int modelExpId;
  // int modelUserId;
  num modelExpAmount;
  num modelExpBalance;
  int modelExpType;
  int modelExpCatagoryID;
  String modelExpTitle;
  String modelExpDescription;
  String modelExpTimeStamp;
//Constructor
  ExpenseModel({
    required this.modelExpId,
    // required this.modelUserId,
    required this.modelExpAmount,
    required this.modelExpBalance,
    required this.modelExpCatagoryID,
    required this.modelExpDescription,
    required this.modelExpTimeStamp,
    required this.modelExpTitle,
    required this.modelExpType,
  });

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
        modelExpId: map[DataBaseHelper.colExpenseId],
        // modelUserId: map[DataBaseHelper.colUserId],
        modelExpTitle: map[DataBaseHelper.colExpenseTitle],
        modelExpDescription: map[DataBaseHelper.colExpenseDiscription],
        modelExpType: map[DataBaseHelper.colExpenseType],
        modelExpAmount: map[DataBaseHelper.colExpenseAmount],
        modelExpBalance: map[DataBaseHelper.colExpenseBalance],
        modelExpTimeStamp: map[DataBaseHelper.colExpTimeStamp],
        modelExpCatagoryID: map[DataBaseHelper.colExpCatagoryId]);
  }

  Map<String, dynamic> toMap() {
    return {
      DataBaseHelper.colExpenseTitle: modelExpTitle,
      DataBaseHelper.colExpenseDiscription: modelExpDescription,
      DataBaseHelper.colExpenseType: modelExpType,
      DataBaseHelper.colExpenseAmount: modelExpAmount,
      DataBaseHelper.colExpenseBalance: modelExpBalance,
      DataBaseHelper.colExpTimeStamp: modelExpTimeStamp,
      DataBaseHelper.colExpCatagoryId: modelExpCatagoryID,
    };
  }
}

