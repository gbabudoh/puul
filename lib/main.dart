import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_colors.dart';
import 'features/auth/screens/login_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: PuulApp(),
    ),
  );
}

// Custom scroll behavior to remove bounce/glow effects
class NoBounceBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}

class PuulApp extends StatelessWidget {
  const PuulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PUUL',
      debugShowCheckedModeBanner: false,
      scrollBehavior: NoBounceBehavior(),
      theme: ThemeData(
        primaryColor: AppColors.primaryAccent,
        scaffoldBackgroundColor: AppColors.primaryBackground,
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryAccent,
          secondary: AppColors.secondaryAccent,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.cardBackground,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: AppColors.cardBackground,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.cardBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryAccent, width: 2),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
