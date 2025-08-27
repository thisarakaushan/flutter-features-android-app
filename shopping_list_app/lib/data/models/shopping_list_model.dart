class ShoppingListModel {
  String id;
  String title;
  String? description;
  String code;
  List<String> members;

  ShoppingListModel({
    required this.id,
    required this.title,
    this.description,
    required this.code,
    required this.members,
  });

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'code': code,
    'members': members,
  };

  factory ShoppingListModel.fromMap(String id, Map<String, dynamic> map) =>
      ShoppingListModel(
        id: id,
        title: map['title'],
        description: map['description'],
        code: map['code'],
        members: List<String>.from(map['members']),
      );
}
