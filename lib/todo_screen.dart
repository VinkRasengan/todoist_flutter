import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_provider.dart';
import 'todo.dart';
import 'package:intl/intl.dart';
import 'todo_search_delegate.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  TodoScreenState createState() => TodoScreenState();
}

class TodoScreenState extends State<TodoScreen> {
  String filter = 'All';
  TextEditingController searchController = TextEditingController();

  void _searchTodo() {
    showSearch(
      context: context,
      delegate: TodoSearchDelegate(
        Provider.of<TodoProvider>(context, listen: false).todos,
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();
    DateTime? selectedTime;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add TODO'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'Enter TODO title'),
              ),
              TextButton(
                onPressed: () async {
                  selectedTime = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selectedTime != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      selectedTime = DateTime(
                        selectedTime!.year,
                        selectedTime!.month,
                        selectedTime!.day,
                        time.hour,
                        time.minute,
                      );
                    }
                  }
                  if (!mounted) return; // Check if the widget is still mounted
                  setState(() {}); // Thêm để cập nhật UI
                },
                child: const Text('Select Date & Time'),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (!mounted) return; // Check if the widget is still mounted
                Provider.of<TodoProvider>(context, listen: false)
                    .addTodo(controller.text, time: selectedTime);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            )
          ],
        );
      },
    );
  }

  void _showEditTodoDialog(BuildContext context, Todo todo, int index) {
    TextEditingController controller = TextEditingController(text: todo.title);
    DateTime? selectedTime = todo.time;
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit TODO'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'Enter TODO title'),
              ),
              TextButton(
                onPressed: () async {
                  selectedTime = await showDatePicker(
                    context: context,
                    initialDate: todo.time ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                },
                child: const Text('Select Date'),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (!mounted) return; // Check if the widget is still mounted
                final provider = Provider.of<TodoProvider>(context, listen: false);
                provider.updateTodo(index, controller.text, selectedTime, todo.isCompleted);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            )
          ],
        );
      },
    );
  }

  List<Todo> _getFilteredTodos(List<Todo> todos) {
    DateTime now = DateTime.now();
    if (filter == 'Today') {
      return todos.where((todo) => todo.time != null &&
          todo.time!.year == now.year &&
          todo.time!.month == now.month &&
          todo.time!.day == now.day).toList();
    } else if (filter == 'Upcoming') {
      return todos.where((todo) => todo.time != null && todo.time!.isAfter(now)).toList();
    }
    return todos;
  }

  Widget _buildFilterButton(String filterName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: filter == filterName ? Colors.blue : Colors.grey,
        ),
        onPressed: () {
          setState(() {
            filter = filterName;
          });
        },
        child: Text(filterName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO List', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _searchTodo(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterButton('All'),
                _buildFilterButton('Today'),
                _buildFilterButton('Upcoming'),
              ],
            ),
          ),
          Expanded(
            child: Consumer<TodoProvider>(
              builder: (context, todoProvider, _) {
                List<Todo> filteredTodos = _getFilteredTodos(todoProvider.todos);
                return ListView.builder(
                  itemCount: filteredTodos.length,
                  itemBuilder: (context, index) {
                    final todo = filteredTodos[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        color: todo.isCompleted ? Colors.grey[300] : Colors.white,
                        child: ListTile(
                          onTap: () => _showEditTodoDialog(context, todo, index),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          tileColor: todo.time?.isBefore(DateTime.now()) == true && !todo.isCompleted 
                              ? Colors.red[50] 
                              : null,
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          subtitle: todo.time != null
                              ? Text(DateFormat('yyyy-MM-dd HH:mm').format(todo.time!))
                              : null,
                          leading: Checkbox(
                            value: todo.isCompleted,
                            onChanged: (_) => todoProvider.markAsCompleted(index),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content: const Text('Are you sure you want to delete this task?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        todoProvider.removeTodo(index);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddTodoDialog(context),
      ),
    );
  }
}
