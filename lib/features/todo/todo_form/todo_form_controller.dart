import 'package:flutter/material.dart';
import 'package:todo/features/todo/model/category_model.dart';
import 'package:todo/features/todo/repository/todo_repository.dart';

class TodoFormController extends ChangeNotifier {
  final TodoRepository _todoRepository = TodoRepository();

  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descController = TextEditingController();
  DateTime? selectedDueDate;
  CategoryModel? selectedCategory;

  bool isLoading = false;

  Future<void> submitTodo({
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    if (!formKey.currentState!.validate()) return;

    if (selectedDueDate == null) {
      onError("Due Date is empty");
      return;
    }

    if (selectedCategory == null) {
      onError("Please select a category");
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final isSuccess = await _todoRepository.createTodo(
        title: titleController.text,
        description: descController.text,
        dueDate: selectedDueDate!,
        categoryId: selectedCategory!.id,
      );

      if (isSuccess) {
        onSuccess();
      }
    } catch (e) {
      onError(e.toString().replaceAll('Exception', ''));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }
}
