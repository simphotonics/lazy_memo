import 'package:lazy_memo/lazy_memo.dart';

void main(List<String> args) {
  final origin = <String>['zero', 'one', 'two'];

  var lazyList = LazyList<String>(() => [...origin, 'three']);

  // The object
  print(lazyList);
  // The cached list view
  print(lazyList());

  // Returns the same object till it is re-initialized.
  print(lazyList() == lazyList());
  print(lazyList() == lazyList(updateCache: true));

  origin.add('four');

  print(lazyList(updateCache: true));
}
