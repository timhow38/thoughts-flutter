import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';

// Advanced Material Design 3 Dynamic Color System
final ColorScheme _md3LightScheme = ColorScheme.fromSeed(
  seedColor:
      const Color(0xFF6750A4), // Primary purple with Material You compatibility
  brightness: Brightness.light,
  // Complete surface hierarchy for proper elevation
  surface: const Color(0xFFFFFBFE),
  surfaceContainer: const Color(0xFFF3F1F5),
  surfaceContainerLow: const Color(0xFFF7F5F9),
  surfaceContainerHigh: const Color(0xFFEDE9ED),
  surfaceContainerHighest: const Color(0xFFE7E3E7),
  surfaceDim: const Color(0xFFDDD8DC),
  surfaceBright: const Color(0xFFFFFBFE),
  // Enhanced outline system
  outline: const Color(0xFF79747E),
  outlineVariant: const Color(0xFFCAC4D0),
  // Inverse colors for high contrast
  inverseSurface: const Color(0xFF313033),
  inversePrimary: const Color(0xFFD0BCFF),
);

final ColorScheme _md3DarkScheme = ColorScheme.fromSeed(
  seedColor:
      const Color(0xFF6750A4), // Primary purple with Material You compatibility
  brightness: Brightness.dark,
  // Complete surface hierarchy for proper elevation
  surface: const Color(0xFF1C1B1F),
  surfaceContainer: const Color(0xFF211F26),
  surfaceContainerLow: const Color(0xFF1C1B1F),
  surfaceContainerHigh: const Color(0xFF2B2930),
  surfaceContainerHighest: const Color(0xFF36343B),
  surfaceDim: const Color(0xFF1C1B1F),
  surfaceBright: const Color(0xFF423F47),
  // Enhanced outline system
  outline: const Color(0xFF938F99),
  outlineVariant: const Color(0xFF49454F),
  // Inverse colors for high contrast
  inverseSurface: const Color(0xFFE6E1E5),
  inversePrimary: const Color(0xFF6750A4),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Performance optimizations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize local storage
  await Hive.initFlutter();

  // Memory management optimization
  PaintingBinding.instance.imageCache.maximumSize = 100;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20; // 50MB

  runApp(const ProviderScope(child: MyApp()));
}

