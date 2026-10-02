import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voter_finder/features/user_dashboard/widgets/heritage_motion.dart';

void main() {
  testWidgets('reveals when scrolled into view and remains visible', (
    tester,
  ) async {
    final controller = ScrollController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            controller: controller,
            child: const Column(
              children: [
                SizedBox(height: 900),
                HeritageMotion(
                  child: SizedBox(height: 100, child: Text('Portrait')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    final opacity = find.descendant(
      of: find.byType(HeritageMotion),
      matching: find.byType(Opacity),
    );
    expect(tester.widget<Opacity>(opacity).opacity, 0);
    controller.jumpTo(500);
    await tester.pumpAndSettle();
    expect(tester.widget<Opacity>(opacity).opacity, 1);
    controller.jumpTo(0);
    await tester.pumpAndSettle();
    expect(tester.widget<Opacity>(opacity).opacity, 1);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    controller.dispose();
  });

  testWidgets('reduced motion renders content immediately', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: HeritageMotion(child: Text('Portrait')),
        ),
      ),
    );
    final opacity = find.descendant(
      of: find.byType(HeritageMotion),
      matching: find.byType(Opacity),
    );
    expect(tester.widget<Opacity>(opacity).opacity, 1);
    expect(tester.takeException(), isNull);
  });
}
