

import 'dart:ui';

import 'package:todo/features/todo/model/todo_model.dart';
import 'package:todo/features/todo/repository/todo_repository.dart';

class TodoListController {
  final TodoRepository _todoRepository = TodoRepository();

  List<TodoModel> todos= [];

  bool isLoading = false;
  String errorMessage = '';

  Future<void> loadTodos({
    required VoidCallback onRefreshUI,
    required Function(String) onErrorReceived,
})async{
    isLoading = true;
    errorMessage = '';
    onRefreshUI();

    try{
      todos = await _todoRepository.fetchAllTodos();
    }catch(e){
      errorMessage = e.toString().replaceAll('Exception: ', '');
      onErrorReceived(errorMessage);
    }finally{
      isLoading = false;
      onRefreshUI();
    }
  }
}