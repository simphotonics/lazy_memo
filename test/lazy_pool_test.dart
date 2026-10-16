import 'package:lazy_memo/lazy_memo.dart' show Lazy, LazyPool;
import 'package:test/test.dart';

void main() {
  var a = 'a';
  var b = 'b';
  final lazyA = Lazy(() => a);
  final lazyB = Lazy(() => b);

  group('LazyPool:', () {
    test('add', () {
      final pool = LazyPool.empty();
      pool.add(lazyA);
      expect(pool.contains(lazyA), isTrue);
    });

    test('remove', () {
      final pool = LazyPool.empty();
      pool.add(lazyA);
      pool.remove(lazyA);
      expect(pool.isEmpty, isTrue);
    });
    test('invalidateCache', () {
      final pool = LazyPool([lazyA, lazyB]);
      pool.invalidateCache();
      expect(lazyA.isStale, isTrue);
      expect(lazyB.isStale, isTrue);
    });
  });
}
