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


class TotalExpAmountEvent extends ExpEvent {
  List<ExpenseModel> allExpenses;
  TotalExpAmountEvent({required this.allExpenses});
}

class TotalBalanceAmountEvent extends ExpEvent {
  num tBalance;
  TotalBalanceAmountEvent({
    required this.tBalance,
  });
}
