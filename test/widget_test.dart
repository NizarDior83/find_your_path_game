// Smoke test for the Find Your Path app entry point.
// The actual intro screen requires a video asset and hardware rendering,
// so this test only verifies that the app widget tree builds without errors.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:find_your_path/main.dart';

void main() {
  testWidgets('App builds without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const FindYourPathApp());
    // The intro screen renders a black Scaffold while the video initialises.
    expect(find.byType(Scaffold), findsWidgets);
  });
}
