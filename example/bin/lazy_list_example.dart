import 'package:lazy_memo/lazy_memo.dart';

void main(List<String> args) {
  final original = <String>['zero', 'one', 'two'];

  final lazyList = LazyList<String>(() => original);

  // The object
  print(lazyList);

  // Returns the same object till it is re-initialized.
  print('\nlazyList() == lazyList():');
  print('  ${lazyList() == lazyList()}');

  print('\nAdding an element to the original list.');
  print('original.add(\'three\');');
  original.add('three');

  print('\nlazyList() == lazyList(updateCache: true):');
  print(lazyList() == lazyList(updateCache: true));

  print('\n$lazyList');
}
