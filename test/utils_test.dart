import 'package:lazy_memo/lazy_memo.dart';
import 'package:test/test.dart';

void main() {
  group('factorial:', () {
    test('values', () {
      expect(factorial(BigInt.zero), BigInt.one);
      expect(factorial(BigInt.one), BigInt.one);
      expect(factorial(7.big), (1 * 2 * 3 * 4 * 5 * 6 * 7).big);
    });
    test('throws on negative arg', () {
      expect(() => factorial(-1.big), throwsA(isA<ArgumentError>()));
    });
  });
  group('combinations:', () {
    test('values', () {
      expect(combinations(10.big, 5.big), 252.big);
      expect(combinations(BigInt.zero, BigInt.zero), BigInt.one);
      expect(combinations(BigInt.one, BigInt.zero), BigInt.one);
    });
    test('symmetry', () {
      expect(combinations(10.big, 7.big), combinations(10.big, 3.big));
    });
    test('throws on negative arg', () {
      expect(() => combinations(-1.big, 3.big), throwsA(isA<ArgumentError>()));
    });
    test('throws on k > n', () {
      expect(() => combinations(10.big, 11.big), throwsA(isA<ArgumentError>()));
    });
  });
}
