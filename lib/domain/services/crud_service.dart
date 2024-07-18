abstract class CrudService<T> {
  Future<T> create(T entity);
  Future<T?> read(String id);
  Future<T> updateOrCreate(T entity, String id);
  Future<List<T>> readBy(String field, String value);
  Future<T> update(T entity, String id);
  Future<void> delete(String id);
  Future<List<T>> list();
}

