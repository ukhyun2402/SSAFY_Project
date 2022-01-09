import 'package:flutter/material.dart';

class ClibPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..moveTo(size.width / 7 * 5, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 7 * 4, size.height)
      ..close();
    // ..moveTo(size.width / 2, 0) // move path point to (w/2,0)
    // ..lineTo(0, size.width)
    // ..lineTo(size.width, size.height)
    // ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class ClipPathBack extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..lineTo(0, 0)
      ..lineTo(0, size.height)
      ..relativeQuadraticBezierTo(size.width / 5 * 1.5, size.height - 18,
          size.width / 5 * 1.5, size.height - 20)
      ..relativeQuadraticBezierTo(
          size.width / 5 * 2, size.height + 15, size.width, size.height + 20)
      ..relativeQuadraticBezierTo(size.width / 5 * 3, size.height - 18,
          size.width / 5 * 3, size.height - 20)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
