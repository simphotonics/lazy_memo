import 'memoized_functions.dart';

BigInt _factorial(BigInt x) {
  if (x == BigInt.zero || x == BigInt.one) {
    return BigInt.one;
  } else if (x > BigInt.zero) {
    return x * _factorial(x - BigInt.one);
  } else {
    throw ArgumentError.value(x, 'x', 'Not defined for negative values!');
  }
}

/// Returns the factorial of a positive integer. Throws and error of type
/// [ArgumentError] if a negative argument is provided.
final factorial = MemoizedFunction(_factorial);

extension ToBigInt on int {
  /// Converts this to [BigInt].
  BigInt get big => BigInt.from(this);
}

/// Returns the number of k-combination of n distinct objects.
BigInt _combinations(BigInt n, BigInt k) {
  if (n < BigInt.zero) {
    throw ArgumentError.value(n, 'n', 'Arguments must be positive.');
  }

  if (k < BigInt.zero) {
    throw ArgumentError.value(k, 'k', 'Argument must be positive.');
  }

  if (n < k) {
    throw ArgumentError.value(
        k,
        'k',
        'combinations($n, k) requires k <= $n. '
            'Found k');
  }

  if (k > n ~/ BigInt.two) {
    return _combinations(n, n - k);
  } else {
    var result = BigInt.one;
    var m = BigInt.one;
    for (var i = n; i > n - k; i = i - BigInt.one) {
      result = (result * i) ~/ m;
      m = m + BigInt.one;
    }
    return result;
  }
}

/// Returns the number of k-combinations of n distinct objects. More formally,
/// let S be a set containing n distinct objects.
/// Then the number of subsets containing k objects is given by
/// combinations(n, k).
/// * combinations(n, n) = 1
/// * combinations(n, k) = combinations(n, n - k)
/// * combinations(n, 0) = 1
/// Throws an error of type [ArgumentError] if a negative argument is provided
/// or if n < k.
final combinations = MemoizedFunction2(_combinations);
