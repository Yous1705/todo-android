import 'package:flutter/material.dart';
import 'package:todo/features/todo/model/category_model.dart';
import 'package:todo/features/todo/repository/category_repository.dart';
import 'package:todo/features/todo/repository/todo_repository.dart';

class TodoFormController extends ChangeNotifier {
  final TodoRepository _todoRepository = TodoRepository();
  final CategoryRepository _categoryRepository = CategoryRepository();

  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descController = TextEditingController();
  DateTime? selectedDueDate;
  CategoryModel? selectedCategory;

  List<CategoryModel> categories = [];
  bool isLoading = false;
  bool isLoadingCategories = false;

  Future<void> loadCategories({required VoidCallback onRefreshUI}) async {
    isLoadingCategories = true;
    onRefreshUI();

    try {
      categories = await _categoryRepository.fetchAllCategories();
    } catch (e) {
      print('Error load category: $e');
    } finally {
      isLoadingCategories = false;
      onRefreshUI();
    }
  }

  Future<void> submitTodo({
    required VoidCallback onRefreshUI,
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
    onRefreshUI();

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
      onRefreshUI();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }
}
