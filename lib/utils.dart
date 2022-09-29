import 'dart:math';

Iterable<List<T>> zip<T>(Iterable<Iterable<T>> iterables) sync* {
  if (iterables.isEmpty) return;
  final iterators = iterables.map((e) => e.iterator).toList(growable: false);
  while (iterators.every((e) => e.moveNext())) {
    yield iterators.map((e) => e.current).toList(growable: false);
  }
}

T randomChoice<T>(Iterable<T> options) {
  int choice = Random().nextInt(options.length);
  return options.elementAt(choice);
}
