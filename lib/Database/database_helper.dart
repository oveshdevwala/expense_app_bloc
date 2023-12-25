import 'package:expense_app/models/expense_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
//Variables

  // Db
  static const dbName = 'expenseDb.db';
  static const dbVersion = 1;
  //table
  static const expTable = 'expense';
  static const userTable = 'userTable';
  // user Column
// user Column
  static const colUserId = 'UserId';
  static const colUserName = 'UserName';
  static const colUserEmail = 'UserEmail';
  static const colUserPassword = 'UserPassword';
  // expense Column
  static const colExpenseId = 'expId';
  static const colExpenseTitle = 'expTitle';
  static const colExpenseDiscription = 'expDiscription';
  static const colExpenseAmount = 'expAmount';
  static const colExpenseBalance = 'expBalance';
  static const colExpTimeStamp = 'expTimeStamp';
  static const colExpenseType = 'expType';
  static const colExpCatagoryId = 'expCatagoryId';

//Private Constructor
  DataBaseHelper._();
  static DataBaseHelper instance = DataBaseHelper._();
// inil Db
  Database? db;
  Future<Database> inilDb() async {
    var docDirectory = await getApplicationDocumentsDirectory();
    var path = join(docDirectory.path, dbName);
    oncreate(Database db, int version) {
      String autoIncrementType = 'integer primary key autoincrement';
      String stringType = 'text not null';
      String intType = 'integer not null';
      String realType = 'real';
// User Table
      //       db.execute('''
      // Create TABLE $userTable(
      //   $colUserId $autoIncrementType,
      //   $colUserName $stringType,
      //   $colUserEmail $stringType,
      //   $colUserPassword $stringType
      // )''');
// Expense Table
      // $colUserId $intType,

      db.execute('''
CREATE TABLE $expTable(
  $colExpenseId $autoIncrementType,
  $colExpenseTitle $stringType,
  $colExpenseDiscription $stringType,
  $colExpTimeStamp $stringType,
  $colExpenseType $intType,
  $colExpCatagoryId $intType,
  $colExpenseAmount $realType,
  $colExpenseBalance $realType
)''');
    }

    return await openDatabase(path, version: dbVersion, onCreate: oncreate);
  }

  Future<Database> getDb() async {
    db ??= await inilDb();
    return db!;
  }

  Future<bool> addExpense(ExpenseModel model) async {
    var db = await getDb();
    var rowEffected = await db.insert(expTable, model.toMap());
    return rowEffected > 0;
  }

  Future<List<ExpenseModel>> fetchExpens() async {
    var db = await getDb();
    var data = await db.query(
      expTable,
      orderBy: '$colExpTimeStamp DESC',
    );
    List<ExpenseModel> arrddata = [];

    for (Map<String, dynamic> eachExp in data) {
      var expmodel = ExpenseModel.fromMap(eachExp);
      arrddata.add(expmodel);
    }
    return arrddata;
  }

  Future<bool> updateExp(ExpenseModel model) async {
    var db = await getDb();
    var rowEffected = await db.update(expTable, model.toMap(),
        where: "$colExpenseId = ?", whereArgs: ['${model.modelExpId}']);
    return rowEffected > 0;
  }

  Future<bool> deleteExp(int id) async {
    var db = await getDb();
    var rowEffected = await db
        .delete(expTable, where: "$colExpenseId = ?", whereArgs: ['$id']);
    return rowEffected > 0;
  }
}


// *****Database****
   //variables*
      // table*
        // User table
        // expense table

      // users*
        // user id
        // Email 
        // user Name
        // password

      // column*
        // Expense ID
        // Expense Title
        // Expense Discription
        // Expense timestamp
        // Expense amount
        // Expense Balance
        // Expense Type // ( 0 for debit / 1 for credit ) 
        // Expense Category Type

