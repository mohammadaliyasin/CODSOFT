import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future<void> addTaskToFirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      String uid = user.uid;
      var time = DateTime.now();
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(uid)
          .collection('mytasks')
          .doc(time.toString())
          .set({
        'title': titleController.text,
        'description': descriptionController.text,
        'time': time.toString(),
        'timestamp': time,
      });

      Fluttertoast.showToast(msg: 'Data Added');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.yellow,
        ),
        title: const Text(
          '              New Task',
          style: TextStyle(
            color: Colors.yellow,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
            ),
            child: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Enter Title',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
            ),
            child: TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Enter Description',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
            ),
            height: 60,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.zero,
            ),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.black,
                ),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              onPressed: () {
                addTaskToFirebase();
              },
              child: const Text(
                'Add Task',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}