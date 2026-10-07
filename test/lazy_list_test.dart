import 'package:lazy_memo/lazy_memo.dart' show LazyList;
import 'package:test/test.dart';

void main() {
  group('LazyList<int>:', () {
    final lazyList = LazyList<int>(() => [1, 2, 3]);
    test('cached list', () {
      expect(lazyList(), [1, 2, 3]);
    });
    test('unmodifiable list', () {
      expect(lazyList(), isA<List<int>>());
      expect(() {
        lazyList().removeLast();
      }, throwsA(isA<UnsupportedError>()));
    });
    test('returns same object', () {
      expect(lazyList() == lazyList(), true);
    });
    test('first', () {
      expect(lazyList.first, 1);
      lazyList.invalidateCache();
      expect(lazyList.first, 1);
    });
    test('last', () {
      expect(lazyList.last, 3);
      lazyList.invalidateCache();
      expect(lazyList.last, 3);
    });
    test('access [1]', () {
      expect(lazyList[1], 2);
      lazyList.invalidateCache();
      expect(lazyList[2], 3);
    });
  });
}
