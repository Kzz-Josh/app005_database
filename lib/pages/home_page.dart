import 'package:app0005/db/db_admin.dart';
import 'package:app0005/models/task_model.dart';
import 'package:app0005/widgets/my_form_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<String> getFullName() async {
    return "Juan Manuel";
  }

  showDialogForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyFormWidget();
      },
    ).then((value) {
      print("El formulario fue cerrado");
      setState(() {});
    });
  }

  deleteTask(int taskId) {
    DBAdmin.db.deleteTask(taskId).then((value) {
      if (value > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.indigo,
            content: Row(
              children: const [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text("Tarea Eliminada"),
              ],
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DBAdmin.db.getTasks();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialogForm();
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: DBAdmin.db.getTasks(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.hasData) {
            List<TaskModel> myTasks = snap.data;
            return ListView.builder(
              itemCount: myTasks.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: UniqueKey(),
                  // confirmDismiss: (DismissDirection direction) async {
                  //   return true;
                  // },
                  direction: DismissDirection.startToEnd,
                  background: Container(color: Colors.redAccent),
                  //secondaryBackground: Text("Hola2"),
                  onDismissed: (DismissDirection direction) {
                    deleteTask(myTasks[index].id!);
                  },
                  child: ListTile(
                      title: Text(myTasks[index].title),
                      subtitle: Text(myTasks[index].description),
                      trailing: IconButton(
                        onPressed: () {
                          showDialogForm();
                        },
                        icon: Icon(Icons.edit),
                      )),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
