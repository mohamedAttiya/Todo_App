// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_is_empty
import 'package:flutter/material.dart';
import 'package:todo_application/app_bloc/app_cubit.dart';
Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String? Function(String?)? validator,
  required String labelText,
  required IconData prefixIcon,
  Function()? onTap,
  bool isClickable = true,
})=>TextFormField(
  keyboardType:type,
  enabled:isClickable,
  onTap:onTap,
  controller:controller,
  validator:validator,
  decoration:InputDecoration(
    labelText:labelText,
    prefixIcon:Icon(prefixIcon),
    border:OutlineInputBorder(),
  ),
);
Widget buildTaskItem(Map model,context)=>Dismissible(key:Key(model['id'].toString()),
    onDismissed:(direction)
    {
      AppCubit.get(context).deleteData(id:model['id']);
    },
    child:Padding(padding:EdgeInsets.all(20.0),child:Row(
  children:
  [
    CircleAvatar(
      radius:50.0,
      child:Text('${model['time']}'),
    ),
    SizedBox(width:20.0,),
    Expanded(child:Column(
      crossAxisAlignment:CrossAxisAlignment.start,
      mainAxisSize:MainAxisSize.min,
      children:
      [
        Text('${model['title']}',maxLines:3,style:TextStyle(fontSize:20.0,fontWeight:FontWeight.bold),),
        SizedBox(height:5,),
        Text('${model['date']}',style:TextStyle(color:Colors.grey,fontSize:18),),
      ],
    )),
    SizedBox(width:20.0,),
    IconButton(
      onPressed: ()
      {
        AppCubit.get(context).updateData(status:'done',id:model['id']);
      },
      icon: Icon(Icons.check_box, color: Colors.green),
    ),
    IconButton(onPressed:(){
      AppCubit.get(context).updateData(status:'Archived',id:model['id']);
    },icon:Icon(Icons.archive,color:Colors.black45,)),
  ],
),));
Widget myDivider()=>Padding(padding:EdgeInsets.symmetric(horizontal:16),child:Container(width:double.infinity,color:Colors.grey[300],height:1,),);