import '../models/expense_model.dart';

abstract class ExpEvent {}

class AddExpenseEvent extends ExpEvent {}

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

class TotalExpAmountEvent extends ExpEvent {
  List<ExpenseModel> allExpenses;
  TotalExpAmountEvent({required this.allExpenses});
}
