extension ExtraIterators<E> on Iterable<E> {
  /// A `.map` but with an index as the second argument
  Iterable<T> mapWithIndex<T>(T f(E e, int i)) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}
