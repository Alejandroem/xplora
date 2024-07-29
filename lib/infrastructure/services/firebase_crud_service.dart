import 'dart:developer';

import '../../domain/services/crud_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirebaseCrudService<T> implements CrudService<T> {
  final CollectionReference<T> collection;

  FirebaseCrudService(this.collection);

  @override
  Stream<T?> getStream(String id) {
    return collection.doc(id).snapshots().map((snapshot) => snapshot.data());
  }

  @override
  Future<T> create(T entity) async {
    final docRef = await collection.add(entity);
    final snapshot = await docRef.get();
    return snapshot.data()!;
  }

  @override
  Future<T?> read(String id) async {
    final docRef = collection.doc(id);
    final snapshot = await docRef.get();
    return snapshot.exists ? snapshot.data() : null;
  }

  @override
  Future<T> updateOrCreate(T entity, String id) async {
    final docRef = collection.doc(id);
    await docRef.set(entity, SetOptions(merge: true));
    final snapshot = await docRef.get();
    return snapshot.data()!;
  }

  @override
  Future<List<T>> readBy(String field, String value) async {
    final querySnapshot = await collection.where(field, isEqualTo: value).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<T> update(T entity, String id) async {
    final docRef = collection.doc(id);
    //TODO test this
    log('entity: $entity');
    log('entity as Map: ${entity as Map<String, dynamic>}');
    await docRef.update(entity as Map<String, dynamic>);
    final snapshot = await docRef.get();
    return snapshot.data()!;
  }

  @override
  Future<void> delete(String id) async {
    final docRef = collection.doc(id);
    await docRef.delete();
  }

  @override
  Future<List<T>> list() async {
    final querySnapshot = await collection.get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}
