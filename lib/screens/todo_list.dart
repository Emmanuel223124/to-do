import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_app/screens/add_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo list"),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              final id = item['_id']as String;
            return ListTile(
              leading:CircleAvatar(child:Text('${index + 1}' ,)),
              title: Text(item['title']),
               subtitle: Text(item['description']),
               trailing: PopupMenuButton(
                onSelected: (value) {
                  // deleteById(id);
                  // print("hello 1");
                  // navigateToEditPage(item);
                  if (value == 'Edit') {
                 
                    navigateToEditPage(item);

                  }else if (value == 'Delete'){
              
                    deleteById(id);
                  }
                },
                itemBuilder: (context){
                return[
                  const PopupMenuItem(value: 'Edit',child: Text('Edit'),),
                  const PopupMenuItem(value: 'Delete',child: Text('Delete'),
                  ),
                ];
               }),
            );
          }),
        ),
        child: Center(child: CircularProgressIndicator(),),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage, label: Text("Add To do")),
    );
  }

   Future<void> navigateToEditPage(Map item)async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item,),
    );
     await Navigator.push(context, route);
    setState((){
    isLoading = true;
    });
    fetchTodo();
  }
   Future<void> navigateToAddPage()async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState((){
    isLoading = true;
    });
    fetchTodo();
  }

  Future<void>deleteById(String id) async {
    print("object");
  final url ='https://api.nstack.in/v1/todos/$id';
  final uri =Uri.parse(url);
  final response = await http.delete(uri);
  print(response.body);
  if (response.statusCode == 200){
  final filtered  = items.where( (element)  => element['_id'] !=id).toList();
  setState((){
    items  = filtered;
  });

  }else {
showErrorMessage('unable to delete');
  }

  }

  Future<void> fetchTodo() async {
   
    final url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json["items"] as List;
      setState(() {
        items = result;
      });
    } 
    setState(() {
      isLoading = false;
    });
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
