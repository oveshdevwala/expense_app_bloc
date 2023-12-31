// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../models/expense_model.dart';

abstract class ExpEvent {}

class AddExpenseEvent extends ExpEvent {
  num tBalance;
  AddExpenseEvent({
    required this.tBalance,
  });
}

class FetchExpenseEvent extends ExpEvent {}

class UpdateExpenseEvent extends ExpEvent {
  int expId;
  UpdateExpenseEvent({
    required this.expId,
  });
}

class DeleteExpenseEvent extends ExpEvent {
  int expId;
  DeleteExpenseEvent({required this.expId});
}

// class TotalExpAmountEvent extends ExpEvent {
//   List<ExpenseModel> allExpenses;
//   TotalExpAmountEvent({required this.allExpenses});
// }

// class TotalBalanceAmountEvent extends ExpEvent {
//   num tBalance;
//   TotalBalanceAmountEvent({
//     required this.tBalance,
//   });
// }

class FilterDayWiseExpenseEvent extends ExpEvent {
  List<ExpenseModel> allExpenses;
  FilterDayWiseExpenseEvent({
    required this.allExpenses,
  });
  
}

class FilterMonthWiseExpenseEvent extends ExpEvent {
  List<ExpenseModel> allExpenses;
  FilterMonthWiseExpenseEvent({
    required this.allExpenses,
  });
}

class FilterYearWiseExpenseEvent extends ExpEvent {
  List<ExpenseModel> allExpenses;
  FilterYearWiseExpenseEvent({
    required this.allExpenses,
  });
}

class FilterCategoryWiseExpenseEvent extends ExpEvent {
  List<ExpenseModel> allExpenses;
  FilterCategoryWiseExpenseEvent({
    required this.allExpenses,
  });
}
