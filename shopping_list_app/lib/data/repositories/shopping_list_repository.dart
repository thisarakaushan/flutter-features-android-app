// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// Models
import '../models/shopping_list_model.dart';

// Services
import '../../core/services/firebase_service.dart';

class ShoppingListRepository {
  final CollectionReference _listsCollection = FirebaseService.firestore
      .collection('lists');

  Future<String> createList(ShoppingListModel list) async {
    try {
      String id = Uuid().v4();
      await _listsCollection.doc(id).set(list.toMap());
      return id;
    } catch (e) {
      throw Exception('Failed to create list: $e');
    }
  }

  Stream<List<ShoppingListModel>> getUserLists(String userId) {
    try {
      return _listsCollection
          .where('members', arrayContains: userId)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map(
                  (doc) => ShoppingListModel.fromMap(
                    doc.id,
                    doc.data() as Map<String, dynamic>,
                  ),
                )
                .toList(),
          );
    } catch (e) {
      throw Exception('Failed to fetch lists: $e');
    }
  }

  Future<ShoppingListModel?> getListByCode(String code) async {
    try {
      QuerySnapshot snapshot = await _listsCollection
          .where('code', isEqualTo: code)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return ShoppingListModel.fromMap(
          snapshot.docs.first.id,
          snapshot.docs.first.data() as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch list: $e');
    }
  }

  Future<void> joinList(String listId, String userId) async {
    try {
      await _listsCollection.doc(listId).update({
        'members': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      throw Exception('Failed to join list: $e');
    }
  }

  Future<void> deleteList(String listId) async {
    try {
      await _listsCollection.doc(listId).delete();
    } catch (e) {
      throw Exception('Failed to delete list: $e');
    }
  }
}
