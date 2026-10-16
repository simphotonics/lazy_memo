import 'lazy.dart';

// A set of lazy variables
extension type LazyPool<T>._(Set<Lazy<T>> pool) implements Set<Lazy> {
  /// Invalidates the cache of every lazy variable in [pool].
  void invalidateCache() {
    forEach((lazy) => lazy.invalidateCache());
  }

  /// Constructs a pool containing [lazyVariables].
  new(Iterable<Lazy<T>> lazyVariables) : pool = Set.of(lazyVariables);

  /// Constructs an empty pool.
  new empty() : pool = <Lazy<T>>{};
}
