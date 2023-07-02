import 'package:lazy_memo/lazy_memo.dart';

/// Computationally expensive function with a single argument.
int _factorial(int x) => (x == 0 || x == 1) ? 1 : x * _factorial(x - 1);

/// Returns the factorial of a positive integer.
final factorial = MemoizedFunction(
  _factorial,
  functionTable: {8: 40320}, // Optional initial function table.
);

/// Computationally expensive function with two arguments.
int _combinations(int n, int k) {
  if (k > n ~/ 2) {
    return _combinations(n, n - k);
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
/// Then the number of subsets containing k objects is given by combinations(n, k).
/// * combinations(n, n) = 1
/// * combinations(n, k) = combinations(n, n - k)
/// * combinations(n, 0) = 1
final combinations = MemoizedFunction2(_combinations);

// To run this program navigate to
// the root folder of your local copy of 'lazy_memo' and use the command:
//
// # dart example/bin/lazy_function_example.dart
void main() {
  print('Running lazy_function_example.dart.\n');

  print('------------- Factorial --------------');
  print('Calculates and stores the result');
  print('factorial(12) = ${factorial(49)}\n');

  // The current function table
  print('Function table:');
  print(factorial.functionTable);
  print('');

  // Returning a cached result.
  print('Cached result:');
  print('factorial(12) = ${factorial(12)}');

  print('\n----- k-combinations of n objects -----');

  print('Calculates and stores the result of: ');
  print('combinations(10, 5): ${combinations(100, 70)}');
  print('');

  print('The current function table');
  print(combinations.functionTable);
  print('');

  print('Returns a cached result.');
  print('combinations(10, 5): ${combinations(10, 5)}');
}
