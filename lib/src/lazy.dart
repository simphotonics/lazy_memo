import 'dart:collection';

/// Callback used to lazily create an object of type `T`.
typedef ObjectFactory<T> = T Function();

/// A class that caches an object of type `T`.
/// The cache is populated when the object is first accessed.
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

  /// After calling this function the cached object will be
  /// (lazily) re-initialized when it is next accessed.
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
/// * An unmodifiable list view is returned to prevent modification of the cache.
/// * The same object is returned until an update of the cache is requested by
/// calling the method `updateCache()` or using the optional parameter
/// `updateCache: true` to access the cached variable.
class LazyList<T> extends Lazy<List<T>> {
  /// Constructs an object of type `LazyList<T>`.
  LazyList(super.objectFactory);

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
      _cacheView = UnmodifiableListView(_cache);
    }
    return _cacheView;
  }

  late UnmodifiableListView<T> _cacheView;

  @override
  String toString() {
    return 'LazyList<$T>: ${call()}';
  }
}

/// A lazy variable that caches a set with entries of type `T`.
///
/// * An unmodifiable set view is returned to prevent modification of the cache.
/// * The same object is returned until an update of the cache is requested by
/// calling the method `updateCache()` or using the optional parameter
/// `updateCache: true` to access the cached variable.
class LazySet<T> extends Lazy<Set<T>> {
  /// Constructs an object of type `LazySet<T>`.
  LazySet(super.objectFactory);

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
      _cacheView = UnmodifiableSetView(_cache);
    }
    return _cacheView;
  }

  late UnmodifiableSetView<T> _cacheView;

  @override
  String toString() {
    return 'LazySet<$T>: ${call()}';
  }
}

/// A lazy variable that caches a map of type `Map<K, V>`.
///
/// * An unmodifiable map view is returned to prevent modification of the cache.
/// * The same object is returned until an update of the cache is requested by
/// calling the method `updateCache()` or using the optional parameter
/// `updateCache: true` to access the cached variable.
class LazyMap<K, V> extends Lazy<Map<K, V>> {
  /// Constructs an object of type `LazyMap<T>`.
  LazyMap(super.objectFactory);

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
      _cacheView = UnmodifiableMapView(_cache);
    }
    return _cacheView;
  }

  late UnmodifiableMapView<K, V> _cacheView;

  @override
  String toString() {
    return 'LazyMap<K, V>: ${call()}';
  }
}
