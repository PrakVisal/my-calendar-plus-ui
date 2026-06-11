import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// App typography system using the Google Fonts package for a premium UI feel.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle _baseStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  // Headings
  static TextStyle h1(BuildContext context) => _baseStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.getTextPrimary(context),
        height: 1.2,
      );

  static TextStyle h2(BuildContext context) => _baseStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.getTextPrimary(context),
        height: 1.3,
      );

  static TextStyle subtitle(BuildContext context) => _baseStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.getTextSecondary(context),
      );

  // Body Styles
  static TextStyle body(BuildContext context) => _baseStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.getTextPrimary(context),
        height: 1.5,
      );

  static TextStyle bodySecondary(BuildContext context) => _baseStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.getTextSecondary(context),
        height: 1.5,
      );

  static TextStyle bodyMedium(BuildContext context) => _baseStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.getTextPrimary(context),
      );

  static TextStyle caption(BuildContext context) => _baseStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.getTextMuted(context),
      );

  static TextStyle captionMedium(BuildContext context) => _baseStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.getTextSecondary(context),
      );

  // Specialized styles
  static TextStyle badge(BuildContext context, {Color? color}) => _baseStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.getTextPrimary(context),
      );

  static TextStyle dayCell(BuildContext context, {required bool isSelected, required bool isCurrentMonth}) {
    return _baseStyle(
      fontSize: 14,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
      color: isSelected
          ? Colors.white
          : isCurrentMonth
              ? AppColors.getTextPrimary(context)
              : AppColors.getTextMuted(context),
    );
  }
}
