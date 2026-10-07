import 'package:lazy_memo/lazy_memo.dart';

void main(List<String> args) {
  final original = <String>['zero', 'one', 'two'];
  final lazyList = LazyList<String>(() => original);

  // The object
  print('Original object: $original');
  print('Cached object  : $lazyList\n');

  print('// Returns the same object, unless the cache is refreshed:');
  print('lazyList() == lazyList(): ${lazyList() == lazyList()}');

  print(
    'lazyList() == lazyList(updateCache: true): '
    '${lazyList() == lazyList(updateCache: true)}',
  );

  print('\nAdding an element to the original list: original.add(\'three\')');
  original.add('three');
  print('Original object: $original');
  print('Cached object  : $lazyList\n');

  print('Access list element: lazyList[2] = ${lazyList[2]}');
}
