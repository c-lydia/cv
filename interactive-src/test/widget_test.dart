import 'dart:convert';
import 'dart:io';
import 'package:interactive_cv/data/cv_data.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:interactive_cv/main.dart';
import 'package:interactive_cv/theme/theme_controller.dart';
import 'package:interactive_cv/widgets/export_cv_button.dart';

void main() {
  final profile = CvData(
    jsonDecode(File('assets/cv/profile.json').readAsStringSync())
        as Map<String, dynamic>,
  );
  for (final width in [320.0, 1440.0]) {
    testWidgets('CV content, section navigation and theme at $width px', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeController(),
          child: InteractiveCv(profile: profile),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Chheng Lydiya'), findsWidgets);
      expect(find.text('SAAT R&D Center'), findsOneWidget);
      expect(find.text('ByteLab'), findsOneWidget);
      expect(find.text('Expected graduation: 2028'), findsOneWidget);
      final navigation = width < 1000
          ? find.widgetWithText(ActionChip, 'Experience')
          : find.widgetWithText(ListTile, 'Experience');
      await tester.tap(navigation);
      await tester.pumpAndSettle();
      expect(find.text('DCLab / Robocon').hitTestable(), findsOneWidget);
      await tester.tap(find.byTooltip('Switch to light theme'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Switch to dark theme'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'Export supplies a real PDF, handles cancellation and permits retry',
    (tester) async {
      Uint8List? captured;
      var attempts = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExportCvButton(
              save: (bytes) async {
                captured = bytes;
                attempts++;
                return false;
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('Download CV (PDF)'));
      await tester.pumpAndSettle();
      expect(String.fromCharCodes(captured!.take(5)), '%PDF-');
      expect(captured!.length, greaterThan(10000));
      expect(find.byType(SnackBar), findsNothing);
      await tester.tap(find.text('Download CV (PDF)'));
      await tester.pumpAndSettle();
      expect(attempts, 2);
    },
  );

  testWidgets('Export reports a save failure and restores the button', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExportCvButton(save: (_) async => throw StateError('failed')),
        ),
      ),
    );
    await tester.tap(find.text('Download CV (PDF)'));
    await tester.pumpAndSettle();
    expect(
      find.text('Could not save the CV. Please try again.'),
      findsOneWidget,
    );
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNotNull,
    );
  });
}
