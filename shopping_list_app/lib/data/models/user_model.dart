class UserModel {
  String id;
  String email;
  String username;

  UserModel({required this.id, required this.email, required this.username});

  Map<String, dynamic> toMap() => {
    'id': id,
    'email': email,
    'username': username,
  };

  factory UserModel.fromMap(Map<String, dynamic> map) =>
      UserModel(id: map['id'], email: map['email'], username: map['username']);
}
