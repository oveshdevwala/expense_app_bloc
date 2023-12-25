import 'package:expense_app/models/expense_model.dart';

abstract class ExpState {}

 class ExpInitial extends ExpState {}

class ExpLoadingState extends ExpState {}

class ExpLoadedState extends ExpState {
  List<ExpenseModel> data;
  ExpLoadedState({
    required this.data,
  });
}

class ExpErrorstate extends ExpState {
  String errorMsg;
  ExpErrorstate({
    required this.errorMsg,
  });
}
