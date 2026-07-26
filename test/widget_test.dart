// Basic smoke test for the PUUL app.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:puul/main.dart';

void main() {
  testWidgets('App builds and shows the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PuulApp(),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
