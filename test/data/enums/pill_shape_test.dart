import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/enums/pill_shape.dart';

void main() {
  group('PillShape', () {
    test('has exactly 7 values', () {
      expect(PillShape.values.length, 7);
    });

    group('enum names', () {
      test('round has correct name', () {
        expect(PillShape.round.name, 'round');
      });

      test('capsule has correct name', () {
        expect(PillShape.capsule.name, 'capsule');
      });

      test('oval has correct name', () {
        expect(PillShape.oval.name, 'oval');
      });

      test('square has correct name', () {
        expect(PillShape.square.name, 'square');
      });

      test('triangle has correct name', () {
        expect(PillShape.triangle.name, 'triangle');
      });

      test('hexagon has correct name', () {
        expect(PillShape.hexagon.name, 'hexagon');
      });

      test('packet has correct name', () {
        expect(PillShape.packet.name, 'packet');
      });
    });

    group('label metadata', () {
      test('round label is Round', () {
        expect(PillShape.round.label, 'Round');
      });

      test('capsule label is Capsule', () {
        expect(PillShape.capsule.label, 'Capsule');
      });

      test('oval label is Oval', () {
        expect(PillShape.oval.label, 'Oval');
      });

      test('square label is Square', () {
        expect(PillShape.square.label, 'Square');
      });

      test('triangle label is Triangle', () {
        expect(PillShape.triangle.label, 'Triangle');
      });

      test('hexagon label is Hexagon', () {
        expect(PillShape.hexagon.label, 'Hexagon');
      });

      test('packet label is Packet', () {
        expect(PillShape.packet.label, 'Packet');
      });
    });

    group('icon metadata', () {
      test('round icon is Icons.circle_outlined', () {
        expect(PillShape.round.icon, Icons.circle_outlined);
      });

      test('capsule icon is Icons.medication_outlined', () {
        expect(PillShape.capsule.icon, Icons.medication_outlined);
      });

      test('oval icon is Icons.circle_outlined', () {
        expect(PillShape.oval.icon, Icons.circle_outlined);
      });

      test('square icon is Icons.square_outlined', () {
        expect(PillShape.square.icon, Icons.square_outlined);
      });

      test('triangle icon is Icons.change_history_outlined', () {
        expect(PillShape.triangle.icon, Icons.change_history_outlined);
      });

      test('hexagon icon is Icons.hexagon_outlined', () {
        expect(PillShape.hexagon.icon, Icons.hexagon_outlined);
      });

      test('packet icon is Icons.inventory_2_outlined', () {
        expect(PillShape.packet.icon, Icons.inventory_2_outlined);
      });
    });

    group('all values have non-empty labels', () {
      test('every value has a non-empty label', () {
        for (final shape in PillShape.values) {
          expect(shape.label, isNotEmpty,
              reason: '${shape.name} should have a non-empty label');
        }
      });
    });

    group('all values have valid icons', () {
      test('every value has a non-null icon', () {
        for (final shape in PillShape.values) {
          // IconData is a value type; just confirm it is accessible
          expect(shape.icon, isA<IconData>(),
              reason: '${shape.name} should have an IconData icon');
        }
      });
    });
  });
}
