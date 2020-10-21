import 'package:lazy_memo/lazy_memo.dart';
import 'package:minimal_test/minimal_test.dart';

Future<T> later<T>(T t) async {
  return await Future.delayed(Duration(milliseconds: 200), () => t);
}

void main() {
  var number = 29;
  final lazyInt = Lazy<int>(() => number);
  group('Cache:', () {
    test('initial value', () {
      expect(lazyInt(), 29);
    });
    test('update factory', () {
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
    test('inital value', () {
      expect(lazyDependent(), 10.0);
    });
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

    test('Initial value', () async {
      expect(await lazyFutureString(), 'Waiting for 200 milliseconds');
    });

    input = 'Input has changed';
    test('Cached value', () async {
      expect(await lazyFutureString(), 'Waiting for 200 milliseconds');
    });

    test('Updated value', () async {
      lazyFutureString.updateCache();
      expect(await lazyFutureString(), 'Input has changed');
    });
  });
}
