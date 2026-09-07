import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A premium icon button that provides a "squeeze" scale animation
/// and light haptic feedback when pressed.
class TactileIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final EdgeInsets padding;

  const TactileIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 28,
    this.color,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.padding = const EdgeInsets.all(12.0),
  });

  @override
  State<TactileIconButton> createState() => _TactileIconButtonState();
}

class _TactileIconButtonState extends State<TactileIconButton> {
  double _scale = 1.0;

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap == null) return;
    HapticFeedback.selectionClick();
    setState(() => _scale = 0.85);
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: Opacity(
          opacity: widget.onTap == null ? 0.3 : 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: widget.borderRadius,
              border: widget.border,
            ),
            child: Padding(
              padding: widget.padding,
              child: Icon(
                widget.icon,
                size: widget.size,
                color: widget.color ?? colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A premium specialized Play/Pause button for the Player screen
/// with spring animations and haptic feedback.
class TactilePlayerPlayPauseButton extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback? onTap;

  const TactilePlayerPlayPauseButton({
    super.key,
    required this.isPlaying,
    this.onTap,
  });

  @override
  State<TactilePlayerPlayPauseButton> createState() => _TactilePlayerPlayPauseButtonState();
}

class _TactilePlayerPlayPauseButtonState extends State<TactilePlayerPlayPauseButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    if (widget.isPlaying) _controller.forward();
  }

  @override
  void didUpdateWidget(TactilePlayerPlayPauseButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap == null) return;
    HapticFeedback.mediumImpact();
    setState(() => _scale = 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Opacity(
          opacity: widget.onTap == null ? 0.6 : 1.0,
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.onSurface,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.26),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: AnimatedIcon(
                icon: AnimatedIcons.play_pause,
                progress: _controller,
                size: 42,
                color: colorScheme.surface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A signature green play button used in list headers (Radio, Genre, Playlist)
/// with tactile feedback and animations.
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTapDown: (_) {
        if (widget.onTap == null) return;
        HapticFeedback.lightImpact();
        setState(() => _scale = 0.9);
      },
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,
        child: Opacity(
          opacity: widget.onTap == null ? 0.5 : 1.0,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary, // Dynamic Theme Color
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.45),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
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
    return GestureDetector(
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
