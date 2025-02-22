import 'package:flutter/foundation.dart';
import 'todo.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> todos = [];

  void addTodo(String title, {DateTime? time}) {
    if (title.trim().isEmpty) return;
    todos.add(Todo(title: title, time: time));
    notifyListeners();
  }

  void markAsCompleted(int index) {
    if (index >= 0 && index < todos.length) {
      todos[index].isCompleted = true;
      notifyListeners();
    }
  }

  void removeCompleted() {
    todos.removeWhere((todo) => todo.isCompleted);
    notifyListeners();
  }

  void removeTodo(int index) {
    if (index >= 0 && index < todos.length) {
      todos.removeAt(index);
      notifyListeners();
    }
  }
}