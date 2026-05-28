
import 'package:flutter/material.dart';
import 'package:todo/features/todo/todo_list/todo_list_controller.dart';

class TodoListPage extends StatefulWidget{
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final _controller = TodoListController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData(){
    _controller.loadTodos(
        onRefreshUI: (){
          setState(() {});
        },
        onErrorReceived: (errorMessage){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
          );
        },
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todo List'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
            onPressed: _fetchData,
          )
        ],
      ),
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _controller.todos.isEmpty ? _buildEmptyState()
          : _buildTodoList(),
    );
  }

  Widget _buildEmptyState(){
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.playlist_add_check_rounded, size: 80, color: Colors.grey[400],),
            const SizedBox(height: 16),
            Text(
              _controller.errorMessage.isEmpty ? 'Tidak ada Todo hari ini'
                  : _controller.errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            )//Text
          ],//Children
        ),//Column
      ),// Padding
    ); //Center
  } // Widget

Widget _buildTodoList(){
    return RefreshIndicator(
        onRefresh: () async => _fetchData(),
      child: ListView.builder(
          padding: const EdgeInsets.all(16),
        itemCount: _controller.todos.length,
        itemBuilder: (context, index){
            final todo = _controller.todos[index];

            final categoryColor = todo.category != null
                ? Color(int.parse(todo.category!.color.replaceAll('#', '0xFF')))
                : Colors.grey;

            return Card(
              margin: const EdgeInsets.only(bottom:12),
              elevation: 2,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  todo.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: todo.status == 'COMPLETED'
                      ? TextDecoration.lineThrough
                        : TextDecoration.none
                  ),
                ),//Title
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(todo.description, style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(height: 12,),

                    if(todo.category !=null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: categoryColor),
                        ),// BoxDecoration
                        child: Text(
                          todo.category!.name,
                          style: TextStyle(
                            color: categoryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),// Style
                        ),//Child Text
                      )//container
                  ],//children
                ),//subTitle
                trailing: Icon(
                  todo.status == 'COMPLETED'
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: todo.status == 'COMPLETED'
                      ? Colors.green : Colors.grey,
                  size: 28,
                ),//Trailing
              ),//ListTile
            );//Card
        },//itemBuilder
      ),//  ListView.builder
    );// refreshIndicator
}//buildTodoList
}