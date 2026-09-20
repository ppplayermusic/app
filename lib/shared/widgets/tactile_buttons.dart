import 'package:flutter/material.dart';
import 'package:ppplayer/l10n/app_localizations.dart';
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
        ? Color.alphaBlend(
            colorScheme.onSurface.withValues(alpha: 0.25),
            widget.color!,
          )
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
                      widget.backgroundColor!,
                    ))
              : widget.backgroundColor)
        : (_isHovered && isEnabled && widget.showHoverHighlight
              ? (widget.hoverBackgroundColor ??
                    colorScheme.onSurface.withValues(alpha: 0.08))
              : Colors.transparent);

    final effectiveRadius =
        widget.borderRadius ?? BorderRadius.circular(widget.size + 12);

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
                          color: (widget.color ?? colorScheme.primary)
                              .withValues(alpha: 0.30),
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
  final bool isLoading;
  final VoidCallback? onTap;
  final double size;
  final Color? activeGlowColor;
  final String? tooltip;

  const TactilePlayerPlayPauseButton({
    super.key,
    required this.isPlaying,
    this.isLoading = false,
    this.onTap,
    this.size = 64,
    this.activeGlowColor,
    this.tooltip,
  });

  @override
  State<TactilePlayerPlayPauseButton> createState() =>
      _TactilePlayerPlayPauseButtonState();
}

