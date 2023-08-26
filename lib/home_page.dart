import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/crud.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ref = FirebaseDatabase.instance.ref("todoDatabase");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("To do App"),
      ),
      body: StreamBuilder(
        stream: ref.onValue,
        builder: (contex, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Icon(
                Icons.warning,
                size: 40,
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Icon(
                Icons.hourglass_empty_outlined,
                size: 40,
              ),
            );
          } else {
            return FirebaseAnimatedList(
              query: ref,
              itemBuilder: (context, snapshot, animation, index) {
                return Card(
                  elevation: 4,
                  child: ListTile(
                    trailing: showPopupButton(
                        snapshot.child("id").value.toString(),
                        snapshot.child("title").value.toString()),
                    title: Text(
                      snapshot.child("title").value.toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      snapshot.child("date").value.toString(),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/addtask");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

showPopupButton(String id, title) {
  TextEditingController newTitleController = TextEditingController();
  late String deleteStatus;
  late String updateStatus;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  return PopupMenuButton(
    icon: const Icon(
      Icons.more_vert,
      size: 30,
      color: Colors.black,
    ),
    itemBuilder: (context) {
      return [
        PopupMenuItem(
          child: ListTile(
              onTap: () {
                Navigator.of(context).pop();
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Edit"),
                        content: Form(
                          key: globalKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This field is required";
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.text,
                                controller: newTitleController,
                                decoration: const InputDecoration(
                                  hintText: "Edit Title",
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              if (globalKey.currentState!.validate()) {
                                try {
                                  updateTask(
                                    id,
                                    newTitleController.text,
                                    DateTime.now().toString().substring(0, 11),
                                  );
                                  updateStatus = "Task updated";
                                } catch (e) {
                                  updateStatus = "Failed to update";
                                }
                                Navigator.of(context).pop();
                                final snackBar = SnackBar(
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.fixed,
                                  content: Text(updateStatus),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            child: const Text("Update"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel"),
                          )
                        ],
                      );
                    });
              },
              title: const Text(
                "Edit",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
              trailing: const Icon(
                Icons.edit,
                color: Colors.black,
              )),
        ),
        PopupMenuItem(
          child: ListTile(
            onTap: () {
              try {
                deleteTask(id);
                deleteStatus = "Task Deleted";
              } catch (e) {
                deleteStatus = "Failed to delete task";
              }
              Navigator.of(context).pop();
              final snackBar = SnackBar(
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.fixed,
                content: Text(deleteStatus),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            title: const Text(
              "Delete",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
            trailing: const Icon(
              Icons.delete,
              color: Colors.black,
            ),
          ),
        )
      ];
    },
  );
}
