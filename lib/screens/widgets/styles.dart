import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  // Colors
  static final Color primaryColor = Color(0xFFFF7F66); // Change as per your app's primary color

  // BODY TEXT
  static final bodyMedium = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static final bodyMedium2 = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: TextStyles.primaryColor,
  );

  // TOPIC FOR BODY, LIKE INSIDE CONTAINERS
  static final bodyLarge = GoogleFonts.roboto(
    fontSize: 16,
    letterSpacing: 0.15,
    fontWeight: FontWeight.normal,
  );

  // LABELS
  static final labelSmall = GoogleFonts.roboto(
    fontSize: 11,
  );

  // LABEL HEADERS
  static final labelLarge = GoogleFonts.roboto(
    fontSize: 14,
  );

  // TITLE STYLE
  static final titleLarge = GoogleFonts.roboto(
    fontSize: 22,
    fontWeight: FontWeight.w500,
  ); // Used for main page titles

  static final customTextStyle = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  // HEADLINES
  static final headlineLarge = GoogleFonts.roboto(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  ); // Used for section titles

  static final captions = GoogleFonts.roboto(
    fontSize: 14,
    color: Colors.black.withOpacity(0.5),
  ); // Used for section titles
}
