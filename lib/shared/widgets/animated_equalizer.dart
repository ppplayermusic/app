import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedEqualizer extends StatefulWidget {
  final Color color;
  final double size;

  const AnimatedEqualizer({super.key, required this.color, this.size = 16.0});

  @override
  State<AnimatedEqualizer> createState() => _AnimatedEqualizerState();
}

class _AnimatedEqualizerState extends State<AnimatedEqualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _Bar(controller: _controller, color: widget.color, offset: 0.0),
          _Bar(controller: _controller, color: widget.color, offset: 1.0),
          _Bar(controller: _controller, color: widget.color, offset: 2.0),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final AnimationController controller;
  final Color color;
  final double offset;

  const _Bar({
    required this.controller,
    required this.color,
    required this.offset,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // Use sine wave to smoothly interpolate height
        final t = controller.value * 2 * math.pi;
        final value = math.sin(t + offset);
        // Normalize from [-1, 1] to [0.3, 1.0]
        final heightFactor = 0.3 + 0.7 * ((value + 1) / 2);

        return FractionallySizedBox(
          heightFactor: heightFactor,
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 3.0,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        );
      },
    );
  }
}
