extension ExtraIterators<E> on Iterable<E> {
  /// A `.map` but with an index as the second argument
  Iterable<T> mapWithIndex<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}
