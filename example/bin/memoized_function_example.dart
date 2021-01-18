import 'package:lazy_memo/lazy_memo.dart';

// Computationally expensive function:
int _factorial(int x) => (x == 0 || x == 1) ? 1 : x * _factorial(x - 1);

/// Returns the value of the polynomial:
/// `c.first + c[1]*x + ... + c.last* pow(x, c.length)`,
/// where the entries of `c` represent the polynomial coefficients.
num _polynomial(num x, Iterable<num> c) {
  if (c.isEmpty) {
    return 0;
  } else if (c.length == 1) {
    return c.first;
  } else {
    return c.first + x * _polynomial(x, c.skip(1));
  }
}

// To run this program navigate to
// the root folder of your local copy of 'lazy_memo' and use the command:
//
// # dart example/bin/lazy_function_example.dart
void main() {
  print('Running lazy_function_example.dart.\n');

  // Memoized function

  // Memoized function
  final factorial = MemoizedFunction<int, int>((x) => _factorial(x));

  print('-------- Factorial ------------');
  print('Calculates and stores the result');
  print('factorial(12) = ${factorial(12)}\n');

  // The current function table
  print('Function table:');
  print(factorial.functionTable);
  print('');

  // Returning a cached result.
  print('Cached result:');
  print('factorial(12) = ${factorial(12)}');

  // Memoized function with two arguments
  final polynomial = MemoizedFunction2(_polynomial);
  print('\n-------- Polynomial ------------');
  print('Calculates and stores the result of: ');

  print('polynomial(2, [2, -9, 10, 11, 15]): ${polynomial(2, [
    2,
    -9,
    10,
    11,
    15
  ])}');
  print('');

  print('The current function table');
  print(polynomial.functionTable);
  print('');

  print('Returns a cached result.');
  print(polynomial(2, [2, -9, 10, 11, 15]));
}
