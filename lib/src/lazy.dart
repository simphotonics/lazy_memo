/// Callback used to lazily create an object of type [T].
typedef ObjectFactory<T> = T Function();

/// A class that caches an object of type [T].
/// The cache is populated when the object is first accessed.
class Lazy<T>(
  /// Callback used to create the cached object.
  final ObjectFactory<T> objectFactory,
) {
  /// The cached object.
  T? _cache;

  /// Returns `true` if the cache was not yet initialized or if
  /// the cache was marked stale by calling [invalidateCache].
  bool get isStale => _cache == null;

  /// The cached value of the lazy object.
  T get value {
    if (_cache == null) {
      return _cache = objectFactory();
    } else {
      return _cache!;
    }
  }

  /// Returns the cached object.
  /// * The object is initialized when first accessed.
  /// * To re-initialize the cached object use the
  ///   optional parameter [updateCache].
  T call({bool updateCache = false}) {
    if (updateCache) return _cache = objectFactory();
    return value;
  }

  /// Marks the cache as stale. After calling this function the
  /// cached object will be
  /// (lazily) re-initialized when next accessed.
  void invalidateCache() {
    _cache = null;
  }

  @override
  String toString() {
    // Note: _cache might not be initialized yet.
    return '$runtimeType: \n  $value}';
  }

  /// Creates an error message and returns an [UnsupportedError].
  UnsupportedError unsupportedError() => UnsupportedError(
    'Cannot modify a $runtimeType. \n '
    '                      The cached object of type \'$T\' is unmodifiable.',
  );
}
