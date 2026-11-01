import 'package:flutter_test/flutter_test.dart';
import 'package:atelier_workspace/main.dart';

void main() {
  testWidgets('Landing page exposes the creative workspace', (tester) async {
    await tester.pumpWidget(const Atelier());
    await tester.pumpAndSettle();
    expect(find.text('Make space\nfor ideas.'), findsOneWidget);
    expect(find.text('Explore the workspace   ↗'), findsOneWidget);
  });
}
