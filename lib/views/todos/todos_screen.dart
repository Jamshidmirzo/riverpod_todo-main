import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// A simple Todo model
class Todo {
  final String title;
  Todo({
    required this.title,
  });
}

// A state notifier that manages the list of todos
class TodoListNotifier extends StateNotifier<List<Todo>> {
  TodoListNotifier() : super([]);

  // Adds a new todo to the list
  void add(Todo todo) {
    state = [...state, todo];
  }
}

// A provider for accessing the TodoListNotifier
final todoListProvider = StateNotifierProvider<TodoListNotifier, List<Todo>>(
  (ref) => TodoListNotifier(),
);

/// The homepage of our application
class TodosScreen extends ConsumerWidget {
  TodosScreen({super.key});
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Function to handle adding a new todo
  void addTodo(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // Adding the todo to the provider
                  ref.read(todoListProvider.notifier).add(
                        Todo(title: controller.text),
                      );
                  controller.clear(); // Clear the text field after submission
                  Navigator.pop(context); // Close the dialog
                }
              },
              child: const Text("Done"),
            ),
          ],
          title: const Text("Add Todo"),
          content: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a todo";
                      }
                      return null;
                    },
                    controller: controller,
                    autofocus: true, // Auto focus on the text field
                    decoration: InputDecoration(
                      labelText: 'Todo',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => addTodo(context, ref),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Todos"),
      ),
      body: Center(
        child: todos.isEmpty
            ? const Text("No todos yet, add some!")
            : ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return ListTile(
                    title: Text(todo.title),
                  );
                },
              ),
      ),
    );
  }
}

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: TodosScreen(),
      ),
    ),
  );
}
