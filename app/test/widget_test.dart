import 'package:flutter_test/flutter_test.dart';
import 'package:swipecleaner/app.dart';

void main() {
  testWidgets('SwipeClear app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SwipeClearApp());
    await tester.pumpAndSettle();

    // Verify onboarding screen shows app title
    expect(find.text('SwipeClear'), findsOneWidget);
  });
}
