// ignore_for_file: must_be_immutable

import 'package:expense_app/app_constant/colors_const.dart';
import 'package:expense_app/app_constant/dummy_const.dart';
import 'package:expense_app/bloc/exp_bloc.dart';
import 'package:expense_app/bloc/exp_event.dart';
import 'package:expense_app/screen/expense_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../app_constant/custom_widgets.dart';

class AddExpenseScreen extends StatefulWidget {
  AddExpenseScreen({super.key, required this.tBalance});
  num tBalance;
  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

DateTime expDate = DateTime.now();
String? selectedCategory;
String? selectedCategoryImg;
int selectedCategoryIndex = -1;

var expTypes = ['Debit', 'Credit'];
var selectedExpType = 'Debit';

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiColors.appbarbg.withOpacity(0.7),
      appBar: AppBar(
        backgroundColor: UiColors.appbarbg.withOpacity(0.6),
        foregroundColor: UiColors.textBlack54,
        title: const Text(
          'Add Expense',
          style: TextStyle(color: UiColors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              CustomTextField(
                  controller: context.read<ExpBloc>().titleController,
                  hintText: 'Expense Name',
                  suffixIcon: Icons.abc),
              const SizedBox(height: 25),
              CustomTextField(
                  controller: context.read<ExpBloc>().discController,
                  hintText: 'Add Description',
                  suffixIcon: Icons.abc),
              const SizedBox(height: 25),
              CustomTextField(
                  keyboardType: TextInputType.number,
                  controller: context.read<ExpBloc>().amtController,
                  hintText: 'Enter Amount',
                  suffixIcon: CupertinoIcons.number),
              const SizedBox(height: 10),
              expTypeSelctionBt(),
              const SizedBox(height: 10),
              chooseExpenseBT(),
              const SizedBox(height: 15),
              selectDateBT(),
              const SizedBox(height: 15),
              saveBt()
            ],
          ),
        ),
      ),
    );
  }

  Align expTypeSelctionBt() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 30),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: UiColors.tealBg.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12)),
        child: DropdownButton(
          isDense: true,
          dropdownColor: UiColors.tealBg,
          hint: const ColoredBox(color: Colors.black),
          borderRadius: BorderRadius.circular(15),
          items: expTypes
              .map((type) => DropdownMenuItem(value: type, child: Text(type)))
              .toList(),
          value: selectedExpType,
          onChanged: (value) {
            selectedExpType = value!;
            setState(() {});
          },
        ),
      ),
    );
  }

  selectDateBT() {
    return MyCustomButton(
        btName: DateFormat.yMMMEd().format(expDate),
        // btName: "${expDate.year} / ${expDate.month} / ${expDate.day}",
        onTap: () async {
          DateTime? selectedTime = await showDatePicker(
              initialDate: DateTime.now(),
              context: context,
              firstDate: DateTime(DateTime.now().year - 2),
              lastDate: DateTime.now());

          if (selectedTime != null) {
            expDate = selectedTime;
            setState(() {});
          }
        },
        bgColor: UiColors.white,
        foreColor: UiColors.black);
  }

  chooseExpenseBT() {
    return MyCustomButton(
      bgColor: UiColors.black,
      foreColor: UiColors.white,
      btName: 'Choose Expense',
      myWidget: selectedCategoryIndex != -1
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(ExpCategorys.mCategory[selectedCategoryIndex].catTitle),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: UiColors.appbarbg,
                  radius: 15,
                  child: Image(
                    image: AssetImage(ExpCategorys
                        .mCategory[selectedCategoryIndex].catImgPath),
                    height: 20,
                  ),
                ),
              ],
            )
          : null,
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const Text(
                    'Selecte Expense Category',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ExpCategorys.mCategory.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, childAspectRatio: 0.8),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () {
                                Navigator.pop(context);
                                selectedCategoryIndex = index;
                                selectedCategoryImg =
                                    ExpCategorys.mCategory[index].catImgPath;
                                setState(() {});
                              },
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor:
                                    UiColors.appbarbg.withOpacity(0.3),
                                child: Image.asset(
                                  ExpCategorys.mCategory[index].catImgPath,
                                  height: 40,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              ExpCategorys.mCategory[index].catTitle,
                              style: const TextStyle(
                                  color: UiColors.textBlack54, fontSize: 13),
                            )
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  saveBt() {
    return MyCustomButton(
        btName: 'Save',
        onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return ExpenseHome();
            },
          ));
          
          context
              .read<ExpBloc>()
              .add(AddExpenseEvent(tBalance: widget.tBalance));
        },
        bgColor: UiColors.black,
        foreColor: UiColors.white);
  }
}
