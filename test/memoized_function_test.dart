import 'package:lazy_memo/lazy_memo.dart';
import 'package:test/test.dart';

Future<T> later<T>(T t) async {
  return await Future.delayed(Duration(milliseconds: 200), () => t);
}

void main() {
  group('Memoized function: ', () {
    final square = MemoizedFunction<num, num>((x) => x * x);
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
}
