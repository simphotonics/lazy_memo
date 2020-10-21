import 'package:lazy_memo/lazy_memo.dart';

// To run this program navigate to
// the folder 'lazy/example'
// in your terminal and type:
//
// # dart --enable-experiment==non-nullable bin/lazy_example.dart
//
// followed by enter.
void main() {
  print('Running lazy_example.dart.\n');
  final list = <int>[1, 2, 3, 4, 5, 6, 7];

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
