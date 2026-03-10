import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppStyles {
  /// Specific requested style from design:
  /// Font: Poppins
  /// Weight: 600 (SemiBold)
  /// Size: 22px
  /// Line height: 100% (height: 1.0)
  /// Letter spacing: 0%
  static TextStyle headlinePoppins = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.0, // 100% line height
    letterSpacing: 0,
    color: AppColors.black,
  );

  /// Helper method for creating generic Poppins styles quickly
  static TextStyle poppins({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.black,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}
