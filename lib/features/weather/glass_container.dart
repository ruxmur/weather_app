import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double stops;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.stops = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.0),
            Colors.black.withOpacity(0.1),
          ],
          stops: [stops, stops, 0.9, 1.0],
        ),
        border: Border.all(
          width: 1.5,
          color: Colors.white.withOpacity(0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 2,
            spreadRadius: 0.5,
          ),
        ],
      ),
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 8),
      padding: padding ?? const EdgeInsets.all(8),
      child: child,
    );
  }
}