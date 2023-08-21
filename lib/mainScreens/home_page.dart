
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:horizontalcalender/horizontalcalendar.dart';
import 'package:confetti/confetti.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/mainScreens/todo_list.dart';
class MyHomePage extends StatefulWidget {

   MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ConfettiController _controllerTopCenter;

  List colors=[
    Colors.teal.shade50,
    Colors.purple.shade50,
    Colors.brown.shade50,
    Colors.blue.shade50,
    Colors.green.shade50,
  ];
  final _myBox = Hive.box('myBox');
  @override
  void initState() {
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 1));
   if(_myBox.get('TODOLIST')==null){
     db.createInitialData();
   }else{
     db.loadDta();
   }
    super.initState();
  }
  ToDoDatabase db=ToDoDatabase();
  @override
  void dispose() {
    _controllerTopCenter.dispose();
    super.dispose();
  }
  bool isBlue=false;
  @override
  final newTaskController=TextEditingController();

  final FixedExtentScrollController itemController = FixedExtentScrollController();
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.purple.shade200.withOpacity(0.4),
            title: Text('To Do List',style: TextStyle(color: Colors.purple.shade700,fontWeight: FontWeight.bold)
            ),),
          body: SafeArea(
              child:
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 160,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(3.0),
                    child: Column(
                      children: [
                        HorizontalCalendar(
                          DateTime.now(),
                          width: MediaQuery.of(context).size.width*.17,
                          height: 90,
                          selectionColor: Colors.purple.shade200.withOpacity(0.4),
                          itemController: itemController,
                          selectedTextColor: Colors.black,
                          selectedDateStyle: TextStyle(fontSize: 15,color: Colors.purple.shade700,fontWeight: FontWeight.bold),
                          dayTextStyle: TextStyle(fontSize: 15),
                          dateTextStyle: TextStyle(fontSize: 15),
                          selectedDayStyle: TextStyle(fontSize: 15,color: Colors.purple.shade700,fontWeight: FontWeight.bold),


                        ),
                        SizedBox(height: 20,),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade200.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            child: Center(child: Text('Tasks',style: TextStyle(fontSize: 20,
                                color: Colors.purple.shade700,fontWeight: FontWeight.bold)))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: db.todoList.length,
                      itemBuilder: (context, index) {
                        return TodoList(
                            currentColor:colors[index % colors.length],
                            onpress: (){
                              setState(() {
                                db.todoList.removeAt(index);
                                db.update();
                              });
                            },
                            taskName: db.todoList[index][0],
                            isCheck: db.todoList[index][1],
                            onChange: (value){
                              checkboxChange(value ,index);


                            });

                      },

                    ),
                  ),
                ],
              )
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              addTask();
            },
            tooltip: 'Add Task',
            child: const Icon(Icons.add),
          ),
        ),
         Align(
           alignment: Alignment.topCenter,
           child: ConfettiWidget(
                confettiController: _controllerTopCenter,
                blastDirection: pi/2,
                numberOfParticles: 80,
              ),
         ),
         ],
    );
  }
  void addTask(){
    GlobalKey<FormState> formKey=GlobalKey<FormState>();
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title:Text('Add Task'),
        content: Container(
          height: 80,
          child: Column(
            children: [
              Form(
                key: formKey,
                child: TextFormField(
                  controller: newTaskController,
                  maxLength: 28,
                  decoration: InputDecoration(
                    hintText: "Enter Task",
                  ),
                  validator: (value) {
                    if(value!.isEmpty){
                      return 'Enter Task';
                    }
                  },
                ),
              ),


            ],

          ),
        ),
        actions: [
          ElevatedButton(onPressed: (){
            if(formKey.currentState!.validate()){
              setState(() {
                db.todoList.add([newTaskController.text,false]);
                db.update();
                Navigator.pop(context);
                newTaskController.clear();
              });
            }

          }, child: Text('Add')),
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
            newTaskController.clear();
          }, child: Text('Cancel')),
        ],
      );
    },);
  }
  void checkboxChange(bool? value,int index){
    setState(() {
      db.todoList[index][1]=!db.todoList[index][1];
      db.todoList[index][1]? _controllerTopCenter.play():_controllerTopCenter.stop();

    });
    db.update();
  }

}
