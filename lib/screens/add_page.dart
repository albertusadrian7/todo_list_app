import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo["title"];
      final description = todo["description"];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(isEdit ? "Edit Todo" : "Add Todo"), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: "Title"),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: "Description"),
            minLines: 5,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                if (isEdit) {
                  updateData();
                } else {
                  submitData();
                }
              },
              child: Text(isEdit ? "Update" : "Submit"))
        ],
      ),
    );
  }

  Future<void> submitData() async {
    String message = "";
    // Get the data from form
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    // Submit data to the server
    const url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    // Show success or fail message based on status
    if (response.statusCode == 201) {
      titleController.text = "";
      descriptionController.text = "";
      message = "Data has been saved!";
      debugPrint(message);
      showSuccessMessage(message);
      if(context.mounted) {
        Navigator.pop(context);
      }
    } else {
      message = "Failed to save data! Error: ${response.body}";
      debugPrint(message);
      showSuccessMessage(message);
    }
  }

  Future<void> updateData() async {
    String message = "";
    // Get the data from form
    final todo = widget.todo;

    if (todo == null) {
      debugPrint("You can't call updated without todo data");
      return;
    }

    final id = todo["_id"];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    // Update data to the server
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    // Show success or fail message based on status
    if (response.statusCode == 200) {
      titleController.text = "";
      descriptionController.text = "";
      message = "Data has been updated!";
      debugPrint(message);
      showSuccessMessage(message);
      if(context.mounted) {
        Navigator.pop(context);
      }
    } else {
      message = "Failed to update data! Error: ${response.body}";
      debugPrint(message);
      showSuccessMessage(message);
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
