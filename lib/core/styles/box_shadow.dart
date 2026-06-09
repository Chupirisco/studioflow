import 'package:flutter/material.dart';

BoxShadow sombreamento() {
  return BoxShadow(
    color: Colors.black.withValues(alpha: 0.15),
    blurRadius: 6,
    spreadRadius: 1,
    offset: const Offset(0, 2), // x, y
  );
}
