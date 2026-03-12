import 'screen_size.dart';

class AppSizes {
  /// Base helpers
  static double get screenWidth => ScreenSize.width;
  static double get screenHeight => ScreenSize.height;

  static double w(double value) => screenWidth * (value / 375); // design width
  static double h(double value) => screenHeight * (value / 812); // design height

  /// Radius
  static double get radiusSmall => w(10);
  static double get radiusMedium => w(14);
  static double get radiusLarge => w(18);
  static double get radiusXLarge => w(20);
  static double get profileRadius => w(48);

  /// General spacing
  static double get space4 => h(4);
  static double get space6 => h(6);
  static double get space8 => h(8);
  static double get space10 => h(10);
  static double get space12 => h(12);
  static double get space14 => h(14);
  static double get space16 => h(16);
  static double get space18 => h(18);
  static double get space20 => h(20);
  static double get space24 => h(24);

  /// Padding
  static double get pagePadding => w(16);
  static double get cardPadding => w(12);
  static double get cardPaddingLarge => w(14);
  static double get horizontalPadding => w(20);
  static double get horizontalPaddingSmall => w(12);

  /// Heights / widths
  static double get statCardWidth => w(78);
  static double get statCardHeight => h(90);
  static double get metricCardHeight => h(110);
  static double get chartHeight => h(210);
  static double get smallIconBox => w(22);
  static double get onlineDot => w(8);

  /// Font sizes
  static double get fs10 => w(10);
  static double get fs11 => w(11);
  static double get fs12 => w(12);
  static double get fs13 => w(13);
  static double get fs14 => w(14);
  static double get fs15 => w(15);
  static double get fs16 => w(16);
  static double get fs18 => w(18);
  static double get fs20 => w(20);
  static double get fs26 => w(26);

  /// Existing sizes
  static double get logoSize => screenHeight * 0.1;
  static double get buttonHeight => screenHeight * 0.065;
  static double get spaceSmall => screenHeight * 0.015;
  static double get spaceMedium => screenHeight * 0.03;
  static double get spaceMedium1 => screenHeight * 0.03;
  static double get spaceLarge => screenHeight * 0.05;
  static double get horizontalPadding1 => screenWidth * 0.04;
  static double get socialIcon => screenHeight * 0.035;
}