// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_string_interpolations, avoid_function_literals_in_foreach_calls
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_application/app_bloc/app_states.dart';
import 'package:todo_application/views/archived_screen.dart';
import 'package:todo_application/views/done_screen.dart';
import 'package:todo_application/views/task_screen.dart';
class AppCubit extends Cubit<AppStates>
{
  late Database database;
  List<Map<String,dynamic>> newTasks = [];
  List<Map<String,dynamic>> doneTasks = [];
  List<Map<String,dynamic>> archivedTasks = [];
  AppCubit():super(InitialState());
  static AppCubit get(context)=>BlocProvider.of(context);
  int currentIndex = 0;
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  List<String> titles =
  [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  List<Widget> screens =
  [
    TaskScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];
  void toggleState(int index)
  {
    currentIndex = index;
    emit(ChangeBotNavState());
  }
  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
})
  {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(ChangeBottomSheetState());
  }
  void createDatabase() async
  {
    database = await openDatabase('todo.db',version:1,
        onCreate:(database,version)
        {
          print('Database Created');
          database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT , date TEXT , time TEXT , status TEXT)').then((value)
          {
            print('Table Created');
          }).catchError((error)
          {
            print('Error When Creating Table ${error.toString()}');
          });
        },
        onOpen:(database)
        {
          getDataFromDatabase(database);
          print('Database Opened');
        },
    );
      emit(CreateDatabaseState());
  }
 Future<void> insertToDatabase({
    required String title,
    required String date,
    required String time,
  })async
  {
     await database.transaction((txn) async
    {
      await txn.rawInsert('INSERT INTO tasks (title , date , time , status) VALUES ("$title","$date","$time","New Task")').then((value)
      {
        print('$value Inserted Successfully');
        emit(InsertToDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error)
      {
        print('Error When Inserting New Record ${error.toString()}');
      });
    });
  }
  void getDataFromDatabase(database)
  {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(LoadingGetDataFromDatabaseState());
    database.rawQuery('SELECT * FROM tasks').then((value) {

      value.forEach((element)
      {
        if(element['status'] == 'New Task')
        {
          newTasks.add(element);
        } else if(element['status'] == 'done')
        {
          doneTasks.add(element);
        } else
        {
          archivedTasks.add(element);
        }
      });
      emit(GetDataFromDatabaseState());
    });
  }
  void updateData({
    required String status,
    required int id,
}) async
  {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',['$status',id]).then((value)
    {
      getDataFromDatabase(database);
      emit(UpdateDataFromDatabaseState());
    });
  }
  void deleteData({
    required int id,
  }) async
  {
    database.rawDelete('DELETE FROM tasks WHERE id = ?',[id]).then((value)
    {
      getDataFromDatabase(database);
      emit(DeleteDataFromDatabaseState());
    });
  }
}