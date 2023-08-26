import 'package:firebase_database/firebase_database.dart';

final ref = FirebaseDatabase.instance.ref("todoDatabase");

createTask(String title, String date) async {
  String id = DateTime.now().microsecondsSinceEpoch.toString();
  await ref.child(id).set(
    {
      "title": title,
      "id": id,
      "date": date,
    },
  );
}

deleteTask(String id) async {
  await ref.child(id).remove();
}

updateTask(String id, newTitle, date) async {
  ref.child(id).update({"date": date, "id": id, "title": newTitle});
}