class _TactilePlayerPlayPauseButtonState
    extends State<TactilePlayerPlayPauseButton>
    with TickerProviderStateMixin {
  late AnimationController _transitionController;
  late AnimationController _loopController;
  late AnimationController _loadingController;
  double _scale = 1.0;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    // One-time Brand Ignition transition on Play (650ms forward, 250ms reverse on Pause)
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
      reverseDuration: const Duration(milliseconds: 250),
      value: widget.isPlaying ? 1.0 : 0.0,
    );

    // Continuous 3.6-second living Material 3 Expressive undulation during playback
    _loopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    if (widget.isPlaying) {
      _loopController.repeat();
    }
    
    if (widget.isLoading) {
      _loadingController.repeat();
    }
  }

  @override
  void didUpdateWidget(TactilePlayerPlayPauseButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _transitionController.forward(from: 0.0);
        _loopController.repeat();
      } else {
        _transitionController.reverse();
        _loopController.stop();
      }
    }

    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _loadingController.repeat();
      } else {
        _loadingController.stop();
      }
    }
  }

  @override
  void dispose() {
    _transitionController.dispose();
    _loopController.dispose();
    _loadingController.dispose();
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

    final String tooltipMessage =
        widget.tooltip ??
        (widget.isPlaying ? 'Pause' : AppLocalizations.of(context)!.play);

    Widget buttonContent = AnimatedBuilder(
      animation: Listenable.merge([_transitionController, _loopController, _loadingController]),
      builder: (context, _) {
        final transition = _transitionController.value;
        final isReversing =
            _transitionController.status == AnimationStatus.reverse;
        final loop = _loopController.value;

        double logoOpacity = 0.0;
        double logoAngle = 0.0;
        double logoScale = 1.0;

        double pauseOpacity = 0.0;
        double pauseMorphProgress = 0.0;

        double lineSweepAngle = 0.0; // 0 -> 2*pi
        double lineOpacity = 0.0;
        double morphProgress = 0.0; // 0 -> 1
        double lineContractProgress = 0.0;

        double pointOpacity = 0.0;
        double pointScale = 1.0;
        double spiralProgress = 0.0;
        double spiralTrailFade = 0.0;

        double pulseRadius = 0.0;
        double pulseOpacity = 0.0;

        if (isReversing) {
          // Instant direct reverse to Play without logo interruption
          pauseOpacity = transition;
          pauseMorphProgress = transition;
          lineOpacity = transition;
          lineSweepAngle = 2 * math.pi;
          morphProgress = loop;
          logoOpacity = 0.0;
        } else if (transition >= 0.999) {
          // Steady Playing State: Permanent, stable Pause bars & living M3 perimeter line
          pauseOpacity = 1.0;
          pauseMorphProgress = 1.0;
          lineOpacity = 1.0;
          lineSweepAngle = 2 * math.pi;
          morphProgress = loop;
          logoOpacity = 0.0;
          pointOpacity = 0.0;
        } else if (transition > 0.001) {
          // One-Time "Brand Ignition" Burst (0.0 -> 1.0)
          final p = transition;

          if (p < 0.20) {
            // Step 1: Play fades out, PPPlayer Logo blooms in
            final subP = p / 0.20;
            logoOpacity = subP;
            logoScale = Curves.easeOutBack.transform(subP).clamp(0.0, 1.15);
            logoAngle = 0.0;
            pauseOpacity = 0.0;
            lineOpacity = 0.0;
          } else if (p < 0.60) {
            // Step 2: PPPlayer Logo accelerating 360° spin & collapse into singularity
            final spinP = (p - 0.20) / 0.40;
            final accel = Curves.easeInOutCubic.transform(spinP);
            logoAngle = accel * 2 * math.pi;

            if (spinP < 0.50) {
              logoOpacity = 1.0;
              logoScale = 1.0 + (0.06 * accel);
              pointOpacity = 0.0;
            } else {
              final collapse = (spinP - 0.50) / 0.50;
              logoOpacity = (1.0 - collapse).clamp(0.0, 1.0);
              logoScale = (1.0 - Curves.easeInOutCubic.transform(collapse))
                  .clamp(0.01, 1.0);
              pointOpacity = Curves.easeInQuad.transform(collapse);
              pointScale = Curves.easeOutBack
                  .transform(collapse)
                  .clamp(0.0, 1.4);

              // Soft acoustic kinetic shockwave at the singularity collapse instant
              if (collapse >= 0.35) {
                final pulseP = (collapse - 0.35) / 0.65;
                pulseRadius = pulseP * (widget.size * 0.44);
                pulseOpacity = (1.0 - pulseP) * 0.40;
              }
            }
          } else {
            // Step 3: Singularity splits into permanent Pause bars & shoots energy to rim
            final splitP = (p - 0.60) / 0.40;
            logoOpacity = 0.0;
            pauseOpacity = 1.0;
            pauseMorphProgress = Curves.easeOutBack
                .transform(splitP)
                .clamp(0.0, 1.0);

            pointOpacity = (1.0 - splitP).clamp(0.0, 1.0);
            pointScale = 1.0 - (0.5 * splitP);

            // Archimedean spiral shoots to 12 o'clock and dissolves into perimeter sweep
            spiralProgress = Curves.easeOutCubic.transform(splitP);
            spiralTrailFade = (1.0 - splitP * 0.7).clamp(0.0, 1.0);

            lineOpacity = splitP;
            lineSweepAngle = splitP * 2 * math.pi;
            morphProgress = splitP;
          }
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
              // Fluid Morph Painter (Draws base container, morphing line, pause bars, and energy point)
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
                  pointOpacity: pointOpacity * transition,
                  pointScale: pointScale,
                  spiralProgress: spiralProgress,
                  spiralTrailFade: spiralTrailFade * transition,
                  pauseOpacity: widget.isLoading
                      ? 0.0
                      : (pauseOpacity * transition),
                  pauseMorphProgress: pauseMorphProgress,
                  pulseRadius: pulseRadius,
                  pulseOpacity: pulseOpacity * transition,
                ),
              ),

              // Center Content: Paused Play Icon / Ignition PPPlayer Logo
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Loading indicator
                    if (widget.isLoading)
                      Transform.rotate(
                        angle: _loadingController.value * 2 * math.pi,
                        child: Image.asset(
                          'assets/logo.png',
                          width: logoSize,
                          height: logoSize,
                          fit: BoxFit.contain,
                        ),
                      ),

                    // 1. Paused State: Solid play icon
                    if ((transition < 0.22 || isReversing) && !widget.isLoading)
                      Opacity(
                        opacity:
                            (isReversing
                                    ? (1.0 - transition)
                                    : (transition < 0.20
                                          ? (1.0 - transition / 0.20)
                                          : 0.0))
                                .clamp(0.0, 1.0),
                        child: Transform.scale(
                          scale: 1.0 - (0.15 * transition),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: widget.size * 0.04,
                            ), // Optical center
                            child: Icon(
                              Icons.play_arrow_rounded,
                              size: iconSize,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),

                    // 2. Ignition State: Spinning PPPlayer Logo
                    if (logoOpacity > 0.01 && !widget.isLoading)
                      Opacity(
                        opacity: logoOpacity.clamp(0.0, 1.0),
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
                  ],
                ),
              ),

              // Hover Overlay: Subtle Accent Glow
              if (transition > 0.5)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 160),
                  opacity: (_isHovered && isEnabled) ? 1.0 : 0.0,
                  curve: Curves.easeOut,
                  child: Center(
                    child: Container(
                      width: widget.size * 0.88,
                      height: widget.size * 0.88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryThemeColor.withValues(alpha: 0.12),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );

    return Semantics(
      button: true,
      label: widget.isLoading
          ? 'Loading'
          : (widget.isPlaying ? 'Pause' : 'Play'),
      hint: widget.isLoading ? 'Buffering media' : 'Toggle playback state',
      child: MouseRegion(
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
      ),
    );
  }
}

