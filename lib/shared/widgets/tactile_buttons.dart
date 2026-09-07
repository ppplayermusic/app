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
/// Features a living kinetic animation while playing:
/// - Smooth 360° spin with an organic expand & shrink pulse
/// - Subtle morph into a glowing play glyph and back to the PPPlayer logo
/// - Borderless, dark glass container with theme-reactive ambient aura
/// - Instant pause affordance on hover
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
      duration: const Duration(milliseconds: 320),
      value: widget.isPlaying ? 1.0 : 0.0,
    );

    // 7.5 second rhythmic loop:
    // 0.0 - 0.35: Spin & Expand (2.6s)
    // 0.35 - 0.50: Morph into Play button (1.1s)
    // 0.50 - 0.70: Play button pulse/breathe (1.5s)
    // 0.70 - 0.85: Morph back to PPPlayer Logo (1.1s)
    // 0.85 - 1.00: Rest & subtle micro-breathe (1.2s)
    _loopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 7500),
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
        : (_isHovered && isEnabled ? 1.08 : 1.0);

    final primaryThemeColor = widget.activeGlowColor ?? colorScheme.primary;

    final String tooltipMessage = widget.tooltip ??
        (widget.isPlaying ? 'Pause' : 'Play');

    Widget buttonContent = AnimatedBuilder(
      animation: Listenable.merge([_transitionController, _loopController]),
      builder: (context, _) {
        final transition = _transitionController.value;
        final loop = _loopController.value;

        double angle = 0.0;
        double scaleMultiplier = 1.0;
        double logoOpacity = 1.0;
        double pauseMorphOpacity = 0.0;
        double glowAlpha = 0.16;

        if (loop < 0.35) {
          // Phase 1: Spin & Expand/Shrink (0% - 35%)
          final p = loop / 0.35;
          final spinCurve = Curves.easeInOutCubic.transform(p);
          angle = spinCurve * 2 * math.pi;
          final expand = math.sin(p * math.pi);
          scaleMultiplier = 1.0 + (0.13 * expand);
          logoOpacity = 1.0;
          pauseMorphOpacity = 0.0;
          glowAlpha = 0.18 + (0.24 * expand);
        } else if (loop < 0.48) {
          // Phase 2: Morph into Pause button (35% - 48%)
          final p = (loop - 0.35) / 0.13;
          final easeP = Curves.easeInOut.transform(p);
          angle = 0.0;
          scaleMultiplier = 1.0 - (0.04 * math.sin(p * math.pi));
          logoOpacity = 1.0 - easeP;
          pauseMorphOpacity = easeP;
          glowAlpha = 0.18;
        } else if (loop < 0.68) {
          // Phase 3: Pause button breathing (48% - 68%)
          final p = (loop - 0.48) / 0.20;
          angle = 0.0;
          final breathe = math.sin(p * math.pi);
          scaleMultiplier = 1.0 + (0.06 * breathe);
          logoOpacity = 0.0;
          pauseMorphOpacity = 1.0;
          glowAlpha = 0.16 + (0.12 * breathe);
        } else if (loop < 0.82) {
          // Phase 4: Morph back to PPPlayer Logo (68% - 82%)
          final p = (loop - 0.68) / 0.14;
          final easeP = Curves.easeInOut.transform(p);
          angle = 0.0;
          scaleMultiplier = 1.0 - (0.03 * math.sin(p * math.pi));
          logoOpacity = easeP;
          pauseMorphOpacity = 1.0 - easeP;
          glowAlpha = 0.18;
        } else {
          // Phase 5: Rest & settle before next cycle (82% - 100%)
          final p = (loop - 0.82) / 0.18;
          angle = 0.0;
          scaleMultiplier = 1.0 - (0.02 * math.sin(p * math.pi));
          logoOpacity = 1.0;
          pauseMorphOpacity = 0.0;
          glowAlpha = 0.15;
        }

        // Ambient theme glow
        final currentGlowColor = primaryThemeColor.withValues(
          alpha: (glowAlpha * transition).clamp(0.0, 1.0),
        );
        final currentGlowBlur = (widget.size * 0.22 + (widget.size * 0.20) * (scaleMultiplier - 0.95)) * transition;
        final currentGlowSpread = (0.5 + 2.0 * (scaleMultiplier - 0.95)) * transition;

        // Smooth container background:
        // Paused: primaryThemeColor (solid & crisp)
        // Playing: subtle dark glass tint (NO harsh grey disc, NO rigid border)
        final bgColor = Color.lerp(
          primaryThemeColor,
          Colors.black.withValues(alpha: 0.28),
          transition,
        )!;

        final iconSize = widget.size * 0.60;
        final logoSize = widget.size * 0.74;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor,
            boxShadow: [
              // Resting subtle depth shadow
              BoxShadow(
                color: colorScheme.shadow.withValues(
                  alpha: _isHovered ? 0.40 : 0.22,
                ),
                blurRadius: _isHovered ? 16 : 10,
                offset: Offset(0, _isHovered ? 5 : 3),
              ),
              // Playing ambient theme glow (soft & borderless)
              if (transition > 0.01)
                BoxShadow(
                  color: currentGlowColor,
                  blurRadius: currentGlowBlur,
                  spreadRadius: currentGlowSpread,
                ),
            ],
          ),
          child: ClipOval(
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                // 1. Idle Paused State: Solid play icon
                if (transition < 0.99)
                  Opacity(
                    opacity: (1.0 - transition).clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: 1.0 - (0.15 * transition),
                      child: Center(
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
                  ),

                // 2. Playing State: Living Kinetic Logo / Pause Morph
                if (transition > 0.01)
                  Opacity(
                    opacity: transition.clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: scaleMultiplier,
                      child: Stack(
                        alignment: Alignment.center,
                        fit: StackFit.expand,
                        children: [
                          // PPPlayer Logo (Spins smoothly and breathes)
                          if (logoOpacity > 0.01)
                            Opacity(
                              opacity: logoOpacity.clamp(0.0, 1.0),
                              child: Center(
                                child: Transform.rotate(
                                  angle: angle,
                                  child: Image.asset(
                                    'assets/logo.png',
                                    width: logoSize,
                                    height: logoSize,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),

                          // Morphing Pause Glyph
                          if (pauseMorphOpacity > 0.01)
                            Opacity(
                              opacity: pauseMorphOpacity.clamp(0.0, 1.0),
                              child: Center(
                                child: Icon(
                                  Icons.pause_rounded,
                                  size: iconSize * 1.05,
                                  color: primaryThemeColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                // 3. Playing State Hover Overlay: Clear Pause Affordance
                if (transition > 0.5)
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 160),
                    opacity: (_isHovered && isEnabled) ? 1.0 : 0.0,
                    curve: Curves.easeOut,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withValues(alpha: 0.55),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.pause_rounded,
                          size: iconSize * 0.95,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
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
