import 'package:flutter/material.dart';

const kcWhite = Colors.white;
const kcBlack = Colors.black;

// Dark theme colors
const kcBgDark = Color(0xFF1C1C2E);
const kcCardDark = Color(0xFF252540);
const kcCardDark2 = Color(0xFF2D2D4A);
const kcAccent = Color(0xFF00E6A0);
const kcAccentLight = Color(0xFF1A3D35);
const kcPurpleAccent = Color(0xFF7B61FF);

// Legacy (used throughout codebase)
const kcPrimary = Color(0xFF00E6A0);
const kcPrimaryLight = Color(0xFF2D6A9F);
const kcPrimaryDark = Color(0xFF0F2439);
const kcOrange = Color(0xFFFF7A50);
const kcOrangeLight = Color(0xFF3D2A23);
const kcLightYellow = Color(0xFFFFC947);
const kcBgHome1 = Color(0xFF1C1C2E);
const kcBgHome2 = Color(0xFF252540);
const kcGreen = Color(0xFF00E6A0);
const kcGreenLight = Color(0xFF1A3D35);
const kcPurple = Color(0xFF7B61FF);
const kcPurpleLight = Color(0xFF2D2850);
const kcBlue = Color(0xFF4A90D9);
const kcBlueLight = Color(0xFF1E2D45);
const kcRed = Color(0xFFFF5C5C);
const kcGreyLabel = Color(0xFF6B6B8A);
const kcOutlineTextField = Color(0xFF3A3A55);
const kcSignIn = Color(0xFF454F63);
const kcFb = Color(0xFF3B5998);
const kcHintTextSearch = Color(0xFF4A4A65);
const kcRequestPickupDescrp = Color(0xFF626262);
const kcUnderlineBorder = Color(0xFF3A3A55);
const kcLabelColor = Color(0xFF6B6B8A);
const kcServiceBg = Color(0xFF2D2D4A);
const kcSubtitleService = Color(0xFFB0B0CC);
const kcDivider = Color(0xFF2D2D4A);
const kctextTitle = Color(0xFFE0E0F0);
const kctextDark = Color(0xFFF0F0FF);
const kctextgrey = Color(0xFF8888A8);
const kctextpurplepink = Color(0xFFC430A2);
const kccontainerPink = Color(0xFFFFE5FF);
const kcsubtitleListTile1 = Color(0xFF8888A8);
const kcsubtitleListTile2 = Color(0xFF6B6B8A);
const kcProfit = Color(0xFF00E6A0);
const kcsubtitle3 = Color(0xFF8888A8);
const ktest = Color(0xFFE0E0F0);
const kcCardShadow = Color(0x00000000);
const kcBorder = Color(0xFF3A3A55);

final kcboxshadow = const Color(0xFF000000).withOpacity(0.15);

MaterialColor kcprimarySwatch = createMaterialColor(kcPrimary);
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;
  for (int i = 1; i < 10; i++) strengths.add(0.1 * i);
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(), 1,
    );
  }
  return MaterialColor(color.value, swatch);
}
