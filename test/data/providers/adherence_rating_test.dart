import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/providers/adherence_provider.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('adherenceRating', () {
    test('returns Excellent for 95%', () {
      expect(container.read(adherenceRatingProvider(95.0)), 'Excellent');
    });

    test('returns Excellent for 100%', () {
      expect(container.read(adherenceRatingProvider(100.0)), 'Excellent');
    });

    test('returns Good for 80%', () {
      expect(container.read(adherenceRatingProvider(80.0)), 'Good');
    });

    test('returns Good for 94%', () {
      expect(container.read(adherenceRatingProvider(94.0)), 'Good');
    });

    test('returns Fair for 50%', () {
      expect(container.read(adherenceRatingProvider(50.0)), 'Fair');
    });

    test('returns Fair for 79%', () {
      expect(container.read(adherenceRatingProvider(79.0)), 'Fair');
    });

    test('returns Poor for 49%', () {
      expect(container.read(adherenceRatingProvider(49.0)), 'Poor');
    });

    test('returns Poor for 0%', () {
      expect(container.read(adherenceRatingProvider(0.0)), 'Poor');
    });

    test('boundary: 95.0 is Excellent not Good', () {
      expect(container.read(adherenceRatingProvider(95.0)), 'Excellent');
      expect(container.read(adherenceRatingProvider(94.99)), 'Good');
    });

    test('boundary: 80.0 is Good not Fair', () {
      expect(container.read(adherenceRatingProvider(80.0)), 'Good');
      expect(container.read(adherenceRatingProvider(79.99)), 'Fair');
    });

    test('boundary: 50.0 is Fair not Poor', () {
      expect(container.read(adherenceRatingProvider(50.0)), 'Fair');
      expect(container.read(adherenceRatingProvider(49.99)), 'Poor');
    });
  });
}
