import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'todo.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> todos = [];
  
  TodoProvider() {
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosString = prefs.getString('todos');
    if (todosString != null) {
      final List<dynamic> jsonList = jsonDecode(todosString);
      todos = jsonList.map((json) => Todo.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(todos.map((todo) => todo.toJson()).toList());
    await prefs.setString('todos', jsonString);
  }

  void addTodo(String title, {DateTime? time}) {
    if (title.trim().isEmpty) return;
    todos.add(Todo(title: title, time: time));
    _saveTodos();
    notifyListeners();
  }

  void markAsCompleted(int index) {
    if (index >= 0 && index < todos.length) {
      todos[index].isCompleted = true;
      _saveTodos();
      notifyListeners();
    }
  }

  void removeCompleted() {
    todos.removeWhere((todo) => todo.isCompleted);
    _saveTodos();
    notifyListeners();
  }

  void removeTodo(int index) {
    if (index >= 0 && index < todos.length) {
      todos.removeAt(index);
      _saveTodos();
      notifyListeners();
    }
  }

  void updateTodo(int index, String title, DateTime? time, bool isCompleted) {
    if (index >= 0 && index < todos.length) {
      todos[index] = Todo(
        title: title,
        time: time,
        isCompleted: isCompleted,
      );
      _saveTodos();
      notifyListeners();
    }
  }
}