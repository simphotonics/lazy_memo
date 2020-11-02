
# Lazy Variables for Dart

[![Build Status](https://travis-ci.com/simphotonics/lazy_memo.svg?branch=main)](https://travis-ci.com/simphotonics/lazy_memo)


## Introduction

Minimizing CPU and memory usage are two important goals of software optimization.
If sufficient memory is available, costly operations (such as sorting a large list)
can be avoided by storing the result and reusing it as long as the relevant
input (e.g. the unsorted list) has not changed.
The technique of storing the result of function calls
was coined [memoization][memoization].


A different strategy to minimize CPU usage is to delay the initialization of variables.
[Lazy initialization][lazy_initialization] is a common concept and is particularly useful in
event driven scenarios where there is no definite execution path and a certain variable might not be used at all.

The package [`lazy_memo`][lazy_memo] provides the generic class [`Lazy<T>`][Lazy]
which can be used to define cached variables that are initialized by a callback when first accessed.
The class [][] represents a single argument memoized function.


## Usage

To use this library include [`lazy_memo`][lazy_memo] as a dependency in your pubspec.yaml file.
The package uses [null-safety] features and requires Dart SDK version `>=2.10.0`.

### Lazy Variables

1. Lazy variables are declared using the constructor of the generic class [`Lazy<T>`][Lazy].
2. The constructor requires a callback [`CachedObjectFactory`][CachedObjectFactory] that returns an  object of type `T`.
3. To access the cached object, the lazy variable is called like a function (see example below).
4. The optional parameter `updateCache` can be used to request an update of the cached object.
   If `updateCache` is true, the object is re-initialized using the (current version) of the callback [`CachedObjectFactory`][CachedObjectFactory].

```Dart
import 'package:lazy/lazy.dart';

// To run this program navigate to
// the folder 'lazy/example'
// in your terminal and type:
//
// # dart --enable-experiment==non-nullable bin/lazy_example.dart
//
// followed by enter.

void main() {
  print('Running lazy_example.dart.\n');

  final random = Random();
  final mean = 4.0;

  // Generating a random sample following an exponential distribution.
  print('Generating random sample ...');
  final sample = List<double>.generate(
      100, (_) => -mean * log(1.0 - random.nextDouble()));

  // Initializing lazy variables
  final sampleSum = Lazy<double>(
    () => sample.reduce((sum, current) => sum += current),
  );
  final sampleMean =
      Lazy<double>(() => sampleSum(updateCache: true) / sample.length);

  print('Initial value of sampleSum: ${sampleSum()}');
  print('Initial value of sampleMean: ${sampleMean()}\n');

  // Adding outliers
  print('Adding outliers:');
  sample.addAll([100.0, 120.0]);

  print('Updated value of sampleMean: '
      '${sampleMean(updateCache: true)}');
  print('Updated value of sampleSum: ${sampleSum()}');
}
```

#### Dependent Lazy Variables

It is possible to declare dependent lazy variables by using an
expression containing one lazy variable to declare another lazy variable.

In the example above, `sampleMean` depends on `sampleSum` since the callback passed
to the constructor of `sampleMean` references `sampleSum`.

The optional parameter `updateCache` can be used strategically to trigger an
update of cached variables along the
dependency tree.

In the example above, the expression `x(updateCache: true)` is called
every time `sampleMean` is updated. Therefore, an update of `sampleMean` triggers an update of `sampleSum`.

Note: An update of a lazy variable can also be requested by calling the
method: `updateCache()`.

### Memoized - Lazy Functions

Memoized functions maintain a lookup table of previously calculated results. When called, the
function checks if it was called previously with the same set of arguments.
If that is the case it will return a cached result.

Memoizing a function comes at the cost of additional indirections,
higher memory usage, and the complexity of having to maintain a function table.
For this reason, memoization should be only used for
**computationally expensive** functions that are likely to be
called **repeatedly** with the **same** set of **input arguments**.
Examples include: repeatedly accessing statistics of a large
data sample, calculating the factorial of an integer,
repeatedly evaluating higher degree polynomials.

The example below demonstrates how to define the *lazy functions*
`factorial` and `polynomial`. 

```Dart
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
// the folder 'lazy/example'
// in your terminal and type:
//
// # dart --enable-experiment==non-nullable bin/lazy_function_example.dart
//
// followed by enter.
void main() {
  print('Running lazy_function_example.dart.\n');

  // Lazy function

  // Lazy function
  final factorial = LazyFunction<int, int>((x) => _factorial(x));

  print('-------- Factorial ------------');
  print('Calculates and stores the result');
  print('factorial(12) = ${factorial(12)}\n');

  // The current function table
  print('Function table:');
  print(factorial.functionTable);
  print('');

  // Returning a cached result.
  print('Cached result:');
  print('factorial(12) = {factorial(12)}');

  // Lazy function with two arguments
  final polynomial = LazyFunction2(_polynomial);
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
```


## Examples

The source code listed above is available in folder [example].



## Features and bugs

Please file feature requests and bugs at the [issue tracker].

[CachedObjectFactory]: https://pub.dev/documentation/lazy_memo/latest/lazy_memo/CachedObjectFactory.html

[issue tracker]: https://github.com/simphotonics/lazy_memo/issues

[example]: https://github.com/simphotonics/lazy_memo/tree/master/example

[lazy_memo]: https://pub.dev/packages/lazy_memo

[lazy_initialization]: https://en.wikipedia.org/wiki/Lazy_initialization

[memoization]: https://en.wikipedia.org/wiki/Memoization

[null-safety]: https://dart.dev/null-safety

[Lazy]: https://pub.dev/documentation/lazy_memo/latest/lazy_memo/Lazy-class.html
