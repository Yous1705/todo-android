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
  void initState(){
    super.initState();
    _todoFormController.loadCategories(
      onRefreshUI: () => setState(() {}
      ),
    );
  }

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

              const SizedBox(height: 20),
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

              const SizedBox(height: 20),
              //Dropdown Category
              _todoFormController.isLoadingCategories
                  ? const Center( child: CircularProgressIndicator())
                  : DropdownButtonFormField<CategoryModel>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),//Input Decoration
                value: _todoFormController.selectedCategory,
                hint: const Text('Select Category'),

                items: _todoFormController.categories.map((CategoryModel category){
                  return DropdownMenuItem<CategoryModel>(
                    value: category,
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Color(int.parse(category.color.replaceAll('#', '0xFF'))),
                            shape: BoxShape.circle,
                          ),//BoxDecoration
                        ),//Container
                        const SizedBox(width: 8),
                        Text(category.name),
                      ],//Children
                    ),//Row
                  );//DropdownMedu
                }).toList(),// items
                onChanged: (CategoryModel? newValue){
                  _todoFormController.selectedCategory = newValue;
                  setState(() {});
                },
              ),//Dropdown category

              const SizedBox(height: 30),

            //   Button

              ElevatedButton(
                onPressed: _todoFormController.isLoading
                    ? null
                    : (){
                  _todoFormController.submitTodo(
                    onRefreshUI: () => setState(() {}),
                    onSuccess: (){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Todo Created SuccessFully'),
                        backgroundColor: Colors.green,
                        ) // Snackbar
                      );
                      Navigator.pop(context, true);
                    },// onSuccess

                    onError: (error){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error),
                        backgroundColor: Colors.red,
                        )//Snackbar
                      );// SnackBar
                    },
                  );//submitTodo
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),//style

                child: _todoFormController.isLoading
                  ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,),
                )
                    : const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)
              )//ElevateButton



            ],
          ),//Column
        ),//Form


      )//SIngle Child Scroll VIew
    );// Scaffold
  }
}