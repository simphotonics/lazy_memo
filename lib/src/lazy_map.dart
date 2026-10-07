import 'dart:collection' show MapMixin;

import 'lazy.dart';

/// A lazy variable that caches a map of type `Map<K, V>`.
class LazyMap<K, V>(ObjectFactory<Map<K, V>> objectFactory)
    extends Lazy<Map<K, V>>
    with MapMixin<K, V> {
  this : super(() => Map.unmodifiableOf(objectFactory()));

  /// Returns the map value associated with [key].
  @override
  V? operator [](Object? key) => value[key];

  /// Cannot modify the cached object directly.
  ///
  /// Throws an [UnsupportedError].
  @override
  void operator []=(K key, V value) {
    throw unsupportedError();
  }

  /// The cached map object cannot be cleared.
  ///
  /// Throws an [UnsupportedError].
  @override
  void clear() {
    throw unsupportedError();
  }

  @override
  Iterable<K> get keys => value.keys;

  /// The cached map object cannot be modified.
  ///
  /// Throws an [UnsupportedError].
  @override
  V? remove(Object? key) {
    throw unsupportedError();
  }
}
