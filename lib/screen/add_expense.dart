// ignore_for_file: must_be_immutable

import 'package:expense_app/app_constant/colors_const.dart';
import 'package:expense_app/app_constant/dummy_const.dart';
import 'package:expense_app/bloc/exp_bloc.dart';
import 'package:expense_app/bloc/exp_event.dart';
import 'package:expense_app/screen/expense_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../widgets/custom_widgets.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: UiColors.appbarbg.withOpacity(0.6),
        foregroundColor: UiColors.textBlack54,
        title: const Text(
          'Add Expense',
          style: TextStyle(color: UiColors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            ExpTextFields(context: context),
            const SizedBox(height: 10),
            expTypeSelctionBt(),
            const SizedBox(height: 10),
            const ActionButtons(),
          ],
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
            color: UiColors.appbarbg.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12)),
        child: DropdownButton(
          isDense: true,
          dropdownColor: UiColors.tealBg,
          hint: const ColoredBox(color: Colors.black),
          borderRadius: BorderRadius.circular(15),
          value: selectedExpType,
          items: expTypes
              .map((type) => DropdownMenuItem(value: type, child: Text(type)))
              .toList(),
          onChanged: (value) {
            selectedExpType = value!;
            setState(() {});
          },
        ),
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ChooseExpenseBT(),
        SizedBox(height: 15),
        SelectDateBT(),
        SizedBox(height: 15),
        SaveBT()
      ],
    );
  }
}

class SelectDateBT extends StatefulWidget {
  const SelectDateBT({
    super.key,
  });

  @override
  State<SelectDateBT> createState() => _SelectDateBTState();
}

class _SelectDateBTState extends State<SelectDateBT> {
  @override
  Widget build(BuildContext context) {
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
}

class ChooseExpenseBT extends StatefulWidget {
  const ChooseExpenseBT({
    super.key,
  });

  @override
  State<ChooseExpenseBT> createState() => _ChooseExpenseBTState();
}

class _ChooseExpenseBTState extends State<ChooseExpenseBT> {
  @override
  Widget build(BuildContext context) {
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
}

class ExpTextFields extends StatelessWidget {
  const ExpTextFields({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          CustomTextField(
            controller: context.read<ExpBloc>().titleController,
            hintText: 'Expense Name',
            suffixIcon: const Icon(
              Icons.abc,
              size: 30,
            ),
          ),
          const SizedBox(height: 25),
          CustomTextField(
            controller: context.read<ExpBloc>().discController,
            hintText: 'Add Description',
            suffixIcon: const Icon(
              Icons.abc,
              size: 30,
            ),
          ),
          const SizedBox(height: 25),
          CustomTextField(
            keyboardType: TextInputType.number,
            controller: context.read<ExpBloc>().amtController,
            hintText: 'Enter Amount',
            suffixIcon: const Icon(
              Icons.dialpad_sharp,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class SaveBT extends StatelessWidget {
  const SaveBT({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MyCustomButton(
        btName: 'Save',
        onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return const ExpenseHome();
            },
          ));
          context.read<ExpBloc>().add(AddExpenseEvent());
        },
        bgColor: UiColors.black,
        foreColor: UiColors.white);
  }
}
