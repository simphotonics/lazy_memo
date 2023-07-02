import 'package:lazy_memo/lazy_memo.dart';
import 'package:test/test.dart';

void main() {
  group('factorial:', () {
    test('values', () {
      expect(factorial(BigInt.zero), BigInt.one);
      expect(factorial(BigInt.one), BigInt.one);
      expect(factorial(BigInt.from(7)), BigInt.from(1 * 2 * 3 * 4 * 5 * 6 * 7));
    });
    test('throws on negative arg', () {
      expect(() => factorial(BigInt.from(-1)), throwsA(isA<ArgumentError>()));
    });
  });
  group('combinations:', () {
    test('values', () {
      expect(combinations(10, 5), 252);
      expect(combinations(0, 0), 1);
      expect(combinations(1, 0), 1);
    });
    test('symmetry', () {
      expect(combinations(10, 7), combinations(10, 3));
    });
    test('throws on negative arg', () {
      expect(() => combinations(-1, 3), throwsA(isA<ArgumentError>()));
    });
    test('throws on k > n', () {
      expect(() => combinations(10, 11), throwsA(isA<ArgumentError>()));
    });
  });
}
