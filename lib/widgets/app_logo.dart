import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  final bool isHero;
  final double? size;
  final bool showText;
  final Color? textColor;

  const AppLogo({
    super.key,
    this.isHero = false,
    this.size,
    this.showText = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // Compact normal size for headers / after login
    final double iconSize = size ?? (isHero ? 72 : 28);
    final double boxSize = isHero ? iconSize + 28 : iconSize + 10;

    Widget logoBox = Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        color: AppTheme.eclipse,
        borderRadius: BorderRadius.circular(isHero ? 22 : 10),
        border: Border.all(
          color: AppTheme.almond.withValues(alpha: 0.6),
          width: isHero ? 2 : 1,
        ),
        boxShadow: isHero
            ? [
                BoxShadow(
                  color: AppTheme.eclipse.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(isHero ? 8 : 4),
          child: SvgPicture.asset(
            'assets/cool.svg',
            width: iconSize,
            height: iconSize,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    if (!showText) {
      return logoBox;
    }

    Widget titleText = RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Cute',
            style: TextStyle(
              fontSize: isHero ? 32 : 20,
              fontWeight: FontWeight.w800,
              color: textColor ?? AppTheme.textPrimary,
              letterSpacing: -0.4,
            ),
          ),
          TextSpan(
            text: 'buddie',
            style: TextStyle(
              fontSize: isHero ? 32 : 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.matchaBrew,
              letterSpacing: -0.4,
            ),
          ),
        ],
      ),
    );

    // Hero Mode (Splash screen): Centered Column
    if (isHero) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Hero(
            tag: 'cutebuddie_logo_box',
            child: logoBox,
          ),
          const SizedBox(height: 16),
          titleText,
        ],
      );
    }

    // Normal Mode (After Login / App Headers): Compact Inline Row
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Hero(
          tag: 'cutebuddie_logo_box',
          child: logoBox,
        ),
        const SizedBox(width: 10),
        titleText,
      ],
    );
  }
}
