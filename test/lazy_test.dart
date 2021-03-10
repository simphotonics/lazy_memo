import 'package:lazy_memo/lazy_memo.dart';
import 'package:test/test.dart';

Future<T> later<T>(T t) async {
  return await Future.delayed(Duration(milliseconds: 200), () => t);
}

void main() {
  var number = 29;
  final lazyInt = Lazy<int>(() => number);
  group('Getter isUpToDate:', () {
    test('uninitialized', () {
      final lazy = Lazy<num>(() => 5);
      expect(lazy.isUpToDate, false);
      expect(lazy(), 5);
      expect(lazy.isUpToDate, true);
    });
    test('updated', () {
      final lazy = Lazy<num>(() => 7);
      expect(lazy(), 7);
      lazy.updateCache();
      expect(lazy.isUpToDate, false);
    });
  });

  group('Cache:', () {
    test('update factory', () {
      lazyInt.updateCache();
      number = 29;
      expect(lazyInt(), 29);
      number = 30;
      expect(lazyInt(), 29);
    });
    test('notifyUpdateCache()', () {
      number = 31;
      lazyInt.updateCache();
      expect(lazyInt(), 31);
    });
  });
  group('Dependency:', () {
    number = 30;
    lazyInt.updateCache();
    final lazyDependent = Lazy<double>(() => lazyInt(updateCache: true) / 3);
    test('updateCache', () {
      number = 60;
      expect(lazyDependent(updateCache: true), 20.0);
      expect(lazyInt(), 60);
    });
  });
  group('Async:', () {
    var input = 'Waiting for 200 milliseconds';

    final lazyFutureString = Lazy<Future<String>>(
      () => later<String>(input),
    );

    test('cached value', () async {
      input = 'Waiting for 200 milliseconds';
      lazyFutureString.updateCache();
      expect(await lazyFutureString(), 'Waiting for 200 milliseconds');
      input = 'Input has changed';
      expect(await lazyFutureString(), 'Waiting for 200 milliseconds');
    });

    test('updated value', () async {
      lazyFutureString.updateCache();
      input = 'Input has changed';
      expect(await lazyFutureString(), 'Input has changed');
    });
  });
}
