/// A function requiring a single argument of type `A` and
/// returning an object of type `T`.
typedef SingleArgumentFunction<A, T> = T Function(A arg);

/// A function requiring arguments of type `A1, A2` and
/// returning an object of type `T`.
typedef DoubleArgumentFunction<A1, A2, T> = T Function(A1 arg1, A2 arg2);

/// Class representing a memoized function
/// requiring a single argument of type `A`
/// and returning an object of type `T`.
///
class MemoizedFunction<A, T> {
  /// Constructor:
  /// The parameter `functionTable` may be used to
  /// initialize the function lookup table with certain
  /// {function argument: function value pairs}.
  MemoizedFunction(this.func, {Map<A, T> functionTable = const {}}) {
    if (functionTable.isNotEmpty) {
      _functionTable.addAll(functionTable);
    }
  }

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
      for (var key in args) {
        _functionTable.remove(key);
      }
    }
  }

  /// Returns a copy of the current function table.
  Map<A, T> get functionTable => Map<A, T>.from(_functionTable);
}

/// Class representing a memoized function requiring arguments of type
/// `A1` and `A2`, respectively, and returning an object of type `T`.
class MemoizedFunction2<A1, A2, T> {
  /// Constructor:
  /// The parameter `functionTable` may be used to
  /// initialize the function lookup table with certain
  /// {function argument1: {function argument 2: function value pairs} }
  /// entries.
  MemoizedFunction2(this.func, {Map<A1, Map<A2, T>> functionTable = const {}}) {
    if (functionTable.isNotEmpty) {
      _functionTable.addAll(functionTable);
    }
  }

  /// The memoized function.
  final DoubleArgumentFunction<A1, A2, T> func;

  /// Function table
  final _functionTable = <A1, Map<A2, T>>{};

  /// Returns the result of calling `func` or a cached result if available.
  /// * The cache is initialized when first accessed.
  /// * To re-initialize the cached function result use the
  ///   optional parameter `recalculate`.
  T call(
    A1 arg1,
    A2 arg2, {
    bool recalculate = false,
  }) {
    if (recalculate) {
      _functionTable[arg1] = {arg2: func(arg1, arg2)};
      return _functionTable[arg1]![arg2]!;
    } else {
      if (_functionTable.containsKey(arg1)) {
        return _functionTable[arg1]![arg2] ??= func(arg1, arg2);
      } else {
        _functionTable[arg1] = {arg2: func(arg1, arg2)};
        return _functionTable[arg1]![arg2]!;
      }
    }
  }

  /// Returns a copy of the current function table.
  Map<A1, Map<A2, T>> get functionTable =>
      Map<A1, Map<A2, T>>.from(_functionTable);

  /// Clears the cached function table.
  void clearFunctionTable() {
    _functionTable.clear();
  }
}
