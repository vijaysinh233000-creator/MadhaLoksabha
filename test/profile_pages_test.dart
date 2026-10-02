import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:voter_finder/core/theme/app_theme.dart';
import 'package:voter_finder/features/profiles/person_profile_page.dart';
import 'package:voter_finder/features/profiles/profile_data.dart';

void main() {
  for (final width in [390.0, 1280.0]) {
    testWidgets('all long-form profiles render at ${width.toInt()}px', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      for (final profile in personProfiles.values) {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light(),
            home: PersonProfilePage(profile: profile),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text(profile.name), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });
  }
}
