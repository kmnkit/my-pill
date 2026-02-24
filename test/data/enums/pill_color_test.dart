import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/enums/pill_color.dart';

void main() {
  group('PillColor', () {
    test('has exactly 8 values', () {
      expect(PillColor.values.length, 8);
    });

    group('enum names', () {
      test('white has correct name', () {
        expect(PillColor.white.name, 'white');
      });

      test('blue has correct name', () {
        expect(PillColor.blue.name, 'blue');
      });

      test('yellow has correct name', () {
        expect(PillColor.yellow.name, 'yellow');
      });

      test('pink has correct name', () {
        expect(PillColor.pink.name, 'pink');
      });

      test('red has correct name', () {
        expect(PillColor.red.name, 'red');
      });

      test('green has correct name', () {
        expect(PillColor.green.name, 'green');
      });

      test('orange has correct name', () {
        expect(PillColor.orange.name, 'orange');
      });

      test('purple has correct name', () {
        expect(PillColor.purple.name, 'purple');
      });
    });

    group('label metadata', () {
      test('white label is White', () {
        expect(PillColor.white.label, 'White');
      });

      test('blue label is Blue', () {
        expect(PillColor.blue.label, 'Blue');
      });

      test('yellow label is Yellow', () {
        expect(PillColor.yellow.label, 'Yellow');
      });

      test('pink label is Pink', () {
        expect(PillColor.pink.label, 'Pink');
      });

      test('red label is Red', () {
        expect(PillColor.red.label, 'Red');
      });

      test('green label is Green', () {
        expect(PillColor.green.label, 'Green');
      });

      test('orange label is Orange', () {
        expect(PillColor.orange.label, 'Orange');
      });

      test('purple label is Purple', () {
        expect(PillColor.purple.label, 'Purple');
      });
    });

    group('color metadata', () {
      test('white color is 0xFFFFFFFF', () {
        expect(PillColor.white.color, const Color(0xFFFFFFFF));
      });

      test('blue color is 0xFF2196F3', () {
        expect(PillColor.blue.color, const Color(0xFF2196F3));
      });

      test('yellow color is 0xFFFFEB3B', () {
        expect(PillColor.yellow.color, const Color(0xFFFFEB3B));
      });

      test('pink color is 0xFFE91E63', () {
        expect(PillColor.pink.color, const Color(0xFFE91E63));
      });

      test('red color is 0xFFEF4444', () {
        expect(PillColor.red.color, const Color(0xFFEF4444));
      });

      test('green color is 0xFF10B981', () {
        expect(PillColor.green.color, const Color(0xFF10B981));
      });

      test('orange color is 0xFFF59E0B', () {
        expect(PillColor.orange.color, const Color(0xFFF59E0B));
      });

      test('purple color is 0xFF8B5CF6', () {
        expect(PillColor.purple.color, const Color(0xFF8B5CF6));
      });
    });

    group('all values have non-empty labels', () {
      test('every value has a non-empty label', () {
        for (final color in PillColor.values) {
          expect(color.label, isNotEmpty,
              reason: '${color.name} should have a non-empty label');
        }
      });
    });

    group('all values have valid Color objects', () {
      test('every value has a Color with full opacity', () {
        for (final pillColor in PillColor.values) {
          expect(pillColor.color.alpha, 0xFF,
              reason: '${pillColor.name} should have full alpha (0xFF)');
        }
      });
    });

    group('colors are unique', () {
      test('no two PillColor values share the same color value', () {
        final colorValues =
            PillColor.values.map((c) => c.color.value).toList();
        final uniqueColorValues = colorValues.toSet();
        expect(colorValues.length, uniqueColorValues.length,
            reason: 'All PillColor color values should be unique');
      });
    });
  });
}
