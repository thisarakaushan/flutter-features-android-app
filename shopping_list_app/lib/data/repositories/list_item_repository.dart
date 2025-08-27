// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// Models
import '../models/list_item_model.dart';

// Services
import '../../core/services/firebase_service.dart';

class ListItemRepository {
  CollectionReference _getItemsCollection(String listId) => FirebaseService
      .firestore
      .collection('lists')
      .doc(listId)
      .collection('items');

  Future<String> addItem(String listId, ListItemModel item) async {
    try {
      String id = Uuid().v4();
      await _getItemsCollection(listId).doc(id).set(item.toMap());
      return id;
    } catch (e) {
      throw Exception('Failed to add item: $e');
    }
  }

  Stream<List<ListItemModel>> getItems(String listId) {
    try {
      return _getItemsCollection(listId).snapshots().map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => ListItemModel.fromMap(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ),
            )
            .toList(),
      );
    } catch (e) {
      throw Exception('Failed to fetch items: $e');
    }
  }

  Future<void> updateItem(String listId, ListItemModel item) async {
    try {
      await _getItemsCollection(listId).doc(item.id).update(item.toMap());
    } catch (e) {
      throw Exception('Failed to update item: $e');
    }
  }

  Future<void> deleteItem(String listId, String itemId) async {
    try {
      await _getItemsCollection(listId).doc(itemId).delete();
    } catch (e) {
      throw Exception('Failed to delete item: $e');
    }
  }
}
