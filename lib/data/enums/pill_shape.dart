import 'package:flutter/material.dart';

enum PillShape {
  round(label: 'Round', icon: Icons.circle_outlined),
  capsule(label: 'Capsule', icon: Icons.medication_outlined),
  oval(label: 'Oval', icon: Icons.lens_outlined),
  square(label: 'Square', icon: Icons.square_outlined),
  triangle(label: 'Triangle', icon: Icons.change_history_outlined),
  hexagon(label: 'Hexagon', icon: Icons.hexagon_outlined);

  const PillShape({required this.label, required this.icon});
  final String label;
  final IconData icon;
}
