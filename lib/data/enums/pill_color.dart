import 'dart:ui';

enum PillColor {
  white(label: 'White', color: Color(0xFFFFFFFF)),
  blue(label: 'Blue', color: Color(0xFF2196F3)),
  yellow(label: 'Yellow', color: Color(0xFFFFEB3B)),
  pink(label: 'Pink', color: Color(0xFFE91E63)),
  red(label: 'Red', color: Color(0xFFEF4444)),
  green(label: 'Green', color: Color(0xFF10B981)),
  orange(label: 'Orange', color: Color(0xFFF59E0B)),
  purple(label: 'Purple', color: Color(0xFF8B5CF6));

  const PillColor({required this.label, required this.color});
  final String label;
  final Color color;
}
