import 'dart:collection';

/// A generic function with type argument [T] and
/// and return type [R].
typedef GenericFunction<R> = R Function<T>();

/// A function requiring a single argument of type [A] and
/// returning an object of type [R].
typedef SingleArgumentFunction<R, A> = R Function(A arg);

/// A function requiring arguments of type `A1, A2` and
/// returning an object of type [R].
typedef DoubleArgumentFunction<R, A1, A2> = R Function(A1 arg1, A2 arg2);

/// Class representing a generic memoized function
/// with *one* type parameter [T], no arguments and return type [R].
class GenericMemoizedFunction<R> {
  /// Constructs a instance of [GenericMemoizedFunction].
  /// * [func]: A function with signature: `R Function<T>()`.
  /// * [functionTable]: May be used to
  ///   initialize the function lookup table with
  ///   {type: function value pairs}.
  new(this.func, {Map<Type, R> functionTable = const {}}) {
    if (functionTable.isNotEmpty) {
      _functionTable.addAll(functionTable);
    }
  }

  /// Returns the function return type [R].
  Type get returnType => R;

  /// Returns the typedef of the memoized function.
  Type get signature => GenericFunction<R>;

  /// Function being memoized.
  final GenericFunction<R> func;

  /// Function table.
  final _functionTable = <Type, R>{};

  /// Returns the result of calling `func<T>()` or a cached result if available.
  /// * The cache is initialized when first accessed.
  /// * To re-initialize the cached function result use the
  ///   optional parameter `recalculate`.
  R call<T>({bool recalculate = false}) {
    if (recalculate) {
      return _functionTable[T] = func<T>();
    } else {
      if (_functionTable.containsKey(T)) {
        return _functionTable[T]!;
      } else {
        return _functionTable[T] = func<T>();
      }
    }
  }

  /// Clears the cached function table.
  ///
  /// To clear the function table for selected values only,
  /// provide a non-empty iterable `args`.
  void clearFunctionTable({Iterable<Type>? args}) {
    if (args == null) {
      _functionTable.clear();
    } else {
      for (var key in args) {
        _functionTable.remove(key);
      }
    }
  }

  /// Returns an [UnmodifiableMapView] of the current function table.
  UnmodifiableMapView<Type, R> get functionTable =>
      UnmodifiableMapView(_functionTable);
}

/// Class representing a memoized function
/// with return type [R] and argument type [A].
class MemoizedSingleArgumentFunction<R, A> {
  /// Constructs a instance of [MemoizedSingleArgumentFunction].
  /// * [func]: A function with signature: `R Function(A)`.
  /// * [functionTable]: May be used to
  ///   initialize the function lookup table with
  ///   {function argument: function value pairs}.
  new(this.func, {Map<A, R> functionTable = const {}})
    : _functionTable = Map.of(functionTable);

  /// Returns the function argument type [A].
  Type get argumentType => A;

  /// Returns the function return type [R].
  Type get returnType => R;

  /// Returns the typedef of the memoized function.
  Type get signature => SingleArgumentFunction<R, A>;

  /// Function being memoized.
  final SingleArgumentFunction<R, A> func;

  /// Function table.
  final Map<A, R> _functionTable;

  /// Returns the result of calling `func` or a cached result if it
  /// is  available.
  /// * The cache is initialized when first accessed.
  /// * To re-initialize the cached function result use the
  ///   optional parameter `recalculate`.
  R call(A arg, {bool recalculate = false}) {
    if (recalculate) {
      return _functionTable[arg] = func(arg);
    } else {
      if (_functionTable.containsKey(arg)) {
        return _functionTable[arg]!;
      } else {
        return _functionTable[arg] = func(arg);
      }
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
      for (var key in args) {
        _functionTable.remove(key);
      }
    }
  }

  /// Returns an [UnmodifiableMapView] of the current function table.
  UnmodifiableMapView<A, R> get functionTable =>
      UnmodifiableMapView(_functionTable);
}

typedef ArgumentPair<A1, A2> = (A1, A2);

/// Class representing a memoized function requiring arguments of type
/// [A1] and [A2], respectively, and returning an object of type [R].
class MemoizedDoubleArgumentFunction<R, A1, A2> {
  /// Constructor:
  /// The parameter `functionTable` may be used to
  /// initialize the function lookup table with certain
  /// {function argument1: {function argument 2: function value pairs} }
  /// entries.
  new(this.func, {Map<ArgumentPair<A1, A2>, R> functionTable = const {}})
    : _functionTable = {...functionTable};

  /// The memoized function.
  final DoubleArgumentFunction<R, A1, A2> func;

  /// Function table
  final Map<ArgumentPair<A1, A2>, R> _functionTable;

  /// Returns the function argument types `[A1, A2]`.
  List<Type> get argumentTypes => [A1, A2];

  /// Returns the function return type [R].
  Type get returnType => R;

  /// Returns the signature of the memoized function.
  Type get signature => DoubleArgumentFunction<A1, A2, R>;

  /// Returns the result of calling `func` or a cached result if available.
  /// * The cache is initialized when first accessed.
  /// * To re-initialize the cached function result use the
  ///   optional parameter `recalculate`.
  R call(A1 arg1, A2 arg2, {bool recalculate = false}) {
    if (recalculate) {
      return _functionTable[(arg1, arg2)] = func(arg1, arg2);
    } else {
      if (_functionTable.containsKey((arg1, arg2))) {
        return _functionTable[(arg1, arg2)]!;
      } else {
        return _functionTable[(arg1, arg2)] = func(arg1, arg2);
      }
    }
  }

  /// Returns an [UnmodifiableMapView] of the current function table.
  UnmodifiableMapView<(A1, A2), R> get functionTable =>
      UnmodifiableMapView(_functionTable);

  /// Clears the cached function table.
  void clearFunctionTable() {
    _functionTable.clear();
  }
}
