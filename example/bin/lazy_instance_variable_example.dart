import 'dart:math';

import 'package:lazy_memo/lazy_memo.dart' show Lazy;

final rand = Random();
double costlyCalculation() => rand.nextDouble() * 1e20;

class A {
  final _value = Lazy<double>(costlyCalculation);

  double get value => _value();

  void update() => _value.updateCache();
}

void main(List<String> args) {
  final a = A();

  // Access value:
  print(a.value);
  print(a.value);

  a.update();
  print(a.value);
}
