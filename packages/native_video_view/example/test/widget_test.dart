import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_video_view_example/main.dart';

void main() {
  testWidgets('AppBar shows plugin example title', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyApp()));

    expect(find.text('Plugin example app'), findsOneWidget);
  });
}
