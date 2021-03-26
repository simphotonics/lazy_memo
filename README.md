
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
[Lazy initialization][lazy_initialization] is a common concept and is particularly useful in
event driven scenarios where there is no definite execution path and a certain
variable might never be used.

The package [`lazy_memo`][lazy_memo] provides generic classes that can be used to define
[lazy variables](#lazy-variables) and [memoized functions](#memoized-functions).

## Usage

To use this library include [`lazy_memo`][lazy_memo] as a dependency in your pubspec.yaml file.
The package uses [null-safety] features and requires Dart SDK version `>=2.12.0`.

### Lazy Variables

1. Lazy variables are declared using the constructor of the generic class [`Lazy<T>`][Lazy].
2. The constructor requires a callback [`ObjectFactory`][ObjectFactory] that returns an  object of type `T`.
3. To access the cached object, the lazy variable is called like a function (see example below).
4. The optional parameter `updateCache` can be used to request an update of the cached object.
   If `updateCache` is true, the object is re-initialized using the (current version) of the callback [`ObjectFactory`][ObjectFactory].

```Dart
import 'package:lazy/lazy.dart';

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
<details>  <summary> Click to show console output. </summary>

 ```Console
 $ dart example/bin/lazy_example.dart
 Running lazy_example.dart.

 Generating random sample ...
 Initial value of sampleSum: 415.9556128306705
 Initial value of sampleMean: 4.159556128306705

 Adding outliers:
 Updated value of sampleMean: 6.234858949320299
 Updated value of sampleSum: 635.9556128306705
 ```
</details>

#### Dependent Lazy Variables

It is possible to declare dependent lazy variables by using an
expression containing one lazy variable to declare another lazy variable.
In the example above, `sampleMean` depends on `sampleSum` since the callback passed
to the constructor of `sampleMean` references `sampleSum`.

The optional parameter `updateCache` can be used strategically to trigger an
update of cached variables along the
dependency tree. In the example above, the expression `x(updateCache: true)`
is called every time `sampleMean` is updated.
Therefore, an update of `sampleMean` triggers an update of `sampleSum`.

Note: An update of a lazy variable can also be requested by calling the
method: `updateCache()`.

#### Lazy Collections

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


### Memoized Functions

Memoized functions maintain a lookup table of previously calculated results. When called,
a memoized function checks if it was called previously with the same set of arguments.
If that is the case it will return a cached result.

Memoizing a function comes at the cost of additional indirections,
higher memory usage, and the complexity of having to maintain a function table.
For this reason, memoization should be only used for
**computationally expensive** functions that are likely to be
called **repeatedly** with the **same** set of **input arguments**.
Examples include: repeatedly accessing statistics of a large
data sample, calculating the factorial of an integer,
repeatedly evaluating higher degree polynomials.

The example below demonstrates how to define the *memoized functions*
`factorial` and `polynomial`.

<details>  <summary> Click to show souce code. </summary>

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
  // root folder of you local copy of the package lazy_memo
  // in use the command:
  //
  // # dart example/bin/lazy_function_example.dart
  //
  // followed by enter.
  void main() {
    print('Running lazy_function_example.dart.\n');

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
    print('factorial(12) = {factorial(12)}');

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
 ```

</details>


<details>  <summary> Click to show console output. </summary>

 ```Console
 $ dart example/bin/memoized_function_example.dart
 Running lazy_function_example.dart.

 -------- Factorial ------------
 Calculates and stores the result
 factorial(12) = 479001600

 Function table:
 {12: 479001600}

 Cached result:
 factorial(12) = 479001600

 -------- Polynomial ------------
 Calculates and stores the result of:
 polynomial(2, [2, -9, 10, 11, 15]): 352

 The current function table
 {2: {[2, -9, 10, 11, 15]: 352}}

 Returns a cached result.
 352
 ```
</details>


## Examples

The source code listed above is available in folder [example].



## Features and bugs

Please file feature requests and bugs at the [issue tracker].




[ObjectFactory]: https://pub.dev/documentation/lazy_memo/latest/lazy_memo/ObjectFactory.html

[issue tracker]: https://github.com/simphotonics/lazy_memo/issues

[example]: https://github.com/simphotonics/lazy_memo/tree/master/example

[lazy_memo]: https://pub.dev/packages/lazy_memo

[lazy_initialization]: https://en.wikipedia.org/wiki/Lazy_initialization

[memoization]: https://en.wikipedia.org/wiki/Memoization

[null-safety]: https://dart.dev/null-safety

[Lazy]: https://pub.dev/documentation/lazy_memo/latest/lazy_memo/Lazy-class.html
