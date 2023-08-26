import 'package:flutter/material.dart';
import 'crud.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTitleState();
}

class _AddTitleState extends State<AddTask> {
  late String status;
  String todaysDate = DateTime.now().toString().substring(0, 11);
  TextEditingController dateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  pickDate() async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 3),
    ).then((value) {
      todaysDate = value.toString().substring(0, 11);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    dateController.text = todaysDate;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add to do tasks"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: ListView(
          children: [
            Form(
              key: globalKey,
              child: Column(
                children: [
                  TextFormField(
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field is required";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    controller: titleController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      suffixIcon: const Icon(Icons.work),
                      hintText: "Enter the task title",
                      hintStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field is required";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.datetime,
                    controller: dateController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            pickDate();
                          },
                          icon: const Icon(Icons.date_range)),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      hintText: todaysDate,
                      hintStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    minWidth: size.width,
                    height: size.height * 0.06,
                    color: Colors.purple.shade400,
                    shape: const StadiumBorder(),
                    onPressed: () {
                      if (globalKey.currentState!.validate()) {
                        try {
                          createTask(
                            titleController.text.toString(),
                            dateController.text.toString(),
                          );
                          titleController.clear();
                          dateController.clear();
                          status = "Task ddded sucessfully";
                        } catch (e) {
                          debugPrint("an error occured");
                          status = "Failed to add task";
                        }
                        final snackBar = SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Text(status),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: const Text(
                      "Add Task",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
