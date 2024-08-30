import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/services/crud_service.dart';

abstract class FirebaseCrudService<T> implements CrudService<T> {
  final CollectionReference<T> collection;

  FirebaseCrudService(this.collection);

  @override
  Stream<T?> getStream(String id) {
    return collection.doc(id).snapshots().map((snapshot) => snapshot.data());
  }

  dynamic serialize(dynamic obj) {
    if (obj == null) {
      return null;
    } else if (obj is Map) {
      // Serialize each value in the map and ensure the key is a String
      return obj
          .map((key, value) => MapEntry(key.toString(), serialize(value)));
    } else if (obj is List) {
      // Serialize each item in the list
      return obj.map((item) => serialize(item)).toList();
    } else if (obj is Enum) {
      // Convert enum to string
      return obj.toString().split('.').last;
    } else if (obj is JsonSerializable) {
      // If object has a toJson method, use it
      return serialize(obj.toJson());
    } else if (obj is DateTime) {
      // Serialize DateTime to ISO string
      return obj.toIso8601String();
    } else if (obj is num || obj is String || obj is bool) {
      // Return primitive types as is
      return obj;
    } else if (obj is Object) {
      // Fallback: Serialize any object with a toJson method if available
      try {
        final json = (obj as dynamic).toJson();
        return serialize(json);
      } catch (e) {
        throw Exception('Unsupported type: ${obj.runtimeType}');
      }
    } else {
      // If it's not serializable, return null or throw an error
      throw Exception('Unsupported type: ${obj.runtimeType}');
    }
  }

  @override
  Future<T> create(T entity) async {
    final regularCollectionRef = FirebaseFirestore.instance.collection(
      collection.path,
    );

    // Ensure the entity can be serialized properly
    final data = serialize(entity);

    // Add the serialized data to Firestore
    final snapshot = await regularCollectionRef.add(data);

    // Update the document with the generated ID
    final docRef = collection.doc(snapshot.id);
    await docRef.update({'id': docRef.id});

    // Retrieve the updated document
    final updatedSnapshot = await docRef.get();

    // Deserialize the data back to T
    return updatedSnapshot.data()! as T;
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
    docRef.set(entity, SetOptions(merge: true));
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

  Query<T> getQueryFromFilters(List<Map<String, dynamic>> filters) {
    var query = collection.where('id', isNotEqualTo: null);

    for (final filter in filters) {
      final field = filter['field'];
      final operatorString = filter['operator'];
      final value = filter['value'];
      switch (operatorString) {
        case '==':
          query = query.where(field, isEqualTo: value);
          break;
        case '!=':
          query = query.where(field, isNotEqualTo: value);
          break;
        case 'in':
          query = query.where(field, whereIn: value);
          break;
        case 'unset':
          query = query.where(field, isNull: true);
          break;
      }
    }
    return query;
  }

  @override
  Future<List<T>?> readByFilters(List<Map<String, dynamic>> filters) async {
    final query = getQueryFromFilters(filters);
    final querySnapshot = await query.get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Stream<List<T>?> streamByFilters(List<Map<String, dynamic>> filters) {
    return getQueryFromFilters(filters).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Stream<T?> singleReadBy(String field, String value) {
    return collection
        .where(field, isEqualTo: value)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      return snapshot.docs.first.data();
    });
  }

  @override
  Stream<List<T>> listenBy(String field, String value) {
    return collection
        .where(field, isEqualTo: value)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
