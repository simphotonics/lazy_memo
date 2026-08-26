import 'package:lazy_memo/lazy_memo.dart';

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
final factorial = MemoizedSingleArgumentFunction(
  _factorial,
  functionTable: {12.big: 479001600.big},
);

void main() {
  print('Running memoized_function_example.dart.\n');

  print('------------- Factorial --------------');
  print('Calculates and stores the result');
  print('factorial(49) = ${factorial(49.big)}\n');

  // The current function table
  print('Function table:');
  print(factorial.functionTable);
  print('');

  // Returning a cached result.
  print('Cached result:');
  print('factorial(12) = ${factorial(12.big)}');
}
