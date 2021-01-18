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

  // Generating a random sample following an exponential distribution.
  print('Generating random sample ...');
  final sample =
      List<double>.generate(100, (_) => -mean * log(1.0 - random.nextDouble()));

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
