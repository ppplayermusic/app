import 'package:flutter/material.dart';

class PPLogoLoader extends StatefulWidget {
  final double size;
  final Color? color;

  const PPLogoLoader({super.key, this.size = 40.0, this.color});

  @override
  State<PPLogoLoader> createState() => _PPLogoLoaderState();
}

class _PPLogoLoaderState extends State<PPLogoLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Image.asset(
        'assets/logo.png',
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain,
        color: widget.color ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
