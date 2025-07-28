import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'type_selector.dart';

/// Demo page showcasing different TypeSelector styles and configurations
/// Demonstrates Material Design 3 implementation with comprehensive examples
class TypeSelectorDemo extends ConsumerStatefulWidget {
  const TypeSelectorDemo({super.key});

  @override
  ConsumerState<TypeSelectorDemo> createState() => _TypeSelectorDemoState();
}

class _TypeSelectorDemoState extends ConsumerState<TypeSelectorDemo> {
  CaptureType _segmentedType = CaptureType.text;
  CaptureType _gridType = CaptureType.image;
  CaptureType _listType = CaptureType.video;
  CaptureType _chipsType = CaptureType.audio;
  CaptureType _tabsType = CaptureType.link;
  CaptureType _responsiveType = CaptureType.document;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Type Selector Demo',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        surfaceTintColor: colorScheme.surfaceTint,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TypeSelector Component Demo',
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Explore different styles and configurations of the TypeSelector widget, built with Material Design 3 principles.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Segmented Style Demo
            _buildDemoSection(
              context,
              title: 'Segmented Button Style',
              description:
                  'Compact horizontal layout, ideal for mobile interfaces',
              child: TypeSelector(
                selectedType: _segmentedType,
                onTypeChanged: (type) => setState(() => _segmentedType = type),
                style: TypeSelectorStyle.segmented,
                showLabels: true,
                showDescriptions: false,
              ),
            ),

            // Grid Style Demo
            _buildDemoSection(
              context,
              title: 'Grid Layout Style',
              description: 'Visual card-based layout with detailed information',
              child: TypeSelector(
                selectedType: _gridType,
                onTypeChanged: (type) => setState(() => _gridType = type),
                style: TypeSelectorStyle.grid,
                showLabels: true,
                showDescriptions: true,
              ),
            ),

            // List Style Demo
            _buildDemoSection(
              context,
              title: 'List Layout Style',
              description:
                  'Detailed list with descriptions and selection indicators',
              child: TypeSelector(
                selectedType: _listType,
                onTypeChanged: (type) => setState(() => _listType = type),
                style: TypeSelectorStyle.list,
                showLabels: true,
                showDescriptions: true,
              ),
            ),

            // Chips Style Demo
            _buildDemoSection(
              context,
              title: 'Filter Chips Style',
              description: 'Flexible wrapping layout with chip-based selection',
              child: TypeSelector(
                selectedType: _chipsType,
                onTypeChanged: (type) => setState(() => _chipsType = type),
                style: TypeSelectorStyle.chips,
                showLabels: true,
                showDescriptions: false,
              ),
            ),

            // Tabs Style Demo
            _buildDemoSection(
              context,
              title: 'Tabs Style',
              description:
                  'Horizontal scrolling tabs with contextual descriptions',
              child: TypeSelector(
                selectedType: _tabsType,
                onTypeChanged: (type) => setState(() => _tabsType = type),
                style: TypeSelectorStyle.tabs,
                showLabels: true,
                showDescriptions: true,
              ),
            ),

            // Responsive Demo
            _buildDemoSection(
              context,
              title: 'Responsive Adaptive Style',
              description:
                  'Automatically adapts layout based on screen size and context',
              child: ResponsiveTypeSelector(
                selectedType: _responsiveType,
                onTypeChanged: (type) => setState(() => _responsiveType = type),
                showDescriptions: true,
              ),
            ),

            // Configuration Options Demo
            _buildConfigurationDemo(context),

            // Usage Examples
            _buildUsageExamples(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoSection(
    BuildContext context, {
    required String title,
    required String description,
    required Widget child,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 1,
          child: child,
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildConfigurationDemo(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configuration Options',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Different configurations and customization options',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),

        // Compact without labels
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Compact (Icons Only)',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TypeSelector(
                selectedType: _segmentedType,
                onTypeChanged: (type) => setState(() => _segmentedType = type),
                style: TypeSelectorStyle.segmented,
                showLabels: false,
                showDescriptions: false,
                padding: const EdgeInsets.all(16),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // With custom padding
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                child: Text(
                  'Custom Padding & Spacing',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TypeSelector(
                selectedType: _chipsType,
                onTypeChanged: (type) => setState(() => _chipsType = type),
                style: TypeSelectorStyle.chips,
                showLabels: true,
                showDescriptions: false,
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildUsageExamples(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Usage Examples',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Common implementation patterns and best practices',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Basic Implementation',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '''TypeSelector(
  selectedType: selectedType,
  onTypeChanged: (type) => setState(() => selectedType = type),
  style: TypeSelectorStyle.segmented,
  showLabels: true,
  showDescriptions: false,
)''',
                    style: textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Responsive Implementation',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '''ResponsiveTypeSelector(
  selectedType: selectedType,
  onTypeChanged: (type) => setState(() => selectedType = type),
  showDescriptions: true,
)''',
                    style: textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Feature highlights
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Key Features',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _buildFeatureItem(
                  context,
                  icon: Icons.devices,
                  title: 'Responsive Design',
                  description:
                      'Automatically adapts to screen size and orientation',
                ),
                _buildFeatureItem(
                  context,
                  icon: Icons.palette,
                  title: 'Material Design 3',
                  description:
                      'Full MD3 theming with dynamic colors and elevation',
                ),
                _buildFeatureItem(
                  context,
                  icon: Icons.accessibility,
                  title: 'Accessibility',
                  description:
                      'Screen reader support, proper focus management, and semantic labels',
                ),
                _buildFeatureItem(
                  context,
                  icon: Icons.touch_app,
                  title: 'Haptic Feedback',
                  description:
                      'Optional haptic feedback for enhanced user experience',
                ),
                _buildFeatureItem(
                  context,
                  icon: Icons.style,
                  title: 'Multiple Styles',
                  description:
                      'Five different layout styles for various use cases',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primaryContainer,
            ),
            child: Icon(
              icon,
              size: 20,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
