import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:lazy_memo/lazy_memo.dart';

late BigInt a;
final BigInt arg = 50.big;

// Create a new benchmark by extending BenchmarkBase
class FactorialMemoBenchmark extends BenchmarkBase {
  const FactorialMemoBenchmark() : super('factorial(50)                    ');

  static void main() {
    const FactorialMemoBenchmark().report();
  }

  // The benchmark code.
  @override
  void run() {
    a = factorial(arg);
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
class FactorialBenchmark extends BenchmarkBase {
  const FactorialBenchmark() : super('factorial.(50, recalculate: true)');

  static void main() {
    const FactorialBenchmark().report();
  }

  // The benchmark code.
  @override
  void run() {
    a = factorial(
      arg,
      recalculate: true,
    );
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
  FactorialMemoBenchmark.main();
  FactorialBenchmark.main();
}
