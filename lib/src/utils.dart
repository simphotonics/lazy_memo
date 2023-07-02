import 'memoized_functions.dart';

/// Computationally expensive function with a single argument.
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

/// Returns the number of k-combination of n distinct objects.
int _c(int n, int k) {
  if (n < 0) {
    throw ArgumentError.value(n, 'n', 'Arguments must be positive.');
  }

  if (k < 0) {
    throw ArgumentError.value(k, 'k', 'Argument must be positive.');
  }

  if (n < k) {
    throw ArgumentError.value(
        k,
        'k',
        'combinations($n, k) requires k <= $n. '
            'Found k');
  }

  if (k > n ~/ 2) {
    return _c(n, n - k);
  } else if (k > n) {
    return 0;
  } else {
    int result = 1;
    int m = 1;
    for (var i = n; i > n - k; i--) {
      result = (result * i) ~/ m;
      m++;
    }
    return result;
  }
}

/// Returns the number of k-combinations of n distinct objects. More formally,
/// let S be a set containing n distinct objects.
/// Then the number of subsets containing k objects is given by c(n, k).
/// * c(n, n) = 1
/// * c(n, k) = c(n, n - k)
/// * c(n, 0) = 1
/// Throws an error of type [ArgumentError] if a negative argument is provided.
final combinations = MemoizedFunction2(_c);
