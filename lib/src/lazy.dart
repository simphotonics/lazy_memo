/// Callback used to lazily create an object of type `T`.
typedef ObjectFactory<T> = T Function();

/// A class that caches an object of type `T`.
/// * The cache is populated when the object is first accessed.
class Lazy<T> {
  /// Constructs a lazy object.
  Lazy(this.objectFactory);

  /// Callback used to create the cached object.
  final ObjectFactory<T> objectFactory;

  late T _cache;
  bool _isUpToDate = false;

  /// Returns the cached object.
  /// * The object is initialized when first accessed.
  /// * To re-initialize the cached object use the
  ///   optional parameter `updateCache`.
  T call({
    bool updateCache = false,
  }) {
    if (updateCache || !_isUpToDate) {
      _isUpToDate = true;
      return _cache = objectFactory();
    } else {
      return _cache;
    }
  }

  /// After calling this function the cached object is
  /// (lazily) re-initialized.
  void updateCache() {
    _isUpToDate = false;
  }

  /// Returns `true` if the cached object has been initialized and is
  /// up-to-date.
  bool get isUpToDate => _isUpToDate;

  @override
  String toString() {
    return 'Lazy<$T>: ${call()}';
  }
}

/// A lazy variable that caches a list with entries of type `T`.
///
/// Note: The only difference between `Lazy<List<T>>` and `LazyList<T>` is
/// that the latter returns a *copy* of the cached list to prevent
/// users from modifying the cache.
class LazyList<T> extends Lazy<List<T>> {
  /// Constructs an object of type `LazyList<T>`.
  LazyList(ObjectFactory<List<T>> objectFactory) : super(objectFactory);

  /// Returns the cached object.
  /// * The object is initialized when first accessed.
  /// * To re-initialize the cached object use the
  ///   optional parameter `updateCache`.
  @override
  List<T> call({
    bool updateCache = false,
  }) {
    if (updateCache || !_isUpToDate) {
      _isUpToDate = true;
      _cache = objectFactory();
    }
    return List<T>.of(_cache);
  }
}

/// A lazy variable that caches a set with entries of type `T`.
///
/// Note: The only difference between `Lazy<Set<T>>` and `LazySet<T>` is
/// that the latter returns a *copy* of the cached set to prevent
/// users from modifying the cache.
class LazySet<T> extends Lazy<Set<T>> {
  /// Constructs an object of type `LazyList<T>`.
  LazySet(ObjectFactory<Set<T>> objectFactory) : super(objectFactory);

  /// Returns the cached object.
  /// * The object is initialized when first accessed.
  /// * To re-initialize the cached object use the
  ///   optional parameter `updateCache`.
  @override
  Set<T> call({
    bool updateCache = false,
  }) {
    if (updateCache || !_isUpToDate) {
      _isUpToDate = true;
      _cache = objectFactory();
    }
    return Set<T>.of(_cache);
  }
}

/// A lazy variable that caches a map of type `Map<K, V>`.
///
/// Note: The only difference between `Lazy<Map<K, V>>` and `LazyMap<K, V>` is
/// that the latter returns a *copy* of the cached map to prevent
/// users from modifying the cache.
class LazyMap<K, V> extends Lazy<Map<K, V>> {
  /// Constructs an object of type `LazyList<T>`.
  LazyMap(ObjectFactory<Map<K, V>> objectFactory) : super(objectFactory);

  /// Returns the cached object.
  /// * The object is initialized when first accessed.
  /// * To re-initialize the cached object use the
  ///   optional parameter `updateCache`.
  @override
  Map<K, V> call({
    bool updateCache = false,
  }) {
    if (updateCache || !_isUpToDate) {
      _isUpToDate = true;
      _cache = objectFactory();
    }
    return Map<K, V>.of(_cache);
  }
}
