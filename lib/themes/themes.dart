import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0.3,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actionsIconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            fontFamily: GoogleFonts.dancingScript().fontFamily)),
    textTheme: TextTheme(
      bodyText1: TextStyle(
          color: Colors.white, fontFamily: GoogleFonts.lato().fontFamily),
    ),
    fontFamily: GoogleFonts.lato().fontFamily,
    canvasColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.black),
    primaryColor: Colors.black,
    primaryColorLight: Colors.grey.shade200,
    primaryColorDark: Colors.grey.shade900,
    highlightColor: const Color.fromARGB(255, 241, 207, 218),
    indicatorColor: Colors.blue.shade100,
    dialogTheme: const DialogTheme(
        backgroundColor: Colors.white,
        iconColor: Colors.black,
        titleTextStyle: TextStyle(color: Colors.black)),
    bottomSheetTheme:
        BottomSheetThemeData(backgroundColor: Colors.grey.shade200),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        showSelectedLabels: false,
        backgroundColor: Colors.grey.shade200,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black));

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0.3,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            fontFamily: GoogleFonts.dancingScript().fontFamily)),
    textTheme: TextTheme(
      bodyText1: TextStyle(
          color: Colors.black, fontFamily: GoogleFonts.lato().fontFamily),
    ),
    fontFamily: GoogleFonts.lato().fontFamily,
    canvasColor: Colors.black,
    highlightColor: const Color.fromARGB(255, 74, 31, 45),
    indicatorColor: Color.fromARGB(255, 19, 33, 44),
    primaryColorLight: Colors.grey.shade900,
    primaryColorDark: Colors.grey.shade200,
    iconTheme: const IconThemeData(color: Colors.white),
    primaryColor: Colors.white,
    dialogTheme: const DialogTheme(
        backgroundColor: Colors.black,
        iconColor: Colors.white,
        titleTextStyle: TextStyle(color: Colors.white)),
    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color.fromARGB(255, 42, 42, 42)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        showSelectedLabels: false,
        backgroundColor: Colors.grey.shade900,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white));
