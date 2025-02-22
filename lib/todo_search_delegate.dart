import 'package:flutter/material.dart';
import 'todo.dart';

class TodoSearchDelegate extends SearchDelegate<Todo?> {
  final List<Todo> todos;

  TodoSearchDelegate(this.todos);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = todos.where((todo) => todo.title.contains(query)).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final todo = results[index];
        return ListTile(
          title: Text(todo.title),
          subtitle: todo.time != null ? Text(todo.time.toString()) : null,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = todos.where((todo) => todo.title.contains(query)).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final todo = suggestions[index];
        return ListTile(
          title: Text(todo.title),
          subtitle: todo.time != null ? Text(todo.time.toString()) : null,
        );
      },
    );
  }
}
