class ListItemModel {
  String id;
  String name;
  int quantity;
  bool isBought;
  String addedBy;

  ListItemModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.isBought,
    required this.addedBy,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'quantity': quantity,
    'isBought': isBought,
    'addedBy': addedBy,
  };

  factory ListItemModel.fromMap(String id, Map<String, dynamic> map) =>
      ListItemModel(
        id: id,
        name: map['name'],
        quantity: map['quantity'],
        isBought: map['isBought'],
        addedBy: map['addedBy'],
      );

  ListItemModel copyWith({
    String? id,
    String? name,
    int? quantity,
    bool? isBought,
    String? addedBy,
  }) {
    return ListItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      isBought: isBought ?? this.isBought,
      addedBy: addedBy ?? this.addedBy,
    );
  }
}
