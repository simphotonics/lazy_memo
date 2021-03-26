# 0.1.2

Migrated CI to github.

# 0.1.1

- Added the classes `LazyList<T>`, `LazyMap<K, V>`, `LazySet<T>`.
  These return a copy of the cached object to prevent external modification
  of the cache.

# 0.1.0

- Removed ref. to experiment non-nullable. Set min. SDK version 2.12.0.
- Switched back to default testing suite.

# 0.1.0-nullsafety

- Set min. Dart SDK version 2.12.0-0.

# 0.0.3-nullsafety

- Added class `MemoizedFunction`, representing a single-argument memoized function.

# 0.0.2-nullsafety

- Added getter `isUpToDate`.

## 0.0.1-nullsafety

- Initial version.
- Requires Dart SDK version >= 2.10.0.
- Null-safety must be enabled (see `analysis_options.yaml`).
