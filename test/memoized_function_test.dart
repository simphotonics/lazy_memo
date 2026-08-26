import 'package:lazy_memo/lazy_memo.dart';
import 'package:test/test.dart';

Future<T> later<T>(T t) async {
  return await Future.delayed(Duration(milliseconds: 200), () => t);
}

bool _isComparable<T>() => Iterable<T>.empty() is Iterable<Comparable>;

void main() {
  group('Generic memoized function: ', () {
    test('initial function table', () {
      final isComparable = GenericMemoizedFunction(
        _isComparable,
        functionTable: {int: true},
      );

      expect(isComparable.functionTable, {int: true});
      expect(isComparable<double>(), true);
      expect(
        isComparable.functionTable,
        isA<Map<Type, bool>>().having(
          (map) => map.containsKey(double),
          'key',
          true,
        ),
      );
    });
    test('value', () {
      final isComparable = GenericMemoizedFunction(
        _isComparable,
        functionTable: {int: true},
      );

      expect(isComparable<List>(), false);
      expect(isComparable.functionTable, {int: true, List: false});
    });
    test('clearing function table', () {
      final isComparable = GenericMemoizedFunction(
        _isComparable,
        functionTable: {int: true},
      );

      isComparable<String>();
      isComparable.clearFunctionTable();
      expect(isComparable.functionTable, <Type, bool>{});
    });
    test('selectively clearing function table', () {
      final isComparable = GenericMemoizedFunction(
        _isComparable,
        functionTable: {int: true, bool: false},
      );
      isComparable.clearFunctionTable(args: [bool]);
      expect(isComparable.functionTable, {int: true});
    });
    test('signature', () {
      final isComparable = GenericMemoizedFunction(_isComparable);
      expect(isComparable.signature, GenericFunction<bool>);
    });
  });
  group('Memoized function: ', () {
    final square = MemoizedSingleArgumentFunction<num, num>((x) => x * x);
    test('initial function table', () {
      final quad = MemoizedSingleArgumentFunction(
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
    test('signature', () {
      expect(square.signature, SingleArgumentFunction<num, num>);
    });
  });

  group('Memoized function returning \'Future\':', () {
    final futureCube = MemoizedSingleArgumentFunction<Future<num>, num>(
      (x) => later<num>(x * x * x),
    );

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
    final xy = MemoizedDoubleArgumentFunction((num x, num y) => x * y);
    test('initial function table', () {
      final xy = MemoizedDoubleArgumentFunction(
        (num x, num y) => x * y,
        functionTable: {(3, 6): 18},
      );
      expect(xy.functionTable, <(num, num), num>{(3, 6): 18});
      expect(xy(8, 9), 72);
      expect(xy.functionTable, <(num, num), num>{(3, 6): 18, (8, 9): 72});
    });
    test('value', () {
      xy.clearFunctionTable();
      expect(xy(0, 1), 0);
    });
    test('clearing function table', () {
      xy.clearFunctionTable();
      expect(xy.functionTable, <(num, num), num>{});
    });
  });
}
