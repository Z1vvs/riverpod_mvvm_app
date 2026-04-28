import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/todo_repository_impl.dart';
import '../domain/entities/todo.dart';
import '../presentation/viewmodels/todo_viewmodel.dart';

final todoRepositoryProvider = Provider((ref) {
  return TodoRepositoryImpl();
});

final todoViewModelProvider =
StateNotifierProvider<TodoViewModel, List<Todo>>((ref) {
  final repo = ref.watch(todoRepositoryProvider);
  return TodoViewModel(repo);
});

enum TodoFilter { all, active, completed }

final todoFilterProvider = StateProvider<TodoFilter>((ref) => TodoFilter.all);

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final filter = ref.watch(todoFilterProvider);
  final todos = ref.watch(todoViewModelProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();

  List<Todo> filteredTodos = todos;

  if (query.isNotEmpty) {
    filteredTodos = filteredTodos
        .where((todo) => todo.title.toLowerCase().contains(query))
        .toList();
  }

  switch (filter) {
    case TodoFilter.completed:
      return filteredTodos.where((todo) => todo.completed).toList();
    case TodoFilter.active:
      return filteredTodos.where((todo) => !todo.completed).toList();
    case TodoFilter.all:
      return filteredTodos;
  }
});