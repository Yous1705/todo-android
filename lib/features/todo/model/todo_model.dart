

import 'package:todo/features/todo/model/category_model.dart';

class TodoModel {
  final int id;
  final String title;
  final String description;
  final String status;
  final String priority;
  final DateTime dueDate;
  final CategoryModel? category;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.dueDate,
    required this.category,
});

  factory TodoModel.fromJson(Map<String, dynamic>json){
    return TodoModel(
        id: json['id'] as int,
        title: json['title'] as String,
        description: json['description'] as String,
        status: json['status'] as String,
        priority: json['priority'] as String,
        dueDate: DateTime.parse(json['due_date'] ?? DateTime.now().toString()),
        category: json['category'] != null
            ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
            : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'due_date': dueDate.toIso8601String(),
      'category': category?.toJson(),
    };
  }
}