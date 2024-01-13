// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_is_empty
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_application/app_bloc/app_cubit.dart';
import 'package:todo_application/app_bloc/app_states.dart';
import 'package:todo_application/shared/components.dart';
class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(builder:(context,state)
    {
      var tasks = AppCubit.get(context).newTasks;
      return ConditionalBuilder(
          condition:tasks.length > 0,
          builder:(context)=>ListView.separated(
          physics:BouncingScrollPhysics(),
          itemBuilder:(context,index)=>buildTaskItem(AppCubit.get(context).newTasks[index],context),
          separatorBuilder:(context,index)=>myDivider(),
          itemCount:AppCubit.get(context).newTasks.length),
          fallback:(context)=>Center(
          child:Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            Icon(Icons.menu,size:100,color:Colors.grey,),
            Text('No Tasks Yet , Please Add Some Tasks',textAlign:TextAlign.center,style:TextStyle(fontSize:20.0,fontWeight:FontWeight.bold,color:Colors.grey),),
          ],),
      ));
    }, listener:(context,state){});
  }
}