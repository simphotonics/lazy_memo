import 'dart:collection' show ListMixin;

import 'lazy.dart';

/// A lazy variable that caches a list with entries of type [T].
class LazyList<T>(ObjectFactory<List<T>> objectFactory)
    extends Lazy<List<T>>
    with ListMixin<T> {
  this : super(() => List.unmodifiableOf(objectFactory()));

  // /// Returns the first element of the cached list.
  // @override
  // T get first {
  //   if (_isStale) refreshCache();
  //   return _cache.first;
  // }

  // /// Returns the last element of the cached list.
  // @override
  // T get last {
  //   if (_isStale) refreshCache();
  //   return _cache.last;
  // }

  /// Returns the element with index [i].
  @override
  T operator [](int i) => value[i];

  /// Cannot modify the cached list object of a [LazyList].
  ///
  /// Throws an [UnsupportedError].
  @override
  void operator []=(int index, value) {
    throw unsupportedError();
  }

  /// Cannot modify the cached list object of a [LazyList].
  ///
  /// Throws an [UnsupportedError].
  @override
  set length(int newLength) {
    throw unsupportedError();
  }

  /// Returns the length of the cached list object.
  @override
  int get length => value.length;
}
