import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

/// A premium icon button that provides a "squeeze" scale animation
/// A premium icon button that provides a "squeeze" scale animation,
/// subtle hover feedback, and light haptic feedback when pressed.
class TactileIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final Color? color;
  final Color? hoverColor;
  final Color? backgroundColor;
  final Color? hoverBackgroundColor;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final EdgeInsets padding;
  final bool showHoverHighlight;
  final String? tooltip;

  const TactileIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 28,
    this.color,
    this.hoverColor,
    this.backgroundColor,
    this.hoverBackgroundColor,
    this.borderRadius,
    this.border,
    this.padding = const EdgeInsets.all(12.0),
    this.showHoverHighlight = true,
    this.tooltip,
  });

  @override
  State<TactileIconButton> createState() => _TactileIconButtonState();
}

class _TactileIconButtonState extends State<TactileIconButton> {
  double _scale = 1.0;
  bool _isHovered = false;

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap == null) return;
    HapticFeedback.selectionClick();
    setState(() => _scale = 0.88);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
  }

  void _handleTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = widget.onTap != null;

    final effectiveScale = _scale < 1.0
        ? _scale
        : (_isHovered && isEnabled ? 1.06 : 1.0);

    final defaultHoverColor = widget.color != null
        ? Color.alphaBlend(colorScheme.onSurface.withValues(alpha: 0.25), widget.color!)
        : colorScheme.onSurface;

    final effectiveColor = !isEnabled
        ? (widget.color ?? colorScheme.onSurface).withValues(alpha: 0.3)
        : (_isHovered
            ? (widget.hoverColor ?? defaultHoverColor)
            : (widget.color ?? colorScheme.onSurface));

    final effectiveBgColor = widget.backgroundColor != null
        ? (_isHovered && isEnabled
            ? (widget.hoverBackgroundColor ??
                Color.alphaBlend(
                    colorScheme.onSurface.withValues(alpha: 0.08),
                    widget.backgroundColor!))
            : widget.backgroundColor)
        : (_isHovered && isEnabled && widget.showHoverHighlight
            ? (widget.hoverBackgroundColor ??
                colorScheme.onSurface.withValues(alpha: 0.08))
            : Colors.transparent);

    final effectiveRadius = widget.borderRadius ?? BorderRadius.circular(widget.size + 12);

    Widget content = MouseRegion(
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: effectiveScale,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: Opacity(
            opacity: isEnabled ? 1.0 : 0.38,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                color: effectiveBgColor,
                borderRadius: effectiveRadius,
                border: widget.border,
                boxShadow: (_isHovered && isEnabled && widget.size >= 40)
                    ? [
                        BoxShadow(
                          color: (widget.color ?? colorScheme.primary).withValues(alpha: 0.30),
                          blurRadius: 16,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: Padding(
                padding: widget.padding,
                child: Icon(
                  widget.icon,
                  size: widget.size,
                  color: effectiveColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      content = Tooltip(
        message: widget.tooltip!,
        waitDuration: const Duration(milliseconds: 500),
        child: content,
      );
    }

    return content;
  }
}

/// A premium specialized Play/Pause button for PPPlayer.
/// Features a continuous kinetic choreography inspired by Google Material:
/// 1. PPPlayer logo starts spinning slowly and progressively increases speed (accelerating spin-up)
/// 2. At peak velocity, the rotational energy "turns on" the perimeter line in the Google Material way
/// 3. The line sweeps 360° around the perimeter with a glowing comet head, while the center morphs into the pause shape
/// 4. The line completes the full circle, closes seamlessly, and collapses back into the center
/// 5. The circle transforms back into the PPPlayer logo, which smoothly decelerates to rest
class TactilePlayerPlayPauseButton extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback? onTap;
  final double size;
  final Color? activeGlowColor;
  final String? tooltip;

  const TactilePlayerPlayPauseButton({
    super.key,
    required this.isPlaying,
    this.onTap,
    this.size = 64,
    this.activeGlowColor,
    this.tooltip,
  });

  @override
  State<TactilePlayerPlayPauseButton> createState() => _TactilePlayerPlayPauseButtonState();
}

class _TactilePlayerPlayPauseButtonState extends State<TactilePlayerPlayPauseButton>
    with TickerProviderStateMixin {
  late AnimationController _transitionController;
  late AnimationController _loopController;
  double _scale = 1.0;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
      value: widget.isPlaying ? 1.0 : 0.0,
    );

    // 8.0-second accelerating spin-up loop:
    // 0.00 - 0.15: Rest & gentle start (1.2s)
    // 0.15 - 0.45: Spin slow -> accelerating to high speed (2.4s)
    // 0.45 - 0.70: High speed "turns on" Google Material 360° perimeter line & center morphs to pause (2.0s)
    // 0.70 - 0.85: Circle completes, closes, and contracts inward (1.2s)
    // 0.85 - 1.00: Logo re-emerges & smoothly decelerates to rest (1.2s)
    _loopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    );

    if (widget.isPlaying) {
      _loopController.repeat();
    }
  }

  @override
  void didUpdateWidget(TactilePlayerPlayPauseButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _transitionController.forward();
        _loopController.repeat();
      } else {
        _transitionController.reverse();
        _loopController.animateTo(0.0, duration: const Duration(milliseconds: 250));
      }
    }
  }

  @override
  void dispose() {
    _transitionController.dispose();
    _loopController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap == null) return;
    HapticFeedback.mediumImpact();
    setState(() => _scale = 0.90);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = widget.onTap != null;
    final effectiveScale = _scale < 1.0
        ? _scale
        : (_isHovered && isEnabled ? 1.06 : 1.0);

    final primaryThemeColor = widget.activeGlowColor ?? colorScheme.primary;

    final String tooltipMessage = widget.tooltip ??
        (widget.isPlaying ? 'Pause' : 'Play');

    Widget buttonContent = AnimatedBuilder(
      animation: Listenable.merge([_transitionController, _loopController]),
      builder: (context, _) {
        final transition = _transitionController.value;
        final loop = _loopController.value;

        double logoOpacity = 0.0;
        double logoAngle = 0.0;
        double logoScale = 1.0;

        double pauseOpacity = 0.0;
        double pauseScale = 1.0;

        double lineSweepAngle = 0.0; // 0 -> 2*pi
        double lineOpacity = 0.0;
        double morphProgress = 0.0; // 0 -> 1
        double lineContractProgress = 0.0; // 0 -> 1

        if (loop < 0.15) {
          // Phase 1: Rest & gentle initial creep (0% - 15%)
          final p = loop / 0.15;
          logoOpacity = 1.0;
          // Very gentle slow initial movement
          logoAngle = p * (math.pi / 8);
          logoScale = 1.0 + (0.02 * math.sin(p * math.pi));
          pauseOpacity = 0.0;
          lineOpacity = 0.0;
          morphProgress = 0.0;
        } else if (loop < 0.45) {
          // Phase 2: Accelerating spin-up ("spinning slow and increasing speed") (15% - 45%)
          final p = (loop - 0.15) / 0.30;
          // Ease-in quadratic curve: begins slow, accelerates rapidly to high angular velocity!
          final accel = Curves.easeInCubic.transform(p);
          logoOpacity = 1.0;
          // Spins through 2 full rotations, accelerating smoothly
          logoAngle = (math.pi / 8) + (accel * 4 * math.pi);
          logoScale = 1.0 + (0.08 * accel); // Slight expansion from centrifugal speed
          pauseOpacity = 0.0;
          lineOpacity = 0.0;
          morphProgress = 0.0;
        } else if (loop < 0.70) {
          // Phase 3: At peak speed, the spin "turns on" the Material 3 Expressive morphing line (45% - 70%)
          final p = (loop - 0.45) / 0.25;
          final easeSweep = Curves.fastOutSlowIn.transform(p);

          lineOpacity = 1.0;
          lineSweepAngle = easeSweep * 2 * math.pi;
          lineContractProgress = 0.0;
          morphProgress = p;

          // In the center, spinning logo smoothly transforms into the springy Pause shape:
          final morphP = (p * 2.2).clamp(0.0, 1.0);
          final morphEase = Curves.easeInOutCubic.transform(morphP);
          logoOpacity = (1.0 - morphEase);
          logoAngle = (math.pi / 8) + (4 * math.pi) + (p * 2 * math.pi); // Continues gliding
          pauseOpacity = morphEase;
          pauseScale = 0.86 + (0.14 * Curves.easeOutBack.transform(morphP));
        } else if (loop < 0.85) {
          // Phase 4: Full shape completes 360°, closes, and contracts inward (70% - 85%)
          final p = (loop - 0.70) / 0.15;
          final easeContract = Curves.easeInOutCubic.transform(p);

          lineSweepAngle = 2 * math.pi;
          lineContractProgress = easeContract;
          lineOpacity = 1.0 - easeContract;
          morphProgress = 1.0;

          // Center pause shape dissolves out as energy collapses:
          pauseOpacity = 1.0 - easeContract;
          pauseScale = 1.0 - (0.08 * easeContract);

          // PPPlayer logo emerges from the center energy:
          logoOpacity = easeContract;
          logoScale = 0.86 + (0.14 * easeContract);
          logoAngle = 0.0;
        } else {
          // Phase 5: PPPlayer Logo re-emerges & smoothly decelerates to rest (85% - 100%)
          final p = (loop - 0.85) / 0.15;
          final decel = Curves.easeOutCubic.transform(p);

          logoOpacity = 1.0;
          logoScale = 0.86 + (0.14 * Curves.easeOutBack.transform(p));
          // Smooth final deceleration to 0
          logoAngle = (1.0 - decel) * (math.pi / 6);
          pauseOpacity = 0.0;
          lineOpacity = 0.0;
          morphProgress = 0.0;
        }

        // Base container background:
        // Paused: Solid primaryThemeColor circle
        // Playing: Fully transparent (clean floating logo without disc or shadow)
        final bgColor = Color.lerp(
          primaryThemeColor,
          Colors.transparent,
          transition,
        )!;

        final iconSize = widget.size * 0.52;
        final logoSize = widget.size * 0.60;

        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              // Fluid Morph Painter (Draws the base container and the Material 3 Expressive morphing line)
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _MaterialSpinLinePainter(
                  transition: transition,
                  backgroundColor: bgColor,
                  color: primaryThemeColor,
                  lineOpacity: lineOpacity * transition,
                  lineSweepAngle: lineSweepAngle,
                  morphProgress: morphProgress,
                  lineContractProgress: lineContractProgress,
                ),
              ),

              // Center Content: Paused Play Icon / Spinning Logo / Morphing Pause
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 1. Paused State: Solid play icon
                    if (transition < 0.99)
                      Opacity(
                        opacity: (1.0 - transition).clamp(0.0, 1.0),
                        child: Transform.scale(
                          scale: 1.0 - (0.15 * transition),
                          child: Padding(
                            padding: EdgeInsets.only(left: widget.size * 0.04), // Optical center
                            child: Icon(
                              Icons.play_arrow_rounded,
                              size: iconSize,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),

                    // 2. Playing State: Spinning & Accelerating PPPlayer Logo
                    if (transition > 0.01 && logoOpacity > 0.01)
                      Opacity(
                        opacity: (logoOpacity * transition).clamp(0.0, 1.0),
                        child: Transform.scale(
                          scale: logoScale,
                          child: Transform.rotate(
                            angle: logoAngle,
                            child: Image.asset(
                              'assets/logo.png',
                              width: logoSize,
                              height: logoSize,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                    // 3. Playing State: Transformed Pause Glyph
                    if (transition > 0.01 && pauseOpacity > 0.01)
                      Opacity(
                        opacity: (pauseOpacity * transition).clamp(0.0, 1.0),
                        child: Transform.scale(
                          scale: pauseScale,
                          child: Icon(
                            Icons.pause_rounded,
                            size: iconSize * 0.95,
                            color: primaryThemeColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Hover Overlay: Immediate Pause Affordance
              if (transition > 0.5)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 160),
                  opacity: (_isHovered && isEnabled) ? 1.0 : 0.0,
                  curve: Curves.easeOut,
                  child: Center(
                    child: Container(
                      width: widget.size * 0.76,
                      height: widget.size * 0.76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withValues(alpha: 0.60),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.pause_rounded,
                          size: iconSize * 0.90,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );

    return MouseRegion(
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Tooltip(
        message: tooltipMessage,
        waitDuration: const Duration(milliseconds: 600),
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: (_) => setState(() => _scale = 1.0),
          onTapCancel: () => setState(() => _scale = 1.0),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: effectiveScale,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOutCubic,
            child: Opacity(
              opacity: isEnabled ? 1.0 : 0.5,
              child: buttonContent,
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter that executes Material 3 Expressive dynamic shape morphing:
/// - Base smooth circular disc
/// - Faint 360° M3 organic morphing track (clover -> squircle -> fluid wave)
/// - Active traveling line flexing and morphing elastically along the lobes
/// - Glowing leading comet head with radial soft blur
/// - Elastic inward contraction
class _MaterialSpinLinePainter extends CustomPainter {
  final double transition;
  final Color backgroundColor;
  final Color color;
  final double lineOpacity;
  final double lineSweepAngle; // 0.0 -> 2*pi
  final double morphProgress; // 0.0 -> 1.0 (clover -> squircle -> fluid wave -> circle)
  final double lineContractProgress; // 0.0 -> 1.0

  _MaterialSpinLinePainter({
    required this.transition,
    required this.backgroundColor,
    required this.color,
    required this.lineOpacity,
    required this.lineSweepAngle,
    required this.morphProgress,
    required this.lineContractProgress,
  });

  /// Computes the dynamic Material 3 Expressive morphing radius at any given angle theta.
  /// Seamlessly interpolates between:
  /// - 4-lobed expressive clover (deep pillowy lobes)
  /// - Expressive rounded squircle (rotated 45°)
  /// - Undulating organic fluid wave (liquid inertia)
  /// - Settled closed perimeter
  double _computeRadius({
    required double theta,
    required double baseRadius,
  }) {
    final rBase = baseRadius * (1.0 - 0.45 * lineContractProgress);

    // Harmonic 1: 4-lobed Expressive Clover (deep, pillowy rounded petals)
    final clover = math.cos(4 * theta);

    // Harmonic 2: Expressive Squircle (45-degree rotated superellipse)
    final squircle = math.cos(4 * theta - math.pi);

    // Harmonic 3: Elastic travelling ripple / fluid undulation
    final fluidWave = math.sin(3 * theta + morphProgress * 2 * math.pi) * 0.75 +
        math.cos(2 * theta - morphProgress * 1.5 * math.pi) * 0.4;

    // Weightings evolving across morphProgress (0.0 -> 1.0):
    final wClover = math.max(0.0, 1.0 - (morphProgress / 0.45));
    final wSquircle = math.sin((morphProgress * math.pi).clamp(0.0, math.pi));
    final wFluid = math.sin((morphProgress * 1.3 * math.pi).clamp(0.0, math.pi)) * 0.85;

    final deviation = (0.14 * wClover * clover) +
        (0.12 * wSquircle * squircle) +
        (0.09 * wFluid * fluidWave);

    return rBase * (1.0 + deviation);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final discRadius = size.width / 2;
    final baseRadius = discRadius * 0.84;

    // 1. Draw base disc container only while paused or transitioning
    if (backgroundColor.a > 0.005) {
      final basePaint = Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, discRadius, basePaint);
    }

    // 2. Draw Material 3 Expressive Dynamic Morphing Line (only while active)
    if (lineOpacity > 0.01 && lineSweepAngle > 0.01) {
      const startAngle = -math.pi / 2;
        final strokePaint = Paint()
          ..color = color.withValues(alpha: lineOpacity.clamp(0.0, 1.0))
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 2.8;

        final linePath = Path();
        final lineSamples = (80 * (lineSweepAngle / (2 * math.pi))).clamp(8, 120).toInt();
        for (int i = 0; i <= lineSamples; i++) {
          final fraction = i / lineSamples;
          final theta = startAngle + lineSweepAngle * fraction;
          final r = _computeRadius(theta: theta, baseRadius: baseRadius);
          final x = center.dx + r * math.cos(theta);
          final y = center.dy + r * math.sin(theta);
          if (i == 0) {
            linePath.moveTo(x, y);
          } else {
            linePath.lineTo(x, y);
          }
        }
        canvas.drawPath(linePath, strokePaint);

        // Glowing leading tip with soft radial aura
        if (lineSweepAngle < (2 * math.pi - 0.04) && lineContractProgress < 0.05) {
          final headAngle = startAngle + lineSweepAngle;
          final headR = _computeRadius(theta: headAngle, baseRadius: baseRadius);
          final tipX = center.dx + headR * math.cos(headAngle);
          final tipY = center.dy + headR * math.sin(headAngle);

          final tipPaint = Paint()
            ..color = color.withValues(alpha: lineOpacity.clamp(0.0, 1.0))
            ..style = PaintingStyle.fill;
          canvas.drawCircle(Offset(tipX, tipY), 2.8, tipPaint);

          final tipGlow = Paint()
            ..color = color.withValues(alpha: 0.55 * lineOpacity.clamp(0.0, 1.0))
            ..style = PaintingStyle.fill
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
          canvas.drawCircle(Offset(tipX, tipY), 4.8, tipGlow);
        }
      }
    }

  @override
  bool shouldRepaint(covariant _MaterialSpinLinePainter oldDelegate) {
    return oldDelegate.transition != transition ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.color != color ||
        oldDelegate.lineOpacity != lineOpacity ||
        oldDelegate.lineSweepAngle != lineSweepAngle ||
        oldDelegate.morphProgress != morphProgress ||
        oldDelegate.lineContractProgress != lineContractProgress;
  }
}

/// A signature green play button used in list headers (Radio, Genre, Playlist)
/// with tactile feedback, hover glow, and animations.
class TactileActionPlayButton extends StatefulWidget {
  final VoidCallback? onTap;
  final double size;
  final IconData? icon;

  const TactileActionPlayButton({
    super.key,
    this.onTap,
    this.size = 56,
    this.icon,
  });

  @override
  State<TactileActionPlayButton> createState() => _TactileActionPlayButtonState();
}

class _TactileActionPlayButtonState extends State<TactileActionPlayButton> {
  double _scale = 1.0;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = widget.onTap != null;
    final effectiveScale = _scale < 1.0
        ? _scale
        : (_isHovered && isEnabled ? 1.05 : 1.0);

    return MouseRegion(
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) {
          if (widget.onTap == null) return;
          HapticFeedback.lightImpact();
          setState(() => _scale = 0.90);
        },
        onTapUp: (_) => setState(() => _scale = 1.0),
        onTapCancel: () => setState(() => _scale = 1.0),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: effectiveScale,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutBack,
          child: Opacity(
            opacity: isEnabled ? 1.0 : 0.5,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              curve: Curves.easeOutCubic,
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary, // Dynamic Theme Color
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: _isHovered ? 0.55 : 0.45),
                    blurRadius: _isHovered ? 18 : 12,
                    offset: Offset(0, _isHovered ? 8 : 6),
                  ),
                ],
              ),
              child: Icon(
                widget.icon ?? Icons.play_arrow_rounded,
                size: widget.size * 0.7,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
/// A wrapper that adds premium scale animation and haptic feedback to any child.
/// Use this for cards, list items, and other large interactive areas.
class TactileTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scaleDown;
  final HapticFeedbackType hapticType;

  const TactileTap({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scaleDown = 0.95,
    this.hapticType = HapticFeedbackType.selection,
  });

  @override
  State<TactileTap> createState() => _TactileTapState();
}

enum HapticFeedbackType { selection, light, medium, heavy }

class _TactileTapState extends State<TactileTap> {
  double _scale = 1.0;

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap == null) return;
    switch (widget.hapticType) {
      case HapticFeedbackType.selection:
        HapticFeedback.selectionClick();
        break;
      case HapticFeedbackType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.heavy:
        HapticFeedback.heavyImpact();
        break;
    }
    setState(() => _scale = widget.scaleDown);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
  }

  void _handleTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final isInteractive = widget.onTap != null || widget.onLongPress != null;
    return MouseRegion(
      cursor: isInteractive ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}

/// A wrapper that detects mouse hover and displays a play button overlay.
class HoverPlayOverlay extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPlay;
  final double size;
  final bool? isHovered;
  final bool isPlaying;
  final IconData? icon;

  const HoverPlayOverlay({
    super.key,
    required this.child,
    this.onPlay,
    this.size = 48,
    this.isHovered,
    this.isPlaying = false,
    this.icon,
  });

  @override
  State<HoverPlayOverlay> createState() => _HoverPlayOverlayState();
}

class _HoverPlayOverlayState extends State<HoverPlayOverlay> {
  bool _internalHovered = false;

  @override
  Widget build(BuildContext context) {
    final effectiveHover = widget.isHovered ?? _internalHovered;
    final showButton = effectiveHover || widget.isPlaying;

    return MouseRegion(
      onEnter: (_) => setState(() => _internalHovered = true),
      onExit: (_) => setState(() => _internalHovered = false),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          widget.child,
          if (widget.onPlay != null)
            Positioned(
              right: 8,
              bottom: 8,
              child: IgnorePointer(
                ignoring: !showButton,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: showButton ? 1.0 : 0.0,
                  curve: Curves.easeOut,
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 200),
                    offset: showButton ? Offset.zero : const Offset(0, 0.25),
                    curve: Curves.easeOutCubic,
                    child: TactileActionPlayButton(
                      onTap: widget.onPlay,
                      size: widget.size,
                      icon: widget.icon ?? (widget.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class HoverText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final VoidCallback onTap;
  final int maxLines;

  const HoverText({
    super.key,
    required this.text,
    required this.style,
    required this.onTap,
    this.maxLines = 1,
  });

  @override
  State<HoverText> createState() => _HoverTextState();
}

class _HoverTextState extends State<HoverText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.text,
          maxLines: widget.maxLines,
          overflow: TextOverflow.ellipsis,
          style: widget.style.copyWith(
            decoration: _isHovered ? TextDecoration.underline : TextDecoration.none,
            color: _isHovered ? Theme.of(context).colorScheme.primary : widget.style.color,
          ),
        ),
      ),
    );
  }
}
