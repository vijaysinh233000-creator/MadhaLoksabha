import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voter_finder/core/theme/app_theme.dart';
import 'package:voter_finder/features/sectors/sector_data.dart';
import 'package:voter_finder/features/sectors/sector_detail_page.dart';

void main() {
  for (final width in [390.0, 1280.0]) {
    testWidgets('all sector articles render at ${width.toInt()}px', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      for (final profile in sectorProfiles.values) {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light(),
            home: SectorDetailPage(profile: profile),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text(profile.title), findsWidgets);
        expect(find.text(profile.sections.first.title), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });
  }
}
