import 'package:lazy_memo/lazy_memo.dart';
import 'package:test/test.dart';

Future<T> later<T>(T t) async {
  return await Future.delayed(Duration(milliseconds: 200), () => t);
}

void main() {
  group('Memoized function: ', () {
    final square = MemoizedFunction<num, num>((x) => x * x);
    test('initial function table', () {
      final quad = MemoizedFunction(
        (num x) => x * x * x * x,
        functionTable: {4: 256, 5: 625},
      );
      expect(quad.functionTable, <num, num>{4: 256, 5: 625});
      expect(quad(6), 6 * 6 * 6 * 6);
      expect(
        quad.functionTable,
        isA<Map<num, num>>().having((map) => map.containsKey(6), 'key', true),
      );
    });
    test('value', () {
      square.clearFunctionTable();
      expect(square(13), 169);
      expect(square(13.5), 13.5 * 13.5);
      expect(square.functionTable, {13: 169, 13.5: 182.25});
    });
    test('clearing function table', () {
      square.clearFunctionTable();
      expect(square.functionTable, <num, num>{});
    });
    test('selectively clearing function table', () {
      square.clearFunctionTable();
      square(8);
      square(10);
      square.clearFunctionTable(args: [10]);
      expect(square.functionTable, {8: 64});
    });
  });

  group('Memoized function returning \'Future\':', () {
    final futureCube = MemoizedFunction<num, Future<num>>((x) => later<num>(
          x * x * x,
        ));

    test('Value', () async {
      expect(await futureCube(7), 7 * 7 * 7);
      expect(await futureCube(8), 8 * 8 * 8);
    });

    test('function table', () async {
      futureCube.clearFunctionTable();
      await futureCube(87);
      await futureCube(99);
      expect(futureCube.functionTable.keys.toList(), [87, 99]);
    });

    test('Selectively clearing function table', () async {
      futureCube.clearFunctionTable();
      await futureCube(87);
      await futureCube(99);
      futureCube.clearFunctionTable(args: [99]);
      expect(await futureCube.functionTable[99], null);
      expect(await futureCube.functionTable[87], 87 * 87 * 87);
    });
  });

  group('Memoized function 2: ', () {
    final xy = MemoizedFunction2((num x, num y) => x * y);
    test('initial function table', () {
      final xy = MemoizedFunction2((num x, num y) => x * y, functionTable: {
        3: {6: 18}
      });
      expect(xy.functionTable, <num, Map<num, num>>{
        3: {6: 18}
      });
      expect(xy(8, 9), 72);
      expect(
        xy.functionTable,
        <num, Map<num, num>>{
          3: {6: 18},
          8: {9: 72}
        },
      );
    });
    test('value', () {
      xy.clearFunctionTable();
      expect(xy(0, 1), 0);
    });
    test('clearing function table', () {
      xy.clearFunctionTable();
      expect(xy.functionTable, <num, Map<num, num>>{});
    });
  });
}
