extension ExtendedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int i, E e) f) {
    int i = 0;
    return map((e) => f(i++, e));
  }
}
