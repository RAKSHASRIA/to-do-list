import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/add_task.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String uid = '';
  @override
  void initState() {
    getuid();
    super.initState();
  }

  getuid()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user =  auth.currentUser;
    setState(() {
      uid = user!.uid;
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TODO'),
       actions: [
          IconButton(onPressed: ()async{
            await FirebaseAuth.instance.signOut();

          }, icon: Icon(Icons.logout))
     ] ),
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width:  MediaQuery.of(context).size.width,
        // ignore: sort_child_properties_last
        child: StreamBuilder(stream: FirebaseFirestore
        .instance
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else{
            final docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: docs.length,
            itemBuilder: (context, index){
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration( 
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10)),
                height: 90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Container(
                    margin: EdgeInsets.only(left: 20),
                  child: Text(docs[index]['task']))
                ]),
                Container(child: IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () async{
                  await FirebaseFirestore.instance
                  .collection('tasks')
                  .doc(uid)
                  .collection('mytasks')
                  .doc(docs[index]['time'])
                  .delete();
                }))
                  ],
                ),
                );
            },
            );
          }
        },
        ),
        color: Color.fromARGB(255, 63, 82, 165),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTask()));
        },)
    );
  }
}