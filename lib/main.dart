import 'package:expense_app/Database/database_helper.dart';
import 'package:expense_app/bloc/exp_bloc.dart';
import 'package:expense_app/screen/expense_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(BlocProvider<ExpBloc>(
    create: (context) => ExpBloc(db: DataBaseHelper.instance),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExpenseHome(),
    );
  }
}
