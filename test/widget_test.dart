import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_home_controller/main.dart';

void main() {
  testWidgets('Smart Home Controller test', (tester) async {
    await tester.pumpWidget(const SmartHomeApp());

    // Check application title
    expect(find.text('My Smart Home'), findsOneWidget);

    // Check smart light
    expect(find.text('Living Room Light'), findsOneWidget);
    expect(find.text('ON'), findsOneWidget);

    // Test light switch
    await tester.tap(find.byType(SwitchListTile));
    await tester.pump();

    expect(find.text('OFF'), findsOneWidget);
  });
}