// Complete Material Design 3 Typography Scale
TextTheme _buildMD3TextTheme() {
  return Typography.material2021().englishLike.copyWith(
        displayLarge: const TextStyle(
          fontSize: 57,
          height: 64 / 57,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
        ),
        displayMedium: const TextStyle(
          fontSize: 45,
          height: 52 / 45,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
        displaySmall: const TextStyle(
          fontSize: 36,
          height: 44 / 36,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
        headlineLarge: const TextStyle(
          fontSize: 32,
          height: 40 / 32,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
        headlineMedium: const TextStyle(
          fontSize: 28,
          height: 36 / 28,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
        headlineSmall: const TextStyle(
          fontSize: 24,
          height: 32 / 24,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
        titleLarge: const TextStyle(
          fontSize: 22,
          height: 28 / 22,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
        titleMedium: const TextStyle(
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        titleSmall: const TextStyle(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        bodySmall: const TextStyle(
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
        ),
        labelLarge: const TextStyle(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        labelMedium: const TextStyle(
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        labelSmall: const TextStyle(
          fontSize: 11,
          height: 16 / 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      );
}

// Advanced Card Theme with proper elevation and surface tinting
CardThemeData _buildCardTheme(ColorScheme colorScheme) {
  return CardThemeData(
    elevation: 1,
    shadowColor: colorScheme.shadow,
    surfaceTintColor: colorScheme.surfaceTint,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    clipBehavior: Clip.antiAlias,
    margin: const EdgeInsets.all(4),
  );
}

// Enhanced Button Themes with proper touch targets and accessibility
ElevatedButtonThemeData _buildElevatedButtonTheme() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 1,
      shadowColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      minimumSize: const Size(64, 40),
      maximumSize: const Size.fromHeight(40),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
    ),
  );
}

FilledButtonThemeData _buildFilledButtonTheme() {
  return FilledButtonThemeData(
    style: FilledButton.styleFrom(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      minimumSize: const Size(64, 40),
      maximumSize: const Size.fromHeight(40),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
    ),
  );
}

OutlinedButtonThemeData _buildOutlinedButtonTheme() {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      minimumSize: const Size(64, 40),
      maximumSize: const Size.fromHeight(40),
      side: const BorderSide(width: 1),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
    ),
  );
}

TextButtonThemeData _buildTextButtonTheme() {
  return TextButtonThemeData(
    style: TextButton.styleFrom(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      minimumSize: const Size(48, 40),
      maximumSize: const Size.fromHeight(40),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
    ),
  );
}

// Advanced Input Decoration Theme
InputDecorationTheme _buildInputDecorationTheme(ColorScheme colorScheme) {
  return InputDecorationTheme(
    filled: true,
    fillColor: colorScheme.surfaceContainerHighest,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
      borderSide: BorderSide(color: colorScheme.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.error, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.error, width: 2),
    ),
    labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
    hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
    helperStyle: TextStyle(color: colorScheme.onSurfaceVariant),
    errorStyle: TextStyle(color: colorScheme.error),
  );
}

// Enhanced Navigation Bar Theme
NavigationBarThemeData _buildNavigationBarTheme(ColorScheme colorScheme) {
  return NavigationBarThemeData(
    height: 80,
    elevation: 3,
    shadowColor: colorScheme.shadow,
    surfaceTintColor: colorScheme.surfaceTint,
    backgroundColor: colorScheme.surface,
    indicatorColor: colorScheme.secondaryContainer,
    indicatorShape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: colorScheme.onSecondaryContainer,
        );
      }
      return TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: colorScheme.onSurfaceVariant,
      );
    }),
    iconTheme: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return IconThemeData(
          color: colorScheme.onSecondaryContainer,
          size: 24,
        );
      }
      return IconThemeData(
        color: colorScheme.onSurfaceVariant,
        size: 24,
      );
    }),
  );
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
        textTheme: _buildMD3TextTheme(),
        cardTheme: _buildCardTheme(_md3LightScheme),
        elevatedButtonTheme: _buildElevatedButtonTheme(),
        filledButtonTheme: _buildFilledButtonTheme(),
        outlinedButtonTheme: _buildOutlinedButtonTheme(),
        textButtonTheme: _buildTextButtonTheme(),
        inputDecorationTheme: _buildInputDecorationTheme(_md3LightScheme),
        navigationBarTheme: _buildNavigationBarTheme(_md3LightScheme),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          side: BorderSide.none,
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 3,
          shadowColor: _md3LightScheme.shadow,
          surfaceTintColor: _md3LightScheme.surfaceTint,
          backgroundColor: _md3LightScheme.surface,
          foregroundColor: _md3LightScheme.onSurface,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
            color: _md3LightScheme.onSurface,
          ),
          centerTitle: true,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 6,
          highlightElevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return _md3LightScheme.secondaryContainer;
              }
              return _md3LightScheme.surface;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return _md3LightScheme.onSecondaryContainer;
              }
              return _md3LightScheme.onSurface;
            }),
            side: WidgetStateProperty.all(
              BorderSide(color: _md3LightScheme.outline),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: _md3DarkScheme,
        textTheme: _buildMD3TextTheme(),
        cardTheme: _buildCardTheme(_md3DarkScheme),
        elevatedButtonTheme: _buildElevatedButtonTheme(),
        filledButtonTheme: _buildFilledButtonTheme(),
        outlinedButtonTheme: _buildOutlinedButtonTheme(),
        textButtonTheme: _buildTextButtonTheme(),
        inputDecorationTheme: _buildInputDecorationTheme(_md3DarkScheme),
        navigationBarTheme: _buildNavigationBarTheme(_md3DarkScheme),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          side: BorderSide.none,
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 3,
          shadowColor: _md3DarkScheme.shadow,
          surfaceTintColor: _md3DarkScheme.surfaceTint,
          backgroundColor: _md3DarkScheme.surface,
          foregroundColor: _md3DarkScheme.onSurface,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
            color: _md3DarkScheme.onSurface,
          ),
          centerTitle: true,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 6,
          highlightElevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return _md3DarkScheme.secondaryContainer;
              }
              return _md3DarkScheme.surface;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return _md3DarkScheme.onSecondaryContainer;
              }
              return _md3DarkScheme.onSurface;
            }),
            side: WidgetStateProperty.all(
              BorderSide(color: _md3DarkScheme.outline),
            ),
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const App(),
      debugShowCheckedModeBanner: false,
      // Performance optimizations
      builder: (context, child) {
        return MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        );
      },
    );
  }
}
