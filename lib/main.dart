import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_provider.dart';
import 'todo_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: MaterialApp(
        title: 'TODO List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[200],
        ),
        home: const TodoScreen(),
      ),
    );
  }
}