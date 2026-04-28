import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../data/models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  static const String _storageKey = 'todos_list';

  @override
  Future<List<Todo>> getTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosJson = prefs.getString(_storageKey);
    if (todosJson == null) return [];

    final List<dynamic> decodedList = jsonDecode(todosJson);
    return decodedList.map((item) {
      final model = TodoModel.fromJson(item);
      return Todo(id: model.id, title: model.title, completed: model.completed);
    }).toList();
  }

  @override
  Future<void> addTodo(Todo todo) async {
    final todos = await getTodos();
    todos.add(todo);
    await _saveTodos(todos);
  }

  @override
  Future<void> deleteTodo(String id) async {
    final todos = await getTodos();
    todos.removeWhere((e) => e.id == id);
    await _saveTodos(todos);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    final todos = await getTodos();
    final index = todos.indexWhere((e) => e.id == todo.id);
    if (index != -1) {
      todos[index] = todo;
      await _saveTodos(todos);
    }
  }

  Future<void> _saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList = todos.map((todo) {
      return TodoModel(id: todo.id, title: todo.title, completed: todo.completed).toJson();
    }).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }
}