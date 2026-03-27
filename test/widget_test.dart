import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metronome_for_live/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MetronomeApp()));
    await tester.pumpAndSettle();
    expect(find.text('Live Mode'), findsOneWidget);
  });
}
