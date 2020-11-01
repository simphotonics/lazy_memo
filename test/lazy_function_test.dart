import 'package:lazy_memo/lazy_memo.dart';
import 'package:minimal_test/minimal_test.dart';

Future<T> later<T>(T t) async {
  return await Future.delayed(Duration(milliseconds: 200), () => t);
}

void main() {
  group('Lazy function', () {
    final square = LazyFunction<num, num>((x) => x * x);
    test('Value', () {
      square.clearFunctionTable();
      expect(square(13), 169);
      expect(square(13.5), 13.5 * 13.5);
      expect(square.functionTable, {13: 169, 13.5: 182.25});
    });
    test('Clearing function table', () {
      square.clearFunctionTable();
      expect(square.functionTable, <num, num>{});
    });
    test('Selectively clearing function table', () {
      square(8);
      square(10);
      square.clearFunctionTable(args: [10]);
      expect(square.functionTable, {8: 64});
    });
  });

  group('Lazy function returning Future', () async {
    final futureCube = LazyFunction<num, Future<num>>((x) => later<num>(
          x * x * x,
        ));

    test('Initial functionTable', () {
      expect(futureCube.functionTable, <num, Future<num>>{});
    });

    final sevenCubed = await futureCube(7);
    final eightCubed = await futureCube(8);

    test('Value', () {
      expect(sevenCubed, 7 * 7 * 7);
      expect(eightCubed, 8 * 8 * 8);
    });

    test('function table', () {
      expect(futureCube.functionTable.keys.toList(), [7, 8]);
    });

    test('Selectively clearing function table', () {
      futureCube.clearFunctionTable(args: [8]);
      expect(futureCube.functionTable[8], null);
    });
  });
}
