import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase_app/add_task.dart';
import 'package:intl/intl.dart';
import 'package:todo_firebase_app/description.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String uid = '';
  @override
  void initState() {
    getuid();
    super.initState();
  }

  getuid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = await auth.currentUser;

    setState(() {
      uid = user!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: const Center(
          child: Text(
            'TODO',
            style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.yellow,
              ))
        ],
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('tasks')
                .doc(uid)
                .collection('mytasks')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    // var time = (docs[index]['timestamp'] as Timestamp).toDate();
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Description(
                                title: docs[index]['title'],
                                description: docs[index]['description'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 90,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(left: 10, top: 20),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            docs[index]['title'],
                                            style: const TextStyle(
                                                color: Colors.yellowAccent,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),

                                      // Text(DateFormat('hh:mm').format(time)),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: IconButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('tasks')
                                            .doc(uid)
                                            .collection('mytasks')
                                            .doc(docs[index]['time'])
                                            .delete();
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 10),
                              //   child: Text(docs[index]['description'],style: const TextStyle(color: Colors.white,fontSize: 16),),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: docs.length,
                );
              } else {
                return Container(
                  child: const Text('No tasks found'),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTask(),
            ),
          );
        },
        backgroundColor: Colors.pink,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
