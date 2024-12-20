import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key,
  this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    
    super.initState();
    final todo = widget.todo;
    if( todo !=null) {
    isEdit = true;  
    final title = todo ['title'];
    final description = todo['description'];
    titlecontroller.text =title;
    descriptioncontroller.text = description;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Todo': 'Add Todo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titlecontroller,
            decoration: const InputDecoration(hintText: "Title"),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptioncontroller,
            decoration: InputDecoration(hintText: "Description"),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: isEdit? updateData: submitData,
              
            
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                isEdit? 'Update' : "submit"),
            ),
          )
        ],
      ),
    );
  }

Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print('you can not update without todo data');
      return;
    }
    final id = todo['_id'];

   final title = titlecontroller.text;
    final description = descriptioncontroller.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
};
final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json"   
           }
    );
      if (response.statusCode == 201) {
titlecontroller.text="";
descriptioncontroller.text ="";

showSuccessMessage("Update success");
  }else {
      
       showErrorMessage("Update Failed");
      
    }}



  Future<void> submitData() async {
    final title = titlecontroller.text;
    final description = descriptioncontroller.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json"   
           }
    );
    if (response.statusCode == 201) {
titlecontroller.text="";
descriptioncontroller.text ="";

showSuccessMessage("creation success");
  }else {
      print("Creation Failed");
       showErrorMessage("Creation Failed");
      print(response.body);
    }
    
  }
  void showSuccessMessage(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void showErrorMessage(String message){
    final snackBar = SnackBar(content: Text(message,
    style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.red,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
