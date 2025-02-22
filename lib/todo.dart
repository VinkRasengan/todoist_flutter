class Todo {
  String title;
  DateTime? time;
  bool isCompleted;

  Todo({required this.title, this.time, this.isCompleted = false});
}