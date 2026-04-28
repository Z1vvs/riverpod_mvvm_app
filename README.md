# Riverpod MVVM Todo App

Цей проєкт продемонструє використання бібліотеки **Riverpod** для управління станом у Flutter-додатку за допомогою архітектурного патерну **MVVM**.

## Опис бібліотеки Riverpod

Riverpod — це реактивний фреймворк для управління станом, який є повним переосмисленням пакету Provider. Він усуває залежність від `BuildContext`, робить стан безпечним, тестованим та модульним.

## Основні можливості додатка

- **CRUD операції**: Створення, читання, редагування та видалення завдань.
- **Пошук та Фільтрація**: Живий пошук за назвою та фільтри (All, Active, Completed).
- **Офлайн-режим**: Автоматичне збереження даних у `SharedPreferences`.
- **Професійна архітектура**: Поділ на шари Domain, Data та Presentation (MVVM).

## Інструкція зі встановлення

1. **Клонуйте репозиторій**:

   ```bash
   git clone https://github.com/Z1vvs/riverpod_mvvm_app.git
   ```

2. **Встановіть залежності**:

   ```bash
   flutter pub get
   ```

3. **Запустіть додаток**:
   ```bash
   flutter run
   ```

## Приклади коду

### Опис ViewModel

Використання `StateNotifier` для керування списком завдань:

```dart
class TodoViewModel extends StateNotifier<List<Todo>> {
  final TodoRepository repository;
  TodoViewModel(this.repository) : super([]) { loadTodos(); }

  Future<void> addTodo(String title) async {
    final todo = Todo(id: DateTime.now().toString(), title: title, completed: false);
    await repository.addTodo(todo);
    state = [...state, todo];
  }
}
```

### Реактивна фільтрація

Використання `Provider` для обчислення відфільтрованого списку:

```dart
final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final filter = ref.watch(todoFilterProvider);
  final todos = ref.watch(todoViewModelProvider);
  return todos.where((todo) => /* логіка фільтрації */).toList();
});
```

## Скріншоти

|                                Головний екран                                 |                                Діалог додавання                                 |                                Результати пошуку                                 |                                Фільтр за категорією                                 |
| :---------------------------------------------------------------------------: | :-----------------------------------------------------------------------------: | :------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------: |
| <img src="https://i.imgur.com/xvmSXw8.png" width="180" alt="Головний екран"/> | <img src="https://i.imgur.com/r9M2VIS.png" width="180" alt="Діалог додавання"/> | <img src="https://i.imgur.com/X5OWYnu.png" width="180" alt="Результати пошуку"/> | <img src="https://i.imgur.com/mbcpe0M.png" width="180" alt="Фільтр за категорією"/> |

## Документація

- [Порівняння бібліотек (COMPARISON.md)](./COMPARISON.md)
- [Звіт про профілювання (PROFILING.md)](./PROFILING.md)
