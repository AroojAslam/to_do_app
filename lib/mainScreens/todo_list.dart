
import 'dart:math';

import 'package:flutter/material.dart';


class TodoList extends StatefulWidget {
   TodoList({super.key,required this.taskName,required this.isCheck, required this.onChange,required this.onpress,required this.currentColor});
  final bool isCheck ;
  final String taskName;
  Function(bool?)? onChange;
 final VoidCallback onpress;
 final Color currentColor;
  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10,right: 10,left: 10
      ),
      child: SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: widget.currentColor,
          elevation: 1,
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Checkbox(
                      activeColor: Theme.of(context).primaryColor,
                      value:widget.isCheck,
                      onChanged: widget.onChange,
                    ),
                  ),

                  Text(widget.taskName,textAlign: TextAlign.left,
                        style:widget.isCheck?const TextStyle(decoration: TextDecoration.lineThrough,color: Colors.black):
                        const TextStyle(decoration: TextDecoration.none,color: Colors.black)),
                ],
              ),
              Padding(padding: EdgeInsets.only(right: 10),
                child: IconButton(
                    onPressed: widget.onpress, icon: Icon(Icons.delete)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
