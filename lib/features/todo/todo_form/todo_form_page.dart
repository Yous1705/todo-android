import 'package:flutter/material.dart';
import 'package:todo/features/todo/model/category_model.dart';
import 'package:todo/features/todo/todo_form/todo_form_controller.dart';

class TodoFormPage extends StatefulWidget{
  const TodoFormPage({super.key});
  @override
  State<TodoFormPage> createState() =>  _TodoFormPageState();

}

class _TodoFormPageState extends State<TodoFormPage>{
  final _todoFormController = TodoFormController();

  @override
  void dispose(){
    _todoFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _todoFormController.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input Title
              TextFormField(
                controller: _todoFormController.titleController,
                decoration: const InputDecoration(
                  labelText: "Task",
                  hintText: "Title....",
                  border: OutlineInputBorder(),
                ),// Input decoration
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Title cant be empty';
                  }
                  return null;
                },
              ),//Input Title
              const SizedBox(height: 20),
              //Input description
              TextFormField(
                controller: _todoFormController.descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'elaborate your task',
                  border: OutlineInputBorder(),
                ),// input Decoration
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Title cant be empty';
                  }
                  return null;
                },
              ),// Input Description

            //   Input DueDate
              ListTile(
                title: Text(
                  _todoFormController.selectedDueDate == null
                      ? 'DeadLine'
                      : 'Date: ${_todoFormController.selectedDueDate!.toLocal().toString().split(' ')[0]}',
                ),// title text

                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );

                  if (pickedDate != null) {
                    _todoFormController.selectedDueDate = pickedDate;
                    setState(() {});
                  }// Date picker
                },
              ),// Input DudeDate ListTile

              //Dropdown Category
              // DropdownButtonFormField<CategoryModel>(items: items, onChanged: onChanged)
            ],
          ),//Column
        ),//Form


      )//SIngle Child Scroll VIew
    );// Scaffold
  }
}