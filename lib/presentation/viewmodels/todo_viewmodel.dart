import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';

class TodoViewModel extends StateNotifier<List<Todo>> {
  final TodoRepository repository;

  TodoViewModel(this.repository) : super([]) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    state = await repository.getTodos();
  }

  Future<void> addTodo(String title) async {
    final todo = Todo(
      id: DateTime.now().toString(),
      title: title,
      completed: false,
    );

    await repository.addTodo(todo);
    state = [...state, todo];
  }

  Future<void> toggleTodo(String id) async {
    final todoIndex = state.indexWhere((e) => e.id == id);
    if (todoIndex != -1) {
      final updatedTodo = Todo(
        id: state[todoIndex].id,
        title: state[todoIndex].title,
        completed: !state[todoIndex].completed,
      );
      
      await repository.updateTodo(updatedTodo);
      
      state = [
        for (final todo in state)
          if (todo.id == id) updatedTodo else todo,
      ];
    }
  }

  Future<void> updateTodoTitle(String id, String newTitle) async {
    final todoIndex = state.indexWhere((e) => e.id == id);
    if (todoIndex != -1) {
      final updatedTodo = Todo(
        id: state[todoIndex].id,
        title: newTitle,
        completed: state[todoIndex].completed,
      );
      
      await repository.updateTodo(updatedTodo);
      
      state = [
        for (final todo in state)
          if (todo.id == id) updatedTodo else todo,
      ];
    }
  }

  Future<void> deleteTodo(String id) async {
    await repository.deleteTodo(id);
    state = state.where((e) => e.id != id).toList();
  }
}