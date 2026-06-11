import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_app/core/constants/colors.dart';
import 'package:test_app/features/calendar/presentation/screens/calendar_screen.dart';

void main() async {
  // Ensure Flutter engine bindings are initialized before loading dotenv
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables from .env asset
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Warning: Could not load .env file. Using defaults. Error: $e');
  }

  runApp(
    const ProviderScope(
      child: CalendarApp(),
    ),
  );
}

class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CalendarPlus',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system, // Dynamically follow system setting
      home: const CalendarScreen(),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
      surface: isDark ? AppColors.bgDark : AppColors.bgLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      
      // Card Styling
      cardTheme: CardThemeData(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: isDark 
                ? AppColors.borderDark.withValues(alpha: 0.5) 
                : AppColors.borderLight.withValues(alpha: 0.5),
          ),
        ),
      ),

      // Text Theme mapping Google Fonts
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        ThemeData(brightness: brightness).textTheme,
      ).apply(
        bodyColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        displayColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      ),

      // AppBar Custom Styling
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        centerTitle: false,
      ),
    );
  }
}