import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voter_finder/features/user_dashboard/widgets/regional_story_section.dart';

void main() {
  for (final width in [320.0, 390.0, 768.0, 1280.0]) {
    testWidgets('Regional section fits width $width with reduced motion', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(
              size: Size(width, 900),
              disableAnimations: true,
            ),
            child: const Scaffold(
              body: SingleChildScrollView(child: RegionalStorySection()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('अकलूज → मुंबई → दिल्ली'), findsOneWidget);
      expect(find.text('कृष्णा–भीमा स्थिरीकरण'), findsOneWidget);
    });
  }
}
