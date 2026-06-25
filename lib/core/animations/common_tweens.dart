import 'package:flutter/material.dart';
import 'app_curves.dart';

class CommonTweens {
  CommonTweens._();

  static final Tween<Offset> slideUp = Tween<Offset>(
    begin: const Offset(0, 0.3),
    end: Offset.zero,
  );

  static final Tween<Offset> slideUpSmall = Tween<Offset>(
    begin: const Offset(0, 0.08),
    end: Offset.zero,
  );

  static final Tween<Offset> slideUpLarge = Tween<Offset>(
    begin: const Offset(0, 0.4),
    end: Offset.zero,
  );

  static final Tween<double> fadeIn = Tween<double>(
    begin: 0.0,
    end: 1.0,
  );

  static final Tween<double> scaleIn = Tween<double>(
    begin: 0.85,
    end: 1.0,
  );

  static final Tween<double> scaleOut = Tween<double>(
    begin: 1.0,
    end: 0.95,
  );

  static final Tween<double> scaleSplash = Tween<double>(
    begin: 0.95,
    end: 1.05,
  );

  static final Tween<double> shimmerShift = Tween<double>(
    begin: -2.0,
    end: 2.0,
  );

  static Animation<double> slideUpFadeInCurved(AnimationController parent) {
    return CurvedAnimation(parent: parent, curve: AppCurves.easeOutCubic);
  }
}
