import 'package:lazy_memo/lazy_memo.dart' show LazySet;
import 'package:test/test.dart';

void main() {
  group('LazySet<int>:', () {
    final lazySet = LazySet<int>(() => {1, 2, 3});
    test('cached set', () {
      expect(lazySet(), {1, 2, 3});
    });
    test('unmodifiable set', () {
      expect(lazySet(), isA<Set<int>>());
      expect(() {
        lazySet().remove(1);
      }, throwsA(isA<UnsupportedError>()));
    });
    test('returns same object', () {
      expect(lazySet() == lazySet(), true);
    });

    test('access', () {
      expect(lazySet.lookup(2), 2);
    });
  });
}
