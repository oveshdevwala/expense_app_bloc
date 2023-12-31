import 'package:expense_app/app_constant/colors_const.dart';
import 'package:expense_app/app_constant/dummy_const.dart';
import 'package:expense_app/bloc/exp_bloc.dart';
import 'package:expense_app/bloc/exp_event.dart';
import 'package:expense_app/bloc/exp_state.dart';
import 'package:expense_app/models/expense_model.dart';
import 'package:expense_app/models/filter_models.dart';
import 'package:expense_app/screen/add_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseHome extends StatefulWidget {
  const ExpenseHome({super.key});

  @override
  State<ExpenseHome> createState() => _ExpenseHomeState();
}

class _ExpenseHomeState extends State<ExpenseHome> {
  num tBalance = 00.0;

  var selectFilter = ['Day', 'Month', 'Year'];

  var selectedFilter = 'Day';
  // @override
  // void initState() {
  //   super.initState();
  //   getSelectedFillter();
  // }

  // Future<String> getSelectedFillter() async {
  //   var prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('selectedFilter')!;
  // }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    context.read<ExpBloc>().add(FetchExpenseEvent());
    return Scaffold(
        backgroundColor: UiColors.tealBg.withOpacity(0.6),
        appBar: expnseViewAppBar(),
        floatingActionButton: addExpenseBt(context),
        body: BlocBuilder<ExpBloc, ExpState>(
          builder: (context, state) {
            if (state is ExpLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ExpErrorstate) {
              return Center(child: Text(state.errorMsg));
            }
            if (state is ExpLoadedState) {
              if (state.data.isNotEmpty) {
                // Make totla according to last expense
                var lastExpId = -1;
                for (ExpenseModel exp in state.data) {
                  if (exp.modelExpId > lastExpId) {
                    lastExpId = exp.modelExpId;
                  }
                }
                var lastExpense = state.data
                    .firstWhere((element) => element.modelExpId == lastExpId);
                tBalance = lastExpense.modelExpBalance;
                var blocpath = context.read<ExpBloc>();
              //Show Data According to Selcted Filter
                selectedFilterShow() {
                  if (selectedFilter == 'Day') {
                    return blocpath.add(
                        FilterDayWiseExpenseEvent(allExpenses: state.data));
                  } else if (selectedFilter == 'Month') {
                    return blocpath.add(
                        FilterMonthWiseExpenseEvent(allExpenses: state.data));
                  } else if (selectedFilter == 'Year') {
                    return blocpath.add(
                        FilterYearWiseExpenseEvent(allExpenses: state.data));
                  }
                }

                selectedFilterShow();
                return mq.orientation == Orientation.landscape
                    ? landscapLay(context, state, lastExpense.modelExpType)
                    : portraitLay(context, state, lastExpense.modelExpType);
              } else {
                return const Center(child: Text('No Expense Found'));
              }
            }
            return const SizedBox();
          },
        ));
  }

  selectedFilterShow<Widget>(BuildContext context, var lastExpense) {
    if (selectedFilter == 'Day') {
      return dayWiseExpenseListView(context, lastExpense);
    } else if (selectedFilter == 'Month') {
      return monthWiseExpenseListView(context, lastExpense);
    } else {
      return yearWiseExpenseListView(context, lastExpense);
    }
  }

  Padding landscapLay(
      BuildContext context, ExpLoadedState state, var lastExpense) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child:
                  totalBalance(fontSize: 20, state: state, context: context)),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: selectedFilterShow(context, lastExpense),
            ),
          )
        ],
      ),
    );
  }

  SingleChildScrollView portraitLay(
      BuildContext context, ExpLoadedState state, var lastExpense) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          totalBalance(state: state, context: context),
          const SizedBox(height: 10),
          selectedFilterShow(context, lastExpense),
          const SizedBox(height: 70)
        ],
      ),
    );
  }

  ListView yearWiseExpenseListView(BuildContext context, var lastExpense) {
    var blocpath = context.read<ExpBloc>();
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: blocpath.yearWiseExpense.length,
      itemBuilder: (_, index) {
        var myData = blocpath.yearWiseExpense[index];

        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  color: UiColors.tealBg.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(myData.data,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  Text(myData.totalAmount,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            allTransacrionsListView(myData, context, lastExpense)
          ],
        );
      },
    );
  }

  ListView dayWiseExpenseListView(BuildContext context, var lastExpense) {
    var blocpath = context.read<ExpBloc>();
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: blocpath.dateWiseExpenses.length,
      itemBuilder: (_, index) {
        var myData = blocpath.dateWiseExpenses[index];

        return Column(
          children: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    color: UiColors.tealBg.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(12),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(myData.data,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      Text(myData.totalAmount,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600))
                    ])),
            allTransacrionsListView(myData, context, lastExpense)
          ],
        );
      },
    );
  }

  ListView monthWiseExpenseListView(BuildContext context, var lastExpense) {
    var blocpath = context.read<ExpBloc>();
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: blocpath.monthWiseExpense.length,
      itemBuilder: (_, index) {
        var myData = blocpath.monthWiseExpense[index];

        return Column(
          children: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    color: UiColors.tealBg.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(12),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(myData.data,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      Text(myData.totalAmount,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600))
                    ])),
            allTransacrionsListView(myData, context, lastExpense)
          ],
        );
      },
    );
  }

  ListView allTransacrionsListView(
      dynamic myData, BuildContext context, lastExpense) {
    return ListView.builder(
        itemCount: myData.allTransactions.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, mindex) {
          var myExpData = myData.allTransactions;
          return InkWell(
            onLongPress: () {
              context
                  .read<ExpBloc>()
                  .add(DeleteExpenseEvent(expId: myExpData[mindex].modelExpId));
              if (lastExpense == 0) {
                tBalance += myExpData[mindex].modelExpAmount;
              } else {
                tBalance -= myExpData[mindex].modelExpAmount;
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: UiColors.white),
                  color: UiColors.tealBg.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: UiColors.appbarbg.withOpacity(0.7),
                  child: Image.asset(
                    ExpCategorys.mCategory[myExpData[mindex].modelExpCatagoryID]
                        .catImgPath,
                    height: 39,
                  ),
                ),
                title: Text(
                  myExpData[mindex].modelExpTitle,
                  style: const TextStyle(
                      color: UiColors.black, fontWeight: FontWeight.w900),
                ),
                subtitle: Text(
                  myExpData[mindex].modelExpDescription.toString(),
                  style: const TextStyle(
                      color: UiColors.textBlack54, fontWeight: FontWeight.w600),
                ),
                trailing: Column(
                  children: [
                    Text(
                      myExpData[mindex].modelExpAmount.toString(),
                      style: const TextStyle(
                          color: UiColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      myExpData[mindex].modelExpBalance.toString(),
                      style: const TextStyle(
                          color: UiColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Container totalBalance(
      {double fontSize = 30,
      required ExpLoadedState state,
      required BuildContext context}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: UiColors.tealBg.withOpacity(0.1),
          border: Border.all(color: UiColors.white, width: 2),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Total Balance',
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
          Text(
            tBalance.toString(),
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  AppBar expnseViewAppBar() {
    return AppBar(
      leadingWidth: 0,
      leading: const Text(''),
      actions: [
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: UiColors.tealBg, borderRadius: BorderRadius.circular(10)),
          child: DropdownButton(
              items: selectFilter
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              value: selectedFilter,
              onChanged: (value) async {
                // var prefs = await SharedPreferences.getInstance();
                // prefs.setString('selectedFilter', value!);
                selectedFilter = value!;
                setState(() {});
              }),
        ),
        const SizedBox(width: 10)
      ],
      backgroundColor: UiColors.tealBg.withOpacity(0.2),
      title: const Text("Expense App"),
    );
  }

  FloatingActionButton addExpenseBt(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) {
            return AddExpenseScreen(
              tBalance: tBalance,
            );
          },
        ));
      },
      child: const Icon(Icons.add),
    );
  }
}