/// Custom painter that executes Material 3 Expressive dynamic shape morphing:
/// - Base smooth circular disc
/// - Fluid M3 organic morphing track (clover -> squircle -> fluid wave) with luminous filament glow
/// - Active traveling line with radiant leading comet head and soft blur halo
/// - Liquid mercury pause bars that separate with an organic droplet meniscus (metaball bridge)
/// - Acoustic shockwave ripple with soft gaussian atmospheric diffusion
/// - Curved Archimedean spiral vortex launch with smooth vapor trail dissolution
class _MaterialSpinLinePainter extends CustomPainter {
  final double transition;
  final Color backgroundColor;
  final Color color;
  final double lineOpacity;
  final double lineSweepAngle; // 0.0 -> 2*pi
  final double
  morphProgress; // 0.0 -> 1.0 (clover -> squircle -> fluid wave -> circle)
  final double lineContractProgress; // 0.0 -> 1.0
  final double pointOpacity; // 0.0 -> 1.0
  final double pointScale;
  final double spiralProgress; // 0.0 -> 1.0 (vortex spiral trajectory)
  final double spiralTrailFade; // 0.0 -> 1.0 (vapor trail dissolution into rim)
  final double pauseOpacity; // 0.0 -> 1.0
  final double
  pauseMorphProgress; // 0.0 -> 1.0 (magnetic capsule split with liquid bridge)
  final double pulseRadius;
  final double pulseOpacity;

  _MaterialSpinLinePainter({
    required this.transition,
    required this.backgroundColor,
    required this.color,
    required this.lineOpacity,
    required this.lineSweepAngle,
    required this.morphProgress,
    required this.lineContractProgress,
    required this.pointOpacity,
    required this.pointScale,
    required this.spiralProgress,
    required this.spiralTrailFade,
    required this.pauseOpacity,
    required this.pauseMorphProgress,
    required this.pulseRadius,
    required this.pulseOpacity,
  });

