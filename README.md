
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


## Usage

To use this library include [`lazy_memo`][lazy_memo] as a dependency in your pubspec.yaml file.
The package uses [null-safety] features and requires Dart SDK version `>=2.10.0`.

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
  final list = <int>[1, 2, 3, 4, 5, 6, 7];

  // Initialize lazy variables
  final x = Lazy<int>(() => list.reduce((sum, current) => sum += current));
  final y = Lazy<double>(() => x(updateCache: true) / 10.0);

  // Initialize lazy variables
  final x = Lazy<int>(() => list.reduce((sum, current) => sum += current));
  final y = Lazy<double>(() => x(updateCache: true) / 10.0);

  print('Initial value of x: ${x()}'); // 'Initial value of x: 28'
  print('Initial value of y: ${y()}\n'); // 'Initial value of y: 2.8'

  list.add(8);

  print('Updated value of y: '
      '${y(updateCache: true)}');      // 'Updated value of y: 3.6'
  print('Updated value of x: ${x()}'); // 'Updated value of x: 36'
}
```

## Dependent Lazy Variables

It is possible to declare dependent lazy variables by using an
expression containing one lazy variable to declare another lazy variable.

In the example above, `y` depends on `x` since the callback passed
to the constructor of `y` references `x`.

The optional parameter `updateCache` can be used strategically to trigger an
update of cached variables along the
dependency tree.

In the example above, the expression `x(updateCache: true)` is called
every time `y` is updated. Therefore, an update of `y` triggers an update of `x`.

Note: An update of a lazy variable can also be requested by calling the
method: `updateCache()`.

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
