/// A function taking a single argument of type `A` and
/// returning an object of type `T`.
typedef SingleArgumentFunction<A, T> = T Function(A arg);

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

/// Class representing a memoized function
/// requiring a single argument of type `A`
/// and returning an object of type `T`.
///
/// The parameter `functionTable` may be used to
/// initialize the function lookup table with certain
/// function argument: function value pairs.
class LazyFunction<A, T> {
  LazyFunction(this.func);

  /// Function being memoized.
  final SingleArgumentFunction<A, T> func;

  /// Function table.
  final _functionTable = <A, T>{};

  /// Returns the result of calling `func` or a cached result if available.
  /// * The cache is initialized when first accessed.
  /// * To re-initialize the cached function result use the
  ///   optional parameter `recalculate`.
  T call(
    A arg, {
    bool recalculate = false,
  }) {
    if (recalculate) {
      return _functionTable[arg] = func(arg);
    } else {
      return _functionTable[arg] ??= func(arg);
    }
  }

  /// Clears the cached function table.
  ///
  /// To clear the function table for selected values only,
  /// provide a non-empty iterable `args`.
  void clearFunctionTable({Iterable<A>? args}) {
    if (args == null) {
      _functionTable.clear();
    } else {
      args.forEach((key) => _functionTable.remove(key));
    }
  }

  /// Returns a copy of the current function table.
  Map<A, T> get functionTable => Map<A, T>.from(_functionTable);
}
