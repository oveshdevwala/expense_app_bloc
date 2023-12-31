import 'package:expense_app/models/expense_model.dart';

class DateWiseExpenseModel {
  String data;
  String totalAmount;
  List<ExpenseModel> allTransactions;
  DateWiseExpenseModel({
    required this.data,
    required this.totalAmount,
    required this.allTransactions,
  });
}
class MonthWiseExpenseModel {
  String data;
  String totalAmount;
  List<ExpenseModel> allTransactions;
  MonthWiseExpenseModel({
    required this.data,
    required this.totalAmount,
    required this.allTransactions,
  });
}
class YearWiseExpenseModel {
  String data;
  String totalAmount;
  List<ExpenseModel> allTransactions;
  YearWiseExpenseModel({
    required this.data,
    required this.totalAmount,
    required this.allTransactions,
  });
}
class CategoryWiseExpenseModel {
  String category;
  String totalAmount;
  List<ExpenseModel> allTransactions;
  CategoryWiseExpenseModel({
    required this.category,
    required this.totalAmount,
    required this.allTransactions,
  });
}
