import 'dart:ui' as ui;

// BASE iPhone 8

double designScreenHeight = 667;
double designScreenWidth = 375;

ui.Size _screenSize() {
  final Iterable<ui.FlutterView> views = ui.PlatformDispatcher.instance.views;
  if (views.isEmpty) {
    throw StateError('No active FlutterView available.');
  }

  final ui.FlutterView view = views.first;
  final double ratio = view.devicePixelRatio;
  return ui.Size(
    view.physicalSize.width / ratio,
    view.physicalSize.height / ratio,
  );
}

extension DimensionExtension on num {
  double get getWidth {
    final double width = _screenSize().width;
    if (this < 0.0 || this > 1.0) {
      return width;
    }
    return this * width;
  }

  double get getHeight {
    final double height = _screenSize().height;
    if (this < 0.0 || this > 1.0) {
      return height;
    }
    return this * height;
  }

  /// height
  double get height {
    final double ratio = _screenSize().height / designScreenHeight;

    return (this * ratio).ceil().toDouble();
  }

  /// width
  double get width {
    final double ratio = _screenSize().width / designScreenWidth;
    return (this * ratio).ceil().toDouble();
  }

  /// fontSize
  double get fontSized {
    final double ratio = _screenSize().width / designScreenWidth;
    return (this * ratio).ceil().toDouble();
  }
}

bool isTablet() {
  final ui.Size size = _screenSize();
  final double shortestSide = size.shortestSide;
  return shortestSide > 600;
}

double plusWithTablet(double size) {
  return size + (isTablet() ? 10 : 0);
}

class AppSized {
  static AppSized share = AppSized();

  //cỡ chữ
  double get fontSmallest => 12;
  double get fontSmall => 14;
  double get fontSemiMedium => 15;
  double get fontMedium => 16;
  double get fontBig => 18;
  double get fontBiggest => 20;
  double get fontLogin => 13;
  double get font10 => 10;
  double get font32 => 32;

  // Kích thức ảnh
  double get sizeImage => 50;
  double get sizeImageMedium => 70;
  double get sizeImageBig => 90;
  double get sizeImageLarge => 200;

  // Kích thứơc nút nhấn
  double get sizeTextSmall => 40;
  double get btnSmall => 20;
  double get btnMedium => 50;
  double get btnLarge => 70;

  // Kích thứơc icon
  double get sizeIcon => 20;
  double get sizeIconMedium => 24;
  double get sizeIconLarge => 36;
  double get sizeDialogNotiIcon => 40;

  double get heightChip => 30;
  double get widthChip => 100;

  int get maxLengthDescription => 250;

  // Kích thứơc khoảng cach lề
  double get defaultPadding => 16.0;
  double get paddingVerySmall => 8.0;
  double get paddingSmall => 12.0;
  double get paddingMedium => 20.0;
  double get paddingHuge => 32.0;
  double get padding16 => 16.0;
  double get padding18 => 18.0;
  double get padding6 => 6;

  // font size
  double get sizeHeader => 32.0;
  double get sizeTitle => 20.0;
  double get sizeHeadline => 16.0;
  double get sizeBody => 14.0;
  double get sizeCaption_12 => 12.0;
  double get sizeCaption_10 => 10.0;
  double get sizeMinimal => 8.0;

  // size icon
  double get iconSize_32 => 32.0;
  double get iconSize_24 => 24.0;
  double get iconSize_16 => 16.0;

  // height
  double get height4 => 4;
  double get height8 => 8;
  double get height32 => 32;

  // svg size
  double get svgSize14 => 14;
  double get svgSize16 => 16;
  double get svgSize18 => 18;
  double get svgSize20 => 20;
  double get svgSize22 => 22;
  double get svgSize24 => 24;
}
