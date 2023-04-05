
# Lazy Variables for Dart
[![Dart](https://github.com/simphotonics/lazy_memo/actions/workflows/dart.yml/badge.svg)](https://github.com/simphotonics/lazy_memo/actions/workflows/dart.yml)

## Introduction

Minimizing CPU and memory usage are two important goals of software optimization.
If sufficient memory is available, costly operations (such as sorting a large list)
can be avoided by storing the result and reusing it as long as the relevant
input (e.g. the unsorted list) has not changed.
The technique of storing the result of function calls
was coined [memoization][memoization].


A different strategy to minimize CPU usage is to delay the initialization of variables.
[Lazy initialization][lazy_initialization] is particularly
useful in event driven scenarios where there is no definite execution path and
a certain variable might never be used.

The package [`lazy_memo`][lazy_memo] provides generic classes that can be used
to define [lazy variables](#1-lazy-variables) and
[memoized functions](#4-memoized-functions).


## Usage

To use this library include [`lazy_memo`][lazy_memo] as a dependency in your pubspec.yaml file.
<br>

### 1. Lazy Variables

Note: To define variables that are going to be initalized *once* use Dart's
`late` modifier.

To define lazy variables that can be marked for re-initialization
use the generic class [`Lazy<T>`][Lazy].
It is often useful to declare *lazy* variables
using Darts *late* modifier since it makes it possible to
initialize e.g. a final instance variable at the point of definition:
```Dart
class A{
  late final _value = Lazy<double>(() => costlyCalculation());
  double value get => _value();
}
```

1. Lazy variables are declared using the constructor of
   the generic class [`Lazy<T>`][Lazy].
2. The constructor requires a callback, [`ObjectFactory`][ObjectFactory],
   that returns an  object of type `T`.
3. To access the cached object, the lazy variable is called like a function
   (see example below).
4. The optional parameter `updateCache` can be used to request an
   update of the cached object.
   If `updateCache` is true, the object is re-initialized
   by calling the object factory [`ObjectFactory`][ObjectFactory] with the
   current value of the input arguments.

```Dart
import 'dart:math';

import 'package:lazy_memo/lazy_memo.dart';

// To run this program navigate to
// the root folder of your local copy of 'lazy_memo' and use the command:
//
// # dart example/bin/lazy_example.dart
void main() {
  print('Running lazy_example.dart.\n');

  final random = Random();
  final mean = 4.0;

  print('Generating a random sample with size 5000 and mean: 4.0:');
  // Generating a random sample
  final sample = List<double>.generate(
      5000, (_) => -mean * log(1.0 - random.nextDouble()));

  // Initializing lazy variables
  final sampleSum = Lazy<double>(
    () => sample.reduce((sum, current) => sum += current),
  );

  // Calculating sample mean
  final sampleMean = Lazy<double>(
    () => sampleSum(updateCache: true) / sample.length,
  );

  print('  Initial value of sampleSum: ${sampleSum()}');
  print('  Initial value of sampleMean: ${sampleMean()}\n');
  print('Adding outliers to random sample: [1500.0, 1200.0]');

  // Adding outliers
  sample.addAll([1500.0, 1200.0]);

  print('  Updated value of sampleMean: '
      '${sampleMean(updateCache: true)}');
  print('  Updated value of sampleSum: ${sampleSum()}');
}

```
</details>

<br>

### 2. Dependent Lazy Variables

It is possible to declare dependent lazy variables by using an
expression containing one lazy variable to declare another lazy variable.
In the example above, `sampleMean` depends on `sampleSum` since the callback
passed to the constructor of `sampleMean` references `sampleSum`.

The optional parameter `updateCache` can be used strategically to trigger an
update of cached variables along the
dependency tree. In the example above, `sampleSum(updateCache: true)`
is called every time `sampleMean` is updated.
Therefore, an update of `sampleMean` triggers an update of `sampleSum`.

Note: An update of a lazy variable can also be requested by calling the
method: `updateCache()`.

<br>

### 3. Lazy Collections

Lazy variables can be used to cache objects of type `List`, `Set`, `Map`, etc.
However, as the example below demonstrates, the cached object can be modified.
```Dart
final lazyList = Lazy<List<int>>(() => [1, 2, 3]);
final list = lazyList();
list.add(4); // lazyList() now returns: [1, 2, 3, 4]
```
In order to prevent users from (inadvertently) modifying the cached object one
may use the classes `LazyList<T>`, `LazySet<T>`, and `LazyMap<K, V>`. These
classes return a copy of the cached object.
```Dart
final lazyList = LazyList<int>(() => [1, 2, 3]);
final list = lazyList();
list.add(4);
print(lazyList()); // Prints: [1, 2, 3].
```
------

### 4. Memoized Functions

Memoized functions maintain a lookup table of previously calculated results.
When called,
a memoized function checks if it was called previously with the same set of arguments.
If that is the case it will return a cached result.

Memoizing a function comes at the cost of additional indirections,
higher memory usage, and the complexity of having to maintain a function table.
For this reason, memoization should be used for
**computationally expensive** functions that are likely to be
called **repeatedly** with the **same** set of **input arguments**.
Examples include: repeatedly accessing statistics of a large
data sample, calculating the factorial of an integer,
repeatedly evaluating higher degree polynomials.

The example below demonstrates how to define the *memoized functions*
`factorial(n)` and `c(n, k)`, k-combinations of n objects.

<details>  <summary> Click to show souce code. </summary>

 ```Dart
  import 'package:lazy_memo/lazy_memo.dart';

  /// Computationally expensive function with a single argument.
  int _factorial(int x) => (x == 0 || x == 1) ? 1 : x * _factorial(x - 1);

  /// Returns the factorial of a positive integer.
  final factorial = MemoizedFunction(
    _factorial,
    functionTable: {8: 40320}, // Optional initial function table.
  );

  /// Computationally expensive function with two arguments.
  int _c(int n, int k) {
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
  final c = MemoizedFunction2(_c);

  // To run this program navigate to
  // the root folder of your local copy of 'lazy_memo' and use the command:
  //
  // # dart example/bin/lazy_function_example.dart
  void main() {
    print('Running lazy_function_example.dart.\n');

    print('------------- Factorial --------------');
    print('Calculates and stores the result');
    print('factorial(12) = ${factorial(12)}\n');

    // The current function table
    print('Function table:');
    print(factorial.functionTable);
    print('');

    // Returning a cached result.
    print('Cached result:');
    print('factorial(12) = ${factorial(12)}');

    print('\n----- k-combinations of n objects -----');

    print('Calculates and stores the result of: ');
    print('c(10, 5): ${c(10, 5)}');
    print('');

    print('The current function table');
    print(c.functionTable);
    print('');

    print('Returns a cached result.');
    print('c(10, 5): ${c(10, 5)}');
  }

```
</details>
<details>  <summary> Click to show console output. </summary>

 ```Console
 $ dart example/bin/lazy_example.dart
 Running lazy_function_example.dart.

 ------------- Factorial --------------
 Calculates and stores the result
 factorial(12) = 479001600

 Function table:
 {8: 40320, 12: 479001600}

 Cached result:
 factorial(12) = 479001600

 ----- k-combinations of n objects -----
 Calculates and stores the result of:
 c(10, 5): 30240

 The current function table
 {10: {5: 30240}}

 Returns a cached result.
 c(10, 5): 30240
 ```

</details>

## Examples

The source code listed above is available in folder [example].


## Features and bugs

Please file feature requests and bugs at the [issue tracker].

[issue tracker]: https://github.com/simphotonics/lazy_memo/issues

[example]: https://github.com/simphotonics/lazy_memo/tree/master/example

[lazy_memo]: https://pub.dev/packages/lazy_memo

[lazy_initialization]: https://en.wikipedia.org/wiki/Lazy_initialization

[Lazy]: https://pub.dev/documentation/lazy_memo/latest/lazy_memo/Lazy-class.html

[memoization]: https://en.wikipedia.org/wiki/Memoization

[null-safety]: https://dart.dev/null-safety

[ObjectFactory]: https://pub.dev/documentation/lazy_memo/latest/lazy_memo/ObjectFactory.html