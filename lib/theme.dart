import 'package:flutter/material.dart';
import 'package:quickpay_app/constants/colors.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primaryBlue,
  scaffoldBackgroundColor: Colors.white,
  fontFamily: 'Roboto',
  textTheme: TextTheme(
    bodyLarge: TextStyle(fontSize: 16.0, color: AppColors.primaryBlue),
    titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryBlue,
    elevation: 2,
    titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(vertical: 14),
      textStyle: const TextStyle(fontSize: 16),
    ),
  ),
);
