import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/todo_provider.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(filteredTodosProvider);
    final filter = ref.watch(todoFilterProvider);

    void showTodoDialog({String? id, String? initialTitle}) {
      final controller = TextEditingController(text: initialTitle);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(id == null ? 'Add Todo' : 'Edit Todo'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final title = controller.text.trim();
                if (title.isNotEmpty) {
                  if (id == null) {
                    ref.read(todoViewModelProvider.notifier).addTodo(title);
                  } else {
                    ref.read(todoViewModelProvider.notifier).updateTodoTitle(id, title);
                  }
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search tasks...',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    ref.read(searchQueryProvider.notifier).state = value;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => ref.read(todoFilterProvider.notifier).state = TodoFilter.all,
                    child: Text('All', style: TextStyle(color: filter == TodoFilter.all ? Colors.blue : Colors.grey)),
                  ),
                  TextButton(
                    onPressed: () => ref.read(todoFilterProvider.notifier).state = TodoFilter.active,
                    child: Text('Active', style: TextStyle(color: filter == TodoFilter.active ? Colors.blue : Colors.grey)),
                  ),
                  TextButton(
                    onPressed: () => ref.read(todoFilterProvider.notifier).state = TodoFilter.completed,
                    child: Text('Completed', style: TextStyle(color: filter == TodoFilter.completed ? Colors.blue : Colors.grey)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return ListTile(
            leading: Checkbox(
              value: todo.completed,
              onChanged: (_) {
                ref.read(todoViewModelProvider.notifier).toggleTodo(todo.id);
              },
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.completed ? TextDecoration.lineThrough : null,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => showTodoDialog(id: todo.id, initialTitle: todo.title),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    ref.read(todoViewModelProvider.notifier).deleteTodo(todo.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showTodoDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}