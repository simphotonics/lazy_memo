import 'package:lazy_memo/lazy_memo.dart';

bool _isComparable<T>() => Iterable<T>.empty() is Iterable<Comparable>;

void main(List<String> args) {
  final isComparable = GenericMemoizedFunction(_isComparable);
  isComparable<bool>();
  isComparable<int>();
  isComparable<String>();
  isComparable<Iterable>();
  isComparable<List<int>>();

  print('GenericMemoizedFunction example:');
  print('''
  isComparable<bool>();
  isComparable<int>();
  isComparable<String>();
  isComparable<Iterable>();
  isComparable<List<int>();''');
  print('\n  print(isComparable.functionTable);');
  print('  ${isComparable.functionTable}');
}
