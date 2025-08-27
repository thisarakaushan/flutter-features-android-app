// Packages
import 'package:flutter/material.dart';

// Models
import '../../data/models/list_item_model.dart';

class ListItemCard extends StatelessWidget {
  final ListItemModel item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const ListItemCard({
    required this.item,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(value: item.isBought, onChanged: (_) => onToggle()),
        title: Text(item.name),
        subtitle: Text('Qty: ${item.quantity} | Added by: ${item.addedBy}'),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
