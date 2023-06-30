import 'package:flutter/material.dart';

const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
  50: Color(0xFFFAE7E7),
  100: Color(0xFFF3C3C4),
  200: Color(0xFFEC9B9D),
  300: Color(0xFFE47275),
  400: Color(0xFFDE5458),
  500: Color(_primaryPrimaryValue),
  600: Color(0xFFD43034),
  700: Color(0xFFCE292C),
  800: Color(0xFFC82225),
  900: Color(0xFFBF1618),
});
const int _primaryPrimaryValue = 0xFFD8363A;

const MaterialColor primaryAccent = MaterialColor(_primaryAccentValue, <int, Color>{
  100: Color(0xFFFFF1F1),
  200: Color(_primaryAccentValue),
  400: Color(0xFFFF8B8C),
  700: Color(0xFFFF7173),
});
const int _primaryAccentValue = 0xFFFFBEBE;