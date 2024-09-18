import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseService<T> {
  final CollectionReference<T> ref;

  BaseService({required this.ref});

  Future<void> addDocument(T data, String id) async {
    await ref.doc(id).set(data, SetOptions(merge: true));
  }

  Future<void> updateDocument(String id, T data) async {
    await ref.doc(id).set(data, SetOptions(merge: true));
  }

  Future<void> deleteDocument(String id) async {
    await ref.doc(id).delete();
  }

  Stream<List<T>> getDocuments() {
    return ref
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<T?> getDocumentById(String id) async {
    DocumentSnapshot<T> doc = await ref.doc(id).get();
    return doc.data();
  }
}
