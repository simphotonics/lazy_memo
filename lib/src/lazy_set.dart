import 'dart:collection' show SetMixin;

import 'lazy.dart';

/// A lazy variable that caches a set with entries of type [T].
///
/// * An unmodifiable set view is returned to prevent modification of the cache.
/// * The same object is returned until an update of the cache is requested by
/// calling the method [invalidateCache] or using the optional parameter
/// [invalidateCache] : true to access the cached variable.
class LazySet<T>(ObjectFactory<Set<T>> objectFactory)
    extends Lazy<Set<T>>
    with SetMixin<T> {
  /// Constructs an object of type [LazySet] with type argument [T].
  this : super(() => Set.unmodifiable(objectFactory()));

  /// Cannot modify the cached object of type [Set].
  ///
  /// Throw and [UnsupportedError],
  @override
  bool add(value) {
    throw unsupportedError();
  }

  /// Returns `true` if the cached set contains [element].
  @override
  bool contains(Object? element) => value.contains(element);

  /// Returns the iterator of the cached set.
  @override
  Iterator<T> get iterator => value.iterator;

  /// Returns the length of the cached set.
  @override
  int get length => value.length;

  /// If [element] is equal to an object in the cached set it is returned.
  /// Returns `null` otherwise.
  @override
  T? lookup(Object? element) => value.lookup(element);

  /// Cannot modify the cached object of type [Set].
  ///
  /// Throw and [UnsupportedError],
  @override
  bool remove(Object? value) {
    throw unsupportedError();
  }

  /// Creates a [Set] with the same elements as [value].
  @override
  Set<T> toSet() => value.toSet();
}
