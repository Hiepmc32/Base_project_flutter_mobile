extension ListGetExtension<T> on List<T> {
  T? tryGet(int index) => index < 0 || index >= length ? null : this[index];

  T? getIndex(int index) => length > index ? this[index] : null;

  T? firstWhereCanNull(bool Function(T element) test, {T Function()? orElse}) {
    for (final T element in this) {
      if (test(element)) {
        return element;
      }
    }
    if (orElse != null) {
      return orElse();
    }
    return null;
  }
}
