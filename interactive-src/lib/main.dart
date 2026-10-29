import 'data/cv_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeController(),
      child: const InteractiveCv(),
    ),
  );
}

class InteractiveCv extends StatelessWidget {
  const InteractiveCv({super.key, this.profile});
  final CvData? profile;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();
    return MaterialApp(
      title: 'Chheng Lydiya — CV',
      debugShowCheckedModeBanner: false,
      themeMode: theme.themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: HomeScreen(profile: profile),
    );
  }
}
