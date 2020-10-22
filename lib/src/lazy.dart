/// Callback used to lazily create an object of type `T`.
typedef CachedObjectFactory<T> = T Function();

/// A class that caches an object of type `T`.
/// * The cache is populated when the object is first accessed.
class Lazy<T> {
  /// Constructs a lazy object.
  Lazy(this.objectFactory);

  /// Callback used to create the cached object.
  final CachedObjectFactory<T> objectFactory;

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