  /// Computes the dynamic Material 3 Expressive morphing radius at any given angle theta.
  /// Seamlessly interpolates between:
  /// - 4-lobed expressive clover (deep pillowy lobes)
  /// - Expressive rounded squircle (rotated 45°)
  /// - Undulating organic fluid wave (liquid inertia)
  /// - Settled closed perimeter
  double _computeRadius({required double theta, required double baseRadius}) {
    final rBase = baseRadius * (1.0 - 0.45 * lineContractProgress);

    // Harmonic 1: 4-lobed Expressive Clover (deep, pillowy rounded petals)
    final clover = math.cos(4 * theta);

    // Harmonic 2: Expressive Squircle (45-degree rotated superellipse)
    final squircle = math.cos(4 * theta - math.pi);

    // Harmonic 3: Elastic travelling ripple / fluid undulation
    final fluidWave =
        math.sin(3 * theta + morphProgress * 2 * math.pi) * 0.75 +
        math.cos(2 * theta - morphProgress * 1.5 * math.pi) * 0.4;

    // Weightings evolving across morphProgress (0.0 -> 1.0):
    final wClover = math.max(0.0, 1.0 - (morphProgress / 0.45));
    final wSquircle = math.sin((morphProgress * math.pi).clamp(0.0, math.pi));
    final wFluid =
        math.sin((morphProgress * 1.3 * math.pi).clamp(0.0, math.pi)) * 0.85;

    final deviation =
        (0.14 * wClover * clover) +
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

    // 2. Draw Kinetic Energy Shockwave Ripple (soft acoustic atmospheric glow)
    if (pulseOpacity > 0.01 && pulseRadius > 0.0) {
      final pulsePaint = Paint()
        ..color = color.withValues(
          alpha: (pulseOpacity * transition).clamp(0.0, 1.0),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
      canvas.drawCircle(center, pulseRadius, pulsePaint);

      final pulseCorePaint = Paint()
        ..color = color.withValues(
          alpha: (pulseOpacity * transition * 0.6).clamp(0.0, 1.0),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawCircle(center, pulseRadius, pulseCorePaint);
    }

    // 3. Draw Center Material Pause Bars (magnetic split/fusion with liquid droplet meniscus)
    if (pauseOpacity > 0.01) {
      final barWidth = size.width * 0.082;
      final barHeight = size.width * 0.30;
      final maxSpread = size.width * 0.105;
      final cornerRadius = Radius.circular(barWidth / 2);

      final currentSpread = maxSpread * pauseMorphProgress.clamp(0.0, 1.2);
      final currentHeight =
          barHeight * (0.35 + 0.65 * pauseMorphProgress.clamp(0.0, 1.0));

      final barPaint = Paint()
        ..color = color.withValues(
          alpha: (pauseOpacity * transition).clamp(0.0, 1.0),
        )
        ..style = PaintingStyle.fill;

      // Left bar
      final leftRect = Rect.fromCenter(
        center: Offset(center.dx - currentSpread, center.dy),
        width: barWidth,
        height: currentHeight,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(leftRect, cornerRadius),
        barPaint,
      );

      // Right bar
      final rightRect = Rect.fromCenter(
        center: Offset(center.dx + currentSpread, center.dy),
        width: barWidth,
        height: currentHeight,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rightRect, cornerRadius),
        barPaint,
      );

      // Liquid Droplet Meniscus (Metaball connective bridge while splitting or fusing)
      final spreadRatio = (currentSpread / maxSpread).clamp(0.0, 1.2);
      if (spreadRatio < 0.70) {
        final bridgeStrength = (1.0 - (spreadRatio / 0.70)).clamp(0.0, 1.0);
        final bridgeHeight = barHeight * 0.36 * math.pow(bridgeStrength, 1.4);
        final bridgeWidth = (currentSpread * 2.2).clamp(
          barWidth,
          maxSpread * 1.8,
        );
        final bridgeRect = Rect.fromCenter(
          center: center,
          width: bridgeWidth,
          height: bridgeHeight,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            bridgeRect,
            Radius.circular(bridgeHeight / 2),
          ),
          barPaint,
        );
      }
    }

    // 4. Draw Material 3 Expressive Dynamic Morphing Line (with luminous filament glow)
    if (lineOpacity > 0.01 && lineSweepAngle > 0.01) {
      const startAngle = -math.pi / 2;

      final linePath = Path();
      final lineSamples = (90 * (lineSweepAngle / (2 * math.pi)))
          .clamp(10, 140)
          .toInt();
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

      // Luminous ambient filament glow
      final glowPaint = Paint()
        ..color = color.withValues(alpha: (0.35 * lineOpacity).clamp(0.0, 1.0))
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 4.8
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5);
      canvas.drawPath(linePath, glowPaint);

      // Sharp central filament line
      final strokePaint = Paint()
        ..color = color.withValues(alpha: lineOpacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 2.8;
      canvas.drawPath(linePath, strokePaint);

      // Radiant traveling bead aura along the contour
      double headAngle;
      if (lineSweepAngle < (2 * math.pi - 0.04)) {
        headAngle = startAngle + lineSweepAngle;
      } else {
        // Continuous orbit during steady playback
        headAngle = startAngle + (morphProgress * 2 * math.pi);
      }
      final headR = _computeRadius(theta: headAngle, baseRadius: baseRadius);
      final tipX = center.dx + headR * math.cos(headAngle);
      final tipY = center.dy + headR * math.sin(headAngle);

      final tipGlow = Paint()
        ..color = color.withValues(alpha: (0.65 * lineOpacity).clamp(0.0, 1.0))
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.0);
      canvas.drawCircle(Offset(tipX, tipY), 5.2, tipGlow);

      final tipPaint = Paint()
        ..color = color.withValues(alpha: lineOpacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(tipX, tipY), 3.0, tipPaint);
    }

