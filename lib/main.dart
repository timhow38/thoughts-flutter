import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';

// Material Design 3 Color Scheme
final ColorScheme _md3LightScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF6750A4), // Primary purple
  brightness: Brightness.light,
  // Custom surface colors for better contrast
  surface: const Color(0xFFFFFBFE),
  surfaceVariant: const Color(0xFFF3F1F5),
  outline: const Color(0xFF79747E),
  outlineVariant: const Color(0xFFCAC4D0),
);

final ColorScheme _md3DarkScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF6750A4), // Primary purple
  brightness: Brightness.dark,
  // Custom surface colors for better contrast
  surface: const Color(0xFF1C1B1F),
  surfaceVariant: const Color(0xFF2F2F35),
  outline: const Color(0xFF938F99),
  outlineVariant: const Color(0xFF49454F),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Idea Sharing Notes',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: _md3LightScheme,
        // Material Design 3 Typography
        textTheme: Typography.material2021().englishLike.copyWith(
          displayLarge: Typography.material2021().englishLike.displayLarge?.copyWith(
            fontSize: 57,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.25,
          ),
          displayMedium: Typography.material2021().englishLike.displayMedium?.copyWith(
            fontSize: 45,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
          displaySmall: Typography.material2021().englishLike.displaySmall?.copyWith(
            fontSize: 36,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
          headlineLarge: Typography.material2021().englishLike.headlineLarge?.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
          headlineMedium: Typography.material2021().englishLike.headlineMedium?.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
          headlineSmall: Typography.material2021().englishLike.headlineSmall?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
          titleLarge: Typography.material2021().englishLike.titleLarge?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
          titleMedium: Typography.material2021().englishLike.titleMedium?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
          ),
          titleSmall: Typography.material2021().englishLike.titleSmall?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          bodyLarge: Typography.material2021().englishLike.bodyLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
          bodyMedium: Typography.material2021().englishLike.bodyMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
          ),
          bodySmall: Typography.material2021().englishLike.bodySmall?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4,
          ),
          labelLarge: Typography.material2021().englishLike.labelLarge?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          labelMedium: Typography.material2021().englishLike.labelMedium?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          labelSmall: Typography.material2021().englishLike.labelSmall?.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        // Material Design 3 Component Themes
        cardTheme: CardThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: _md3LightScheme.surface,
          surfaceTintColor: _md3LightScheme.surfaceTint,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: Typography.material2021().englishLike.labelLarge,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: Typography.material2021().englishLike.labelLarge,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: Typography.material2021().englishLike.labelLarge,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: _md3LightScheme.surfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: _md3LightScheme.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: _md3LightScheme.error,
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          isDense: false,
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          labelStyle: Typography.material2021().englishLike.labelMedium,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        navigationBarTheme: NavigationBarThemeData(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          height: 80,
          indicatorColor: _md3LightScheme.secondaryContainer,
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Typography.material2021().englishLike.labelMedium?.copyWith(
                color: _md3LightScheme.onSecondaryContainer,
                fontWeight: FontWeight.w600,
              );
            }
            return Typography.material2021().englishLike.labelMedium?.copyWith(
              color: _md3LightScheme.onSurfaceVariant,
            );
          }),
          iconTheme: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return IconThemeData(
                color: _md3LightScheme.onSecondaryContainer,
                size: 24,
              );
            }
            return IconThemeData(
              color: _md3LightScheme.onSurfaceVariant,
              size: 24,
            );
          }),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 1,
          backgroundColor: _md3LightScheme.surface,
          foregroundColor: _md3LightScheme.onSurface,
          titleTextStyle: Typography.material2021().englishLike.headlineSmall?.copyWith(
            color: _md3LightScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
          centerTitle: true,
        ),
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return _md3LightScheme.primaryContainer;
              }
              return _md3LightScheme.surfaceVariant;
            }),
            foregroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return _md3LightScheme.onPrimaryContainer;
              }
              return _md3LightScheme.onSurfaceVariant;
            }),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: _md3DarkScheme,
        // Same typography for dark theme
        textTheme: Typography.material2021().englishLike.copyWith(
          displayLarge: Typography.material2021().englishLike.displayLarge?.copyWith(
            fontSize: 57,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.25,
          ),
          displayMedium: Typography.material2021().englishLike.displayMedium?.copyWith(
            fontSize: 45,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
          displaySmall: Typography.material2021().englishLike.displaySmall?.copyWith(
            fontSize: 36,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
          headlineLarge: Typography.material2021().englishLike.headlineLarge?.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
          headlineMedium: Typography.material2021().englishLike.headlineMedium?.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
          headlineSmall: Typography.material2021().englishLike.headlineSmall?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
          titleLarge: Typography.material2021().englishLike.titleLarge?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
          titleMedium: Typography.material2021().englishLike.titleMedium?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
          ),
          titleSmall: Typography.material2021().englishLike.titleSmall?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          bodyLarge: Typography.material2021().englishLike.bodyLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
          bodyMedium: Typography.material2021().englishLike.bodyMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
          ),
          bodySmall: Typography.material2021().englishLike.bodySmall?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4,
          ),
          labelLarge: Typography.material2021().englishLike.labelLarge?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          labelMedium: Typography.material2021().englishLike.labelMedium?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          labelSmall: Typography.material2021().englishLike.labelSmall?.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        // Dark theme component themes
        cardTheme: CardThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: _md3DarkScheme.surface,
          surfaceTintColor: _md3DarkScheme.surfaceTint,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: Typography.material2021().englishLike.labelLarge,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: Typography.material2021().englishLike.labelLarge,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: Typography.material2021().englishLike.labelLarge,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: _md3DarkScheme.surfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: _md3DarkScheme.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: _md3DarkScheme.error,
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          isDense: false,
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          labelStyle: Typography.material2021().englishLike.labelMedium,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        navigationBarTheme: NavigationBarThemeData(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          height: 80,
          indicatorColor: _md3DarkScheme.secondaryContainer,
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Typography.material2021().englishLike.labelMedium?.copyWith(
                color: _md3DarkScheme.onSecondaryContainer,
                fontWeight: FontWeight.w600,
              );
            }
            return Typography.material2021().englishLike.labelMedium?.copyWith(
              color: _md3DarkScheme.onSurfaceVariant,
            );
          }),
          iconTheme: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return IconThemeData(
                color: _md3DarkScheme.onSecondaryContainer,
                size: 24,
              );
            }
            return IconThemeData(
              color: _md3DarkScheme.onSurfaceVariant,
              size: 24,
            );
          }),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 1,
          backgroundColor: _md3DarkScheme.surface,
          foregroundColor: _md3DarkScheme.onSurface,
          titleTextStyle: Typography.material2021().englishLike.headlineSmall?.copyWith(
            color: _md3DarkScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
          centerTitle: true,
        ),
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return _md3DarkScheme.primaryContainer;
              }
              return _md3DarkScheme.surfaceVariant;
            }),
            foregroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return _md3DarkScheme.onPrimaryContainer;
              }
              return _md3DarkScheme.onSurfaceVariant;
            }),
          ),
        ),
      ),
      themeMode: ThemeMode.system, // Support system theme preference
      home: const App(),
      debugShowCheckedModeBanner: false,
    );
  }
}
