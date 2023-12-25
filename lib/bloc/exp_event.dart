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

class TotalExpAmount extends ExpEvent {}
