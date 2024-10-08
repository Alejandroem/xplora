abstract class CrudService<T> {
  Stream<T?> getStream(String id);
  Future<T> create(T entity);
  Future<T?> read(String id);
  Future<T> updateOrCreate(T entity, String id);
  Future<List<T>> readBy(String field, String value);
  Stream<T?> singleReadBy(String field, String value);
  Stream<List<T>> listenBy(String field, String value);
  Future<T> update(T entity, String id);
  Future<void> delete(String id);
  Future<List<T>> list();
  Future<List<T>?> readByFilters(List<Map<String, dynamic>> filters);
  Stream<List<T>?> streamByFilters(List<Map<String, dynamic>> filters);
}
