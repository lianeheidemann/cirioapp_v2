import 'package:flutter/material.dart';

abstract final class AppShadows {
  static const soft = [
    BoxShadow(color: Color(0x12071D4A), blurRadius: 20, offset: Offset(0, 8)),
  ];
  static const floating = [
    BoxShadow(color: Color(0x1F071D4A), blurRadius: 28, offset: Offset(0, 12)),
  ];
}
