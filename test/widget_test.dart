import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growops_go/app.dart';
import 'package:growops_go/core/di/injection.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    await configureDependencies();
  });

  testWidgets('login screen shows demo account', (tester) async {
    await tester.pumpWidget(const GrowOpsGoApp());
    await tester.pumpAndSettle();

    expect(find.text('Sign in to manage your batches'), findsOneWidget);
    expect(find.text('Autofill demo credentials'), findsOneWidget);
  });
}
