// import 'package:expense_app/Database/database_helper.dart';

import 'package:expense_app/Database/database_helper.dart';

class UserModel {
  int userModelId;
  String userModelName;
  String userModelEmail;
  String userModelPassword;
  UserModel(
      {required this.userModelId,
      required this.userModelEmail,
      required this.userModelName,
      required this.userModelPassword});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        userModelId: map[DataBaseHelper.colExpCatagoryId],
        userModelEmail: map[DataBaseHelper.colUserEmail],
        userModelName: map[DataBaseHelper.colUserName],
        userModelPassword: map[DataBaseHelper.colUserPassword]);
  }
  Map<String, dynamic> toMap() {
    return {
      DataBaseHelper.colUserId: userModelId,
      DataBaseHelper.colUserName: userModelName,
      DataBaseHelper.colUserEmail: userModelEmail,
      DataBaseHelper.colUserPassword: userModelPassword,
    };
  }
}

//  // user Column
//   static const colUserId = 'UserId';
//   static const colUserName = 'UserName';
//   static const colUserEmail = 'UserEmail';
//   static const colUserPassword = 'UserPassword';