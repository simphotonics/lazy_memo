# 0.2.3
- Updated dependencies.

# 0.2.2
- Removed variable `_cacheView`. Amended `lazy_benchmark.dart`.

# 0.2.1
- Fixed `LazyList`, `LazySet`, and `LazyMap`. The call method now returns
the same object until an update of the cache is requested.

## 0.2.0
- Amended doc section lazy collections.

## 0.1.9

- Added utility methods: `factorial` and `combinations`.
- Added extension on int: `ToBigInt`.
- Added benchmarks.


## 0.1.8

- Added benchmark. Set min. SDK version to 3.0.0.
- Updated example and docs (memoized functions).

## 0.1.7

- Updated links.

## 0.1.6

- Updated examples and docs. Added getters returning the argument type,
  return type, and function signature of memoized functions.

## 0.1.5

- Added parameter `functionTable` to constructors of `MemoizedFunction`
  and `MemoizedFunction2`.

## 0.1.4

- Update docs.

## 0.1.3

- Updated dependencies.

## 0.1.2

- Migrated CI to github.

## 0.1.1

- Added the classes `LazyList<T>`, `LazyMap<K, V>`, `LazySet<T>`.
  These return a copy of the cached object to prevent external modification
  of the cache.

## 0.1.0

- Removed ref. to experiment non-nullable. Set min. SDK version 2.12.0.
- Switched back to default testing suite.

## 0.1.0-nullsafety

- Set min. Dart SDK version 2.12.0-0.

## 0.0.3-nullsafety

- Added class `MemoizedFunction`, representing a single-argument memoized function.

## 0.0.2-nullsafety

- Added getter `isUpToDate`.

## 0.0.1-nullsafety

- Initial version.
- Requires Dart SDK version >= 2.10.0.
- Null-safety must be enabled (see `analysis_options.yaml`).
