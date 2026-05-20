extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    int i = 0;
    return map((E e) => f(e, i++));
  }

  E? firstWhereCanNull(bool Function(E element) test, {E Function()? orElse}) {
    for (final E element in this) {
      if (test(element)) {
        return element;
      }
    }
    if (orElse != null) {
      return orElse();
    }
    return null;
  }

  Iterable<T> mapIndexedHori<T>(T Function(E e, int i) f) {
    int i = 0;
    return map((E e) => f(e, i++));
  }
}
