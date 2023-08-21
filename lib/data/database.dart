import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase{
  final _myBox=Hive.box('myBox');
  List todoList=[];
  //first time user enter
 void createInitialData(){
   todoList =[];
 }

void loadDta(){
   todoList= _myBox.get('TODOLIST');

}
void update(){
   _myBox.put('TODOLIST', todoList);
}
}