import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController taskController = TextEditingController(); 
  addtasktofirebase() async {
     FirebaseAuth auth = FirebaseAuth.instance;
     final User? user = auth.currentUser;
     if(user!=null){
      String uid = user.uid;
      var time = DateTime.now();
    await FirebaseFirestore.instance
    .collection('tasks')
    .doc(uid)
    .collection('mytasks')
    .doc(time.toString())
    .set({
      'task':taskController.text,
      'time': time.toString()
      });
      Fluttertoast.showToast(msg: 'Data Added');
     }else{
      Fluttertoast.showToast(msg:'User not Authenticated');
     }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Task')),
      body: Container(padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(child: TextField(
            controller: taskController,
            decoration: InputDecoration(labelText: 'Enter the Task',border: OutlineInputBorder()),
          ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 50,
             child:ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                if(states.contains(MaterialState.pressed))
                   return Colors.purple.shade100;
                return Theme.of(context).primaryColor;
              })),
              child: Text('Add Task'),
            onPressed: () {
              addtasktofirebase();
            },
            ))
        ],
        )
      )
    );
  }
}