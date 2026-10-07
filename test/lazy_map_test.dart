import 'package:lazy_memo/lazy_memo.dart' show LazyMap;
import 'package:test/test.dart';

void main() {
  group('LazyMap<String, int>:', () {
    final lazyMap = LazyMap<String, int>(
      () => {'one': 1, 'two': 2, 'three': 3},
    );
    test('cached map', () {
      expect(lazyMap(), {'one': 1, 'two': 2, 'three': 3});
    });
    test('unmodifiable map', () {
      expect(lazyMap(), isA<Map<String, int>>());
      expect(() {
        lazyMap().remove('one');
      }, throwsA(isA<UnsupportedError>()));
    });

    test('returns same object', () {
      expect(lazyMap() == lazyMap(), true);
    });
    test('returns new object after update', () {
      expect(lazyMap() == lazyMap(updateCache: true), false);
    });
    test('access', () {
      expect(lazyMap['two'], 2);
    });
  });
}
