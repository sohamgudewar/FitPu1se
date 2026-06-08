import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitpulse/app/app.dart';

void main() {
  testWidgets('app renders', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: FitPulseApp()));
    expect(find.text('FitPulse'), findsOneWidget);
  });
}
