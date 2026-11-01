import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:atelier_workspace/main.dart';

void main() {
  testWidgets('Landing page exposes the creative workspace', (tester) async {
    await tester.pumpWidget(const Atelier());
    await tester.pumpAndSettle();
    expect(find.text('Make space\nfor ideas.'), findsOneWidget);
    expect(find.text('Explore the workspace   ↗'), findsOneWidget);
  });

  testWidgets('Graphicpad fits a phone and retains an editable canvas', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const MaterialApp(home: Shell(path: '/graphicpad')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Pen'), findsOneWidget);
    expect(find.text('Select / move'), findsOneWidget);
    final canvas = find.byWidgetPredicate(
      (w) => w is CustomPaint && w.painter is DrawingPainter,
    );
    expect(canvas, findsOneWidget);
    expect(tester.getSize(canvas).height, greaterThan(300));
    await tester.drag(canvas, const Offset(40, 30));
    await tester.pump();
    final painter =
        tester.widget<CustomPaint>(canvas).painter as DrawingPainter;
    expect(painter.strokes, hasLength(1));
    expect(painter.strokes.single.points.length, greaterThan(1));
  });
}
