import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/DoctorScreen.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MainApp shows the doctor chat screen as the home route', (
    tester,
  ) async {
    await tester.pumpWidget(const MainApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(DoctorScreen), findsOneWidget);
  });
}
