import 'package:ai_core_health/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app bootstraps', (tester) async {
    await tester.pumpWidget(const AiCoreHealthApp());
    expect(find.text('Loading AI Core Health...'), findsOneWidget);
  });
}
