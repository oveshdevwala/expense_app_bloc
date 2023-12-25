
// ignore_for_file: must_be_immutable

import 'package:expense_app/app_constant/colors_const.dart';
import 'package:flutter/material.dart';


class CustomTextField extends StatelessWidget {
  CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.keyboardType = TextInputType.name,
      required this.suffixIcon});
  Icon suffixIcon;
  String hintText;
  TextInputType keyboardType;
  TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: const TextStyle(color: UiColors.textBlack54),
        border: textFieldBorder(),
        errorBorder: textFieldBorder(),
        enabledBorder: textFieldBorder(),
        focusedBorder: textFieldBorder(),
        disabledBorder: textFieldBorder(),
        focusedErrorBorder: textFieldBorder(),
      ),
    );
  }

  OutlineInputBorder textFieldBorder() => OutlineInputBorder(
      borderSide: const BorderSide(color: UiColors.textBlack45),
      borderRadius: BorderRadius.circular(20));
}


class MyCustomButton extends StatelessWidget {
  MyCustomButton(
      {super.key,
      required this.btName,
      required this.onTap,
      required this.bgColor,
      this.myWidget,
      required this.foreColor});
  VoidCallback onTap;
  String btName;
  Color bgColor;
  Color foreColor;
  Widget? myWidget;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: bgColor,
            foregroundColor: foreColor),
        onPressed: onTap,
        child: myWidget ?? Text(btName),
      ),
    );
  }
}
