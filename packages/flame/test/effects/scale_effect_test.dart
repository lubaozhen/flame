import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter_test/flutter_test.dart';

import 'effect_test_utils.dart';

void main() {
  final random = Random();
  Vector2 randomVector2() => (Vector2.random(random) * 100)..round();
  final argumentScale = randomVector2();
  TestComponent component() => TestComponent(scale: randomVector2());

  ScaleEffect effect({bool isInfinite = false, bool isAlternating = false}) {
    return ScaleEffect(
      scale: argumentScale,
      duration: 1 + random.nextInt(100).toDouble(),
      isInfinite: isInfinite,
      isAlternating: isAlternating,
    )..skipEffectReset = true;
  }

  testWidgets('ScaleEffect can scale', (WidgetTester tester) async {
    effectTest(
      tester,
      component(),
      effect(),
      expectedScale: argumentScale,
    );
  });

  testWidgets(
    'ScaleEffect will stop scaling after it is done',
    (WidgetTester tester) async {
      effectTest(
        tester,
        component(),
        effect(),
        expectedScale: argumentScale,
        iterations: 1.5,
      );
    },
  );

  testWidgets('ScaleEffect can alternate', (WidgetTester tester) async {
    final PositionComponent positionComponent = component();
    effectTest(
      tester,
      positionComponent,
      effect(isAlternating: true),
      expectedScale: positionComponent.scale.clone(),
    );
  });

  testWidgets(
    'ScaleEffect can alternate and be infinite',
    (WidgetTester tester) async {
      final PositionComponent positionComponent = component();
      effectTest(
        tester,
        positionComponent,
        effect(isInfinite: true, isAlternating: true),
        expectedScale: positionComponent.scale.clone(),
        shouldComplete: false,
      );
    },
  );

  testWidgets('ScaleEffect alternation can peak', (WidgetTester tester) async {
    final PositionComponent positionComponent = component();
    effectTest(
      tester,
      positionComponent,
      effect(isAlternating: true),
      expectedScale: argumentScale,
      shouldComplete: false,
      iterations: 0.5,
    );
  });

  testWidgets('ScaleEffect can be infinite', (WidgetTester tester) async {
    final PositionComponent positionComponent = component();
    effectTest(
      tester,
      positionComponent,
      effect(isInfinite: true),
      expectedScale: argumentScale,
      iterations: 3.0,
      shouldComplete: false,
    );
  });
}
