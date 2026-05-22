import 'package:flutter/material.dart';

class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: md, vertical: lg);
  static const EdgeInsets cardPadding = EdgeInsets.all(md);
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets listPadding = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets fieldPadding = EdgeInsets.symmetric(horizontal: md, vertical: sm);

  static const double cardRadius = 16;
  static const double buttonRadius = 12;
  static const double inputRadius = 12;
  static const double avatarSize = 48;
  static const double iconSize = 24;
  static const double drawerHeaderHeight = 180;
}
