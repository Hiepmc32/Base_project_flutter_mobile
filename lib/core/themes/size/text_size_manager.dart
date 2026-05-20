class TextSizeManager {
  factory TextSizeManager() {
    return _singleton;
  }

  TextSizeManager._internal();

  static final TextSizeManager _singleton = TextSizeManager._internal();
  double textScaleFactor = 1;
}
