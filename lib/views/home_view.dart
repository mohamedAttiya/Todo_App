// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, prefer_is_empty
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_application/app_bloc/app_cubit.dart';
import 'package:todo_application/app_bloc/app_states.dart';
import 'package:todo_application/shared/components.dart';
class HomeView extends StatelessWidget {
  HomeView({super.key});
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create:(BuildContext context)=>AppCubit()..createDatabase(),
      child:BlocConsumer<AppCubit,AppStates>(builder:(context,state)
      {
        return Scaffold(
          key:scaffoldKey,
          floatingActionButton:FloatingActionButton(onPressed:()
          {
            if(AppCubit.get(context).isBottomSheetShown)
            {
               if(formKey.currentState!.validate())
               {
                 AppCubit.get(context).insertToDatabase(title:titleController.text,date:dateController.text,time:timeController.text);
            } } else
            {
              scaffoldKey.currentState!.showBottomSheet((context)=>
                  Container(
                    padding:EdgeInsets.all(20),
                    color:Colors.grey[100],
                    child:Form(
                        key:formKey,
                        child:Column(
                      mainAxisSize:MainAxisSize.min,
                      children:
                      [
                        defaultTextFormField(
                            controller:titleController,
                            type:TextInputType.text,
                            validator:(value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'This Field Must Not Empty';
                              }
                              return null;
                            }, labelText:'Task Title',
                            prefixIcon:Icons.title),
                        SizedBox(height:15.0,),
                        defaultTextFormField(
                            onTap:()
                            {
                              showTimePicker(context:context,initialTime:TimeOfDay.now()).then((value)
                              {
                                print(value!.format(context));
                                timeController.text =value.format(context);
                              });
                            },
                            controller:timeController,
                            type:TextInputType.datetime,
                            validator:(value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'This Field Must Not Empty';
                              }
                              return null;
                            }, labelText:'Task Time',
                            prefixIcon:Icons.watch_later_outlined),
                        SizedBox(height:15.0,),
                        defaultTextFormField(
                            onTap:()
                            {
                              showDatePicker(context:context,firstDate:DateTime.now(),lastDate:DateTime.parse('2025-01-10'),initialDate:DateTime.now()).then((value)
                              {
                                print(DateFormat.yMMMd().format(value!));
                                dateController.text = DateFormat.yMMMd().format(value);
                              });
                            },
                            controller:dateController,
                            type:TextInputType.datetime,
                            validator:(value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'This Field Must Not Empty';
                              }
                              return null;
                            }, labelText:'Task Date',
                            prefixIcon:Icons.calendar_today_outlined),
                      ],
                    )),),).closed.then((value)
              {
                AppCubit.get(context).changeBottomSheetState(isShow:false,icon:Icons.edit);
              });
              AppCubit.get(context).changeBottomSheetState(isShow:true,icon:Icons.add);
            }
          },child:Icon(AppCubit.get(context).fabIcon),),
          bottomNavigationBar:BottomNavigationBar(
              type:BottomNavigationBarType.fixed,
              currentIndex:AppCubit.get(context).currentIndex,
              onTap:(index)
              {
                AppCubit.get(context).toggleState(index);
              },
              items:
              [
                BottomNavigationBarItem(icon:Icon(Icons.menu),label:'Tasks'),
                BottomNavigationBarItem(icon:Icon(Icons.check_circle_outline),label:'Done'),
                BottomNavigationBarItem(icon:Icon(Icons.archive_outlined),label:'Archived'),
              ]),
          appBar:AppBar(
            centerTitle:true,
            title:Text(AppCubit.get(context).titles[AppCubit.get(context).currentIndex],style:TextStyle(fontSize:20.0,fontWeight:FontWeight.w600),),
          ),
          body:ConditionalBuilder(condition:state is! LoadingGetDataFromDatabaseState,builder:(context)=>AppCubit.get(context).screens[AppCubit.get(context).currentIndex],fallback:(context)=>Center(child:CircularProgressIndicator(),)),
        );
      }, listener:(context,state)
      {
        if(state is InsertToDatabaseState)
        {
          Navigator.pop(context);
        }
      }),
    );
  }
}