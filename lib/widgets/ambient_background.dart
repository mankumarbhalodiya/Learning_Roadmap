import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AmbientBackground extends StatefulWidget {
  final Widget child;

  const AmbientBackground({
    super.key,
    required this.child,
  });

  @override
  State<AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<AmbientBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        final floatOffset1 = math.sin(progress * math.pi * 2) * 16;
        final floatOffset2 = math.cos(progress * math.pi * 2) * 18;

        return Stack(
          children: [
            // Background Base
            Container(color: AppTheme.backgroundLight),

            // Top-Right Ambient Floating Glow
            Positioned(
              top: -60 + floatOffset1,
              right: -50 + floatOffset2,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.almond.withValues(alpha: 0.20),
                ),
              ),
            ),

            // Bottom-Left Ambient Floating Glow
            Positioned(
              bottom: 40 + floatOffset2,
              left: -80 + floatOffset1,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.matchaBrew.withValues(alpha: 0.12),
                ),
              ),
            ),

            // Main Screen Child
            widget.child,
          ],
        );
      },
    );
  }
}
