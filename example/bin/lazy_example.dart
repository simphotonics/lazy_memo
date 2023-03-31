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
