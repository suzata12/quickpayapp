import 'package:flutter/material.dart';
import '../constants/colors.dart';

PreferredSizeWidget customAppBar(String title) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        fontFamily: 'Roboto',
        color: AppColors.primaryBlue,
      ),
    ),
    centerTitle: true,
    backgroundColor: AppColors.primaryBlue30,
    foregroundColor: Colors.white,
    elevation: 0,
  );
}
