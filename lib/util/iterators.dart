extension ExtraIterators<E> on Iterable<E> {
  Iterable<T> mapWithIndex<T>(T f(E e, int i)) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}
