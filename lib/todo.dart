class Todo {
  String title;
  DateTime? time;
  bool isCompleted;

  Todo({required this.title, this.time, this.isCompleted = false});

  Map<String, dynamic> toJson() => {
    'title': title,
    'time': time?.toIso8601String(),
    'isCompleted': isCompleted,
  };

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    title: json['title'],
    time: json['time'] != null ? DateTime.parse(json['time']) : null,
    isCompleted: json['isCompleted'],
  );
}