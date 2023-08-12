import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:lazy_memo/lazy_memo.dart';

final lazy = LazyMap<int, double>(() => <int, double>{
      27: sqrt(27),
      29: sqrt(29),
    });
Map<int, double> testFunc() => <int, double>{
      27: sqrt(27),
      29: sqrt(29),
    };

late Map<int, double> map;

// Create a new benchmark by extending BenchmarkBase
class CallBenchmark extends BenchmarkBase {
  const CallBenchmark() : super('''LazyMap<int, double>(() => <int, double>{
      27: sqrt(27),
      29: sqrt(29),
    }); \n''');

  static void main() {
    const CallBenchmark().report();
  }

  // The benchmark code.
  @override
  void run() {
    map = lazy();
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
  const FunctionCallBenchmark() : super('''<int, double>{
      27: sqrt(27),
      29: sqrt(29),
    }; \n''');

  static void main() {
    const FunctionCallBenchmark().report();
  }

  // The benchmark code.
  @override
  void run() {
    map = testFunc();
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
  print('Returning cached map:');
  CallBenchmark.main();
  print('\nBuilding map object:');
  FunctionCallBenchmark.main();
}
