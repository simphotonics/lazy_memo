
# Lazy Variables for Dart
[![Dart](https://github.com/simphotonics/lazy_memo/actions/workflows/dart.yml/badge.svg)](https://github.com/simphotonics/lazy_memo/actions/workflows/dart.yml)

## Introduction

The package [lazy_memo][lazy_memo] provides generic classes that can be used
to define [lazy cached variables](#1-lazy-variables) and
[memoized functions](#4-memoized-functions).

Caching, consists in storing and reusing the result of a costly computation.
The technique of storing the result of function calls is called
[memoization][memoization].

A different strategy to minimize CPU usage is to delay the
initialization of variables. [Late initialization][lazy_initialization]
is particularly useful in event driven scenarios
where there is no definite execution path and
a certain variable might never be used.

## Usage

To use this library include [`lazy_memo`][lazy_memo] as a dependency
in your pubspec.yaml file.
<br>

### 1. Lazy Variables

**Important**: To define variables that are lazily initialized **once**
simply use Dart's `late` modifier:
```Dart
late final result = costlyCalculation();
```

To define *cached lazy* variables that can be marked for *re-initialization*
use the generic class [`Lazy<T>`][Lazy].

1. Lazy variables are declared using the constructor of
   the generic class [`Lazy<T>`][Lazy].
   The constructor requires a callback, [`ObjectFactory`][ObjectFactory],
   that returns an  object of type `T`.
   ```Dart
   double objectFactory(){
    // Costly calculation ...
    return calculationResult;
   }

   // Defining a lazy variable that caches a value of type double.
   late final a = Lazy(objectFactory);
   ```
   To prevent (inadvertent) modification of the cached variable it is advisable
   to have [`ObjectFactory`][ObjectFactory] return an immutable object.
   For more info see the section [Lazy Collections](#3-lazy-collections) below.
2. To access the cached object, the lazy variable is called like a function:
   ```Dart
   // Accessing the cached value:
   a();
   ```
   When first accessed, the cached
   value is initialized with result of the object factory.
   When accessed repeatedly the same cached value is returned.

   The optional parameter `updateCache` can be used to request an
   update of the cached object.
   ```Dart
   // Recalculating the stored value:
   a(updateCache: true);
   ```

Tip: When declaring lazy variables it is useful to add the `late` modifier.
In that case, not only the cached value but also the variable itself is
initialized only when accessed.


### 2. Dependent Lazy Variables

It is possible to declare dependent lazy variables by using an
expression containing one lazy variable to declare another lazy variable.

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

  // Calculating the sample mean
  final sampleMean = Lazy<double>(
    () => sampleSum(updateCache: true) / sample.length,
  );

  print('  Initial value of sampleMean: ${sampleMean()}');
  print('  Initial value of sampleSum: ${sampleSum()}\n');
  print('Adding outliers to random sample: [1500.0, 1200.0]');

  // Adding outliers
  sample.addAll([1500.0, 1200.0]);

  print('  Updated value of sampleMean: '
      '${sampleMean(updateCache: true)}');
  print('  Updated value of sampleSum: ${sampleSum()}');
}

```
In the code sample above, `sampleMean` depends on `sampleSum` since the callback
passed to the constructor of `sampleMean` references `sampleSum`.

The optional parameter `updateCache` can be used strategically to trigger an
update of cached variables along the
dependency tree. Since `sampleSum(updateCache: true)`
is called every time `sampleMean` is updated,
an update of `sampleMean` triggers an update of `sampleSum`.

Note: An update of a lazy variable can also be requested by calling the
instance method: `updateCache()`.

<details>  <summary> Click to show console output. </summary>

 ```Console
 $ dart example/bin/lazy_example.dart
Running lazy_example.dart.

Generating a random sample with size 5000 and mean: 4.0:
  Initial value of sampleMean: 4.048803375544851
  Initial value of sampleSum: 8097.606751089702

Adding outliers to random sample: [1500.0, 1200.0]
  Updated value of sampleMean: 5.393409965579271
  Updated value of sampleSum: 10797.606751089701
 ```

</details>


### 3. Lazy Collections

Lazy variables can be used to cache objects of type `List`, `Set`, `Map`, etc.
However, as the example below demonstrates, the cached object *can* be modified.
```Dart
final lazyList = Lazy<List<int>>(() => [1, 2, 3]);
final list = lazyList();
list.add(4); // lazyList() now returns: [1, 2, 3, 4]
```
To prevent (inadvertent) modification of the cached collection the object
factory should return an unmodifiable collection:
```Dart
final lazyList = Lazy<List<int>>(() => List.unmodifiableOf([1,2,3]));
```

Alternatively, one could use the classes `LazyList<T>`, `LazySet<T>`,
and `LazyMap<K, V>`.
These classes cache an unmodifiable copy of the collection.

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

The example below demonstrates how to define the *memoized function*
`factorial(n)`. This function is included in the library
[`utils.dart`][utils].

<details>  <summary> Click to show souce code. </summary>

 ```Dart
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

  // To run this program navigate to
  // the root folder of your local copy of 'lazy_memo' and use the command:
  //
  // # dart example/bin/memoized_function_example.dart
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
```
</details>
<details>  <summary> Click to show console output. </summary>

 ```Console
 $ dart example/bin/memoized_function_example.dart
Running memoized_function_example.dart.

------------- Factorial --------------
Calculates and stores the result
factorial(49) = 608281864034267560872252163321295376887552831379210240000000000

Function table:
{12: 479001600, 49: 608281864034267560872252163321295376887552831379210240000000000}

Cached result:
factorial(12) = 479001600
 ```

</details>

## Examples

The source code listed above is available in the folder [example].


## Features and bugs

Please file feature requests and bugs at the [issue tracker].

[issue tracker]: https://github.com/simphotonics/lazy_memo/issues

[example]: https://github.com/simphotonics/lazy_memo/tree/main/example

[lazy_memo]: https://pub.dev/packages/lazy_memo

[lazy_initialization]: https://en.wikipedia.org/wiki/Lazy_initialization

[Lazy]: https://pub.dev/documentation/lazy_memo/latest/lazy_memo/Lazy-class.html

[memoization]: https://en.wikipedia.org/wiki/Memoization

[null-safety]: https://dart.dev/null-safety

[ObjectFactory]: https://pub.dev/documentation/lazy_memo/latest/lazy_memo/ObjectFactory.html

[utils]: https://github.com/simphotonics/lazy_memo/tree/main/lib/src/utils.dart