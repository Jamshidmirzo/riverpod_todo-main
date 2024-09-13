import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/todo.dart';
import '../../providers/todos_provider.dart';

/// The homepage of our application
class TodosScreen extends ConsumerWidget {
  const TodosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Todo>> todos = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todos"),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(todoListProvider.notifier).addTodo(Todo(
                  id: "3", title: 'This is a new todo', date: DateTime.now()));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: switch (todos) {
          AsyncData(:final value) => ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                final todo = value[index];
                return ListTile(
                  title: Text(todo.title),
                );
              },
            ),
          AsyncError() => const Text('Oops, something unexpected happened'),
          _ => const CircularProgressIndicator(),
        },
      ),
    );
  }
}
