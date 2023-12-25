import 'package:expense_app/app_constant/colors_const.dart';
import 'package:expense_app/app_constant/dummy_const.dart';
import 'package:expense_app/bloc/exp_bloc.dart';
import 'package:expense_app/bloc/exp_event.dart';
import 'package:expense_app/bloc/exp_state.dart';
import 'package:expense_app/screen/add_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseHome extends StatelessWidget {
  const ExpenseHome({super.key});
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    context.read<ExpBloc>().add(FetchExpenseEvent());
    return Scaffold(
        backgroundColor: UiColors.tealBg.withOpacity(0.6),
        appBar: AppBar(
          leadingWidth: 0,
          leading: const Text(''),
          backgroundColor: UiColors.tealBg.withOpacity(0.2),
          title: const Text("Expense App"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) {
                return const AddExpenseScreen();
              },
            ));
          },
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<ExpBloc, ExpState>(
          builder: (context, state) {
            if (state is ExpLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ExpErrorstate) {
              return Center(child: Text(state.errorMsg));
            }
            if (state is ExpLoadedState) {
              context
                  .read<ExpBloc>()
                  .add(TotalExpAmountEvent(allExpenses: state.data));
              return mq.orientation == Orientation.landscape
                  ? landscapLay(context, state)
                  : portraitLay(context, state);
            }
            return const SizedBox();
          },
        ));
  }

  Padding landscapLay(BuildContext context, ExpLoadedState state) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(flex: 1, child: totalBalance()),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: expenseListView(context),
            ),
          )
        ],
      ),
    );
  }

  SingleChildScrollView portraitLay(
      BuildContext context, ExpLoadedState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          totalBalance(),
          const SizedBox(height: 10),
          expenseListView(context),
          const SizedBox(height: 70)
        ],
      ),
    );
  }

  ListView expenseListView(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: context.read<ExpBloc>().dateWiseExpenses.length,
      itemBuilder: (_, index) {
        var myData = context.read<ExpBloc>().dateWiseExpenses[index];
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
            ListView.builder(
                itemCount: myData.allTransactions.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, mindex) {
                  var myExpData = myData.allTransactions;
                  return InkWell(
                    onLongPress: () {
                      context.read<ExpBloc>().add(DeleteExpenseEvent(
                          expId: myExpData[mindex].modelExpId));
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
                            ExpCategorys
                                .mCategory[myExpData[mindex].modelExpCatagoryID]
                                .catImgPath,
                            height: 39,
                          ),
                        ),
                        title: Text(
                          myExpData[mindex].modelExpTitle,
                          style: const TextStyle(
                              color: UiColors.black,
                              fontWeight: FontWeight.w900),
                        ),
                        subtitle: Text(
                          myExpData[mindex].modelExpDescription.toString(),
                          style: const TextStyle(
                              color: UiColors.textBlack54,
                              fontWeight: FontWeight.w600),
                        ),
                        trailing: Text(
                          myExpData[mindex].modelExpAmount.toString(),
                          style: const TextStyle(
                              color: UiColors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  );
                })
          ],
        );
      },
    );
  }

  Container totalBalance() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: UiColors.tealBg.withOpacity(0.1),
          border: Border.all(color: UiColors.white, width: 2),
          borderRadius: BorderRadius.circular(12)),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Total Balance',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text(
            "00.0",
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