    // 5. Draw Radiant Energy Point & Curved Spiral Vortex Launch Trajectory
    final effectivePointOpacity = pointOpacity.clamp(0.0, 1.0);
    final effectiveSpiralFade = (spiralTrailFade * transition).clamp(0.0, 1.0);

    // Luminous curved spiral launch vapor trail (dissolves gracefully into perimeter)
    if (effectiveSpiralFade > 0.01 && spiralProgress > 0.01) {
      final spiralPath = Path();
      const steps = 24;
      for (int i = 0; i <= steps; i++) {
        final frac = (i / steps) * spiralProgress;
        final a = -math.pi / 2 - (1.0 - frac) * (0.85 * math.pi);
        final r = frac * baseRadius;
        final sx = center.dx + r * math.cos(a);
        final sy = center.dy + r * math.sin(a);
        if (i == 0) {
          spiralPath.moveTo(sx, sy);
        } else {
          spiralPath.lineTo(sx, sy);
        }
      }

      // Soft vapor glow
      final trailGlow = Paint()
        ..color = color.withValues(
          alpha: (0.30 * effectiveSpiralFade).clamp(0.0, 1.0),
        )
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 4.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
      canvas.drawPath(spiralPath, trailGlow);

      // Core vapor filament
      final trailPaint = Paint()
        ..color = color.withValues(
          alpha: (0.65 * effectiveSpiralFade).clamp(0.0, 1.0),
        )
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 2.4;
      canvas.drawPath(spiralPath, trailPaint);
    }

    // Central / travelling radiant energy singularity
    if (effectivePointOpacity > 0.01) {
      Offset pointCenter;
      if (spiralProgress > 0.001 && spiralProgress < 0.999) {
        final spiralAngle =
            -math.pi / 2 - (1.0 - spiralProgress) * (0.85 * math.pi);
        final spiralRadius = spiralProgress * baseRadius;
        pointCenter = Offset(
          center.dx + spiralRadius * math.cos(spiralAngle),
          center.dy + spiralRadius * math.sin(spiralAngle),
        );
      } else if (spiralProgress >= 0.999) {
        pointCenter = Offset(center.dx, center.dy - baseRadius);
      } else {
        pointCenter = center;
      }

      final pointRadius = 3.4 * pointScale;

      // Radiant glowing aura
      final pointGlow = Paint()
        ..color = color.withValues(
          alpha: (0.70 * effectivePointOpacity).clamp(0.0, 1.0),
        )
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.5);
      canvas.drawCircle(pointCenter, pointRadius * 2.4, pointGlow);

      // Solid central core
      final pointPaint = Paint()
        ..color = color.withValues(alpha: effectivePointOpacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;
      canvas.drawCircle(pointCenter, pointRadius, pointPaint);
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
        oldDelegate.lineContractProgress != lineContractProgress ||
        oldDelegate.pointOpacity != pointOpacity ||
        oldDelegate.pointScale != pointScale ||
        oldDelegate.spiralProgress != spiralProgress ||
        oldDelegate.spiralTrailFade != spiralTrailFade ||
        oldDelegate.pauseOpacity != pauseOpacity ||
        oldDelegate.pauseMorphProgress != pauseMorphProgress ||
        oldDelegate.pulseRadius != pulseRadius ||
        oldDelegate.pulseOpacity != pulseOpacity;
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
  State<TactileActionPlayButton> createState() =>
      _TactileActionPlayButtonState();
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
                    color: colorScheme.shadow.withValues(
                      alpha: _isHovered ? 0.55 : 0.45,
                    ),
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
                      icon:
                          widget.icon ??
                          (widget.isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded),
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
            decoration: _isHovered
                ? TextDecoration.underline
                : TextDecoration.none,
            color: _isHovered
                ? Theme.of(context).colorScheme.primary
                : widget.style.color,
          ),
        ),
      ),
    );
  }
}
