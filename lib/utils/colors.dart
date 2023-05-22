import 'package:flutter/material.dart';

const Color cWhite = Color(0xffffffff);
const Color cSnow = Color(0xffFAFAFA);
const Color cAccent = cSunGlow;
const Color cUfoGreen = Color(0xff32D777);
const Color cCharleston = Color(0xff23262F);
const Color cOnyx = Color(0xff353945);
const Color cMintCream = Color(0xffF5FFF9);
const Color cCultured = Color(0xffF7F7F8);
const Color cSlateGray = Color(0xff777E90);
const Color cSonicSilver = Color(0xffBBBBBC);
const Color cDeepCarminePink = Color(0xffFF2E2E);
const Color cGainsboro = Color(0xffDDDDDD);
const Color cBlack = Color(0xff000000);
const Color cRedPigment = Color(0xffF31629);
const Color cSunGlow = Color(0xfffcd535);
const Color cSunGlowDark = Color(0xff655515);
const Color cBoldYellow = Color(0xFFEAC41C);

const Color cOrange = Color(0xFFFFA400);

const List<Color> bgGradientColors = <Color>[
  Color(0xFFFEEEAE),
  Color(0xFFFEEA9A),
  Color(0xFFFDE686),
  Color(0xFFFDE272),
  Color(0xFFFDDD5D),
  Color(0xFFfcd535)
];
const List<Color> bgGradientDarkColors = <Color>[
  Color(0xFFE0DDD0),
  Color(0xFFD1CCB9),
  Color(0xFFC1BBA1),
  Color(0xFFB2AA8A),
  Color(0xFFA39973),
  Color(0xFF847744)
];

int getColorFromHex(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll('#', '');
  if (hexColor.length == 6) {
    hexColor = 'FF$hexColor';
  }
  return int.parse(hexColor, radix: 16);
}
