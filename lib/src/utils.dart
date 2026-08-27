import 'memoized_function.dart';

/// Returns the factorial of [x]. Throws an [ArgumentError] if x < 0.
BigInt _factorial(BigInt x) {
  if (x == BigInt.zero || x == BigInt.one) {
    return BigInt.one;
  } else if (x > BigInt.zero) {
    return x * factorial(x - BigInt.one);
  } else {
    throw ArgumentError('Not defined for negative values: Found: x = $x.');
  }
}

/// ```Dart
/// factorial(BigInt x)
/// ```
/// * Returns the factorial of a positive integer `x` of type [BigInt].
/// * Throws an error of type
///   [ArgumentError] if a negative argument is provided.
/// * To easily convert an [int] to [BigInt] use the getter [ToBigInt.big].
final factorial = MemoizedSingleArgumentFunction(_factorial);

extension ToBigInt on int {
  /// Converts the integer to [BigInt].
  BigInt get big => BigInt.from(this);
}

/// Returns the number of k-combination of n distinct objects.
BigInt _combinations(BigInt n, BigInt k) {
  if (n < BigInt.zero) {
    throw ArgumentError('Arguments must be positive. Found n = $n.');
  }

  if (k < BigInt.zero) {
    throw ArgumentError('Argument must be positive. Found k = $k.');
  }

  if (n < k) {
    throw ArgumentError('combinations($n, k) requires k <= $n. Found k = $k.');
  }

  if (k > n ~/ BigInt.two) {
    return combinations(n, n - k);
  } else if (true) {
    var result = BigInt.one;
    var m = BigInt.one;
    for (var i = n; i > n - k; i = i - BigInt.one) {
      result = (result * i) ~/ m;
      m = m + BigInt.one;
    }
    return result;
  }
}

/// ```Dart
/// combinations(BigInt n, BigInt k)
/// ```
/// Returns the number of k-combinations of n distinct objects as a [BigInt].
///
/// More formally,
/// let S be a set containing n distinct objects.
/// Then the number of subsets containing k objects is given by:
/// * combinations(n, n) = 1
/// * combinations(n, k) = combinations(n, n - k)
/// * combinations(n, 0) = 1
/// * Throws an error of type [ArgumentError] if a negative argument is provided
///   or if n < k.
final combinations = MemoizedDoubleArgumentFunction(_combinations);
