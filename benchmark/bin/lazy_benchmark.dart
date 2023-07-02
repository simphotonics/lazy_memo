import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:lazy_memo/lazy_memo.dart';

final lazy = Lazy<double>(() => sqrt(27));
double testFunc() => sqrt(27);
late double a;

// Create a new benchmark by extending BenchmarkBase
class CallBenchmark extends BenchmarkBase {
  const CallBenchmark() : super('Lazy<double>(() => sqrt(27))   ');

  static void main() {
    const CallBenchmark().report();
  }

  // The benchmark code.
  @override
  void run() {
    a = lazy();
  }

  // Not measured setup code executed prior to the benchmark runs.
  @override
  void setup() {}

  // Not measured teardown code executed after the benchmark runs.
  @override
  void teardown() {}

  // To opt into the reporting the time per run() instead of per 10 run() calls.
  //@override
  //void exercise() => run();
}

// Create a new benchmark by extending BenchmarkBase
class FunctionCallBenchmark extends BenchmarkBase {
  const FunctionCallBenchmark() : super('double testFunc() => sqrt(27)  ');

  static void main() {
    const FunctionCallBenchmark().report();
  }

  // The benchmark code.
  @override
  void run() {
    a = testFunc();
  }

  // Not measured setup code executed prior to the benchmark runs.
  @override
  void setup() {}

  // Not measured teardown code executed after the benchmark runs.
  @override
  void teardown() {}

  // To opt into the reporting the time per run() instead of per 10 run() calls.
  //@override
  //void exercise() => run();
}

void main() {
  CallBenchmark.main();
  FunctionCallBenchmark.main();
}
