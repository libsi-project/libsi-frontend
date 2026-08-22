import 'package:jaspr/dom.dart';
import 'package:sidb/presentation/theme/app_theme.dart';

abstract final class NeoTokens {
  static const double pageMaxWidth = 1200;
  static const double pagePaddingX = 2;

  static const double radiusSm = 2;
  static const double radiusMd = 6;
  static const double radiusLg = 15;
  static const double radiusPill = 100;

  static const double borderThin = 2;
  static const double borderThick = 3;
  static const double borderStrong = 4;

  static const double shadowXs = 1;
  static const double shadowSm = 3;
  static const double shadowMd = 4;
  static const double shadowLg = 6;

  static const int motionFastMs = 100;
  static const int motionNormalMs = 150;
  static const int motionSlowMs = 200;

  static const String fontBody = 'Inter';
  static const String fontDisplay = 'Geologica';

  static Border border({
    double width = borderThin,
    Color color = AppTheme.borderColor,
  }) {
    return Border.all(width: width.px, color: color);
  }

  static BoxShadow shadow({
    double offset = shadowMd,
    Color color = AppTheme.borderColor,
  }) {
    return BoxShadow(
      offsetX: offset.px,
      offsetY: offset.px,
      blur: 0.px,
      spread: 0.px,
      color: color,
    );
  }

  static Transition transition([int durationMs = motionNormalMs]) {
    return Transition('all', duration: durationMs.ms);
  }

  static BorderRadius radius(double value) => BorderRadius.circular(value.px);

  static Padding pagePadding({
    double top = 0,
    double bottom = 0,
  }) {
    return Padding.only(
      left: pagePaddingX.rem,
      right: pagePaddingX.rem,
      top: top.rem,
      bottom: bottom.rem,
    );
  }
}

abstract final class NeoStyles {
  static Styles surface({
    Color background = AppTheme.surfaceColor,
    Color borderColor = AppTheme.borderColor,
    double borderWidth = NeoTokens.borderThick,
    double radius = NeoTokens.radiusMd,
    double shadow = NeoTokens.shadowLg,
    int transitionMs = NeoTokens.motionNormalMs,
  }) {
    return Styles(
      border: NeoTokens.border(width: borderWidth, color: borderColor),
      radius: NeoTokens.radius(radius),
      shadow: NeoTokens.shadow(offset: shadow, color: borderColor),
      transition: NeoTokens.transition(transitionMs),
      backgroundColor: background,
    );
  }

  static Styles pressed({
    Color borderColor = AppTheme.borderColor,
    double shadow = NeoTokens.shadowSm,
    double translate = NeoTokens.shadowSm,
  }) {
    return Styles(
      shadow: NeoTokens.shadow(offset: shadow, color: borderColor),
      transform: Transform.translate(x: translate.px, y: translate.px),
    );
  }

  static Styles text({
    Color color = AppTheme.textColor,
    String family = NeoTokens.fontBody,
    double size = 1,
    FontWeight weight = FontWeight.w700,
  }) {
    return Styles(
      color: color,
      fontFamily: FontFamily(family),
      fontSize: size.rem,
      fontWeight: weight,
    );
  }
}
