import 'package:flutter/material.dart';

class MenuItem {
  final String label;
  final String type;
  final double? fontSize;
  final Widget icon;

  const MenuItem({
    required this.label,
    required this.type,
    required this.icon,
    this.fontSize,
  });
}
