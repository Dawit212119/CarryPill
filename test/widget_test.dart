import 'package:carrypill/core/widgets/empty_state.dart';
import 'package:carrypill/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EmptyState shows title and message', (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: EmptyState(
              icon: Icons.inbox_outlined,
              title: 'No orders',
              message: 'Place your first order from the home screen.',
            ),
          ),
        ),
      ),
    );

    expect(find.text('No orders'), findsOneWidget);
    expect(
      find.text('Place your first order from the home screen.'),
      findsOneWidget,
    );
  });
}
