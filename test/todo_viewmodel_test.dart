import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_mvvm_app/domain/entities/todo.dart';
import 'package:riverpod_mvvm_app/domain/repositories/todo_repository.dart';
import 'package:riverpod_mvvm_app/presentation/viewmodels/todo_viewmodel.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late TodoViewModel viewModel;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    // Prepare mock for initial loading
    when(() => mockRepository.getTodos()).thenAnswer((_) async => []);
    viewModel = TodoViewModel(mockRepository);
  });

  test('Initial state should be empty and call loadTodos', () async {
    expect(viewModel.state, []);
    verify(() => mockRepository.getTodos()).called(1);
  });

  test('addTodo should add a new todo to the state and repository', () async {
    final title = 'Test Task';
    when(() => mockRepository.addTodo(any())).thenAnswer((_) async => {});

    await viewModel.addTodo(title);

    expect(viewModel.state.length, 1);
    expect(viewModel.state.first.title, title);
    verify(() => mockRepository.addTodo(any())).called(1);
  });

  test('deleteTodo should remove todo from state', () async {
    final todo = Todo(id: '1', title: 'Task 1', completed: false);
    // Simulate presence of one task
    when(() => mockRepository.getTodos()).thenAnswer((_) async => [todo]);
    await viewModel.loadTodos();

    when(() => mockRepository.deleteTodo('1')).thenAnswer((_) async => {});
    await viewModel.deleteTodo('1');

    expect(viewModel.state, []);
    verify(() => mockRepository.deleteTodo('1')).called(1);
  });

  test('toggleTodo should update completion status', () async {
    final todo = Todo(id: '1', title: 'Task 1', completed: false);
    when(() => mockRepository.getTodos()).thenAnswer((_) async => [todo]);
    await viewModel.loadTodos();

    when(() => mockRepository.updateTodo(any())).thenAnswer((_) async => {});
    await viewModel.toggleTodo('1');

    expect(viewModel.state.first.completed, true);
    verify(() => mockRepository.updateTodo(any())).called(1);
  });

  test('loadTodos should update state with repository data', () async {
    final todos = [
      Todo(id: '1', title: 'Task 1', completed: false),
      Todo(id: '2', title: 'Task 2', completed: true),
    ];
    when(() => mockRepository.getTodos()).thenAnswer((_) async => todos);

    await viewModel.loadTodos();

    expect(viewModel.state, todos);
  });
}

// Helper class for mocktail to understand Todo type
class TodoFake extends Fake implements Todo {}

void initTodoFake() {
  registerFallbackValue(TodoFake());
}
