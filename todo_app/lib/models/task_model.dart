class Task {
  final String id;
  final String title;
  final String description;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isDone = false,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }

  // Create from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isDone: json['isDone'],
    );
  }

  // Create a copy with modifications
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isDone,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }
}
