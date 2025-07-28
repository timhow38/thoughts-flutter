import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enhanced capture types with comprehensive media support
enum CaptureType {
  text('Text', Icons.text_fields, 'Write your thoughts and ideas'),
  image('Image', Icons.photo_camera, 'Capture or select photos'),
  video('Video', Icons.videocam, 'Record or select videos'),
  audio('Audio', Icons.mic, 'Record voice notes and audio'),
  link('Link', Icons.link, 'Save web links and URLs'),
  document('Document', Icons.description, 'Attach files and documents');

  const CaptureType(this.label, this.icon, this.description);

  final String label;
  final IconData icon;
  final String description;
}

/// Advanced Material Design 3 Type Selector with multiple layout options
class TypeSelector extends ConsumerWidget {
  final CaptureType selectedType;
  final ValueChanged<CaptureType> onTypeChanged;
  final TypeSelectorStyle style;
  final bool showLabels;
  final bool showDescriptions;
  final bool showTitle;
  final bool enableHapticFeedback;
  final EdgeInsetsGeometry? padding;

  const TypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
    this.style = TypeSelectorStyle.segmented,
    this.showLabels = true,
    this.showDescriptions = false,
    this.showTitle = true,
    this.enableHapticFeedback = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Section header with proper Material Design 3 typography
          if (showTitle) ...[
            Text(
              'Content Type',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.15,
              ),
            ),
            if (showDescriptions) ...[
              const SizedBox(height: 4),
              Text(
                'Choose the type of content you want to capture',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 0.25,
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],

          // Type selector based on style
          _buildTypeSelector(context, colorScheme, textTheme),
        ],
      ),
    );
  }

  Widget _buildTypeSelector(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    switch (style) {
      case TypeSelectorStyle.segmented:
        return _buildSegmentedSelector(context, colorScheme, textTheme);
      case TypeSelectorStyle.grid:
        return _buildGridSelector(context, colorScheme, textTheme);
      case TypeSelectorStyle.list:
        return _buildListSelector(context, colorScheme, textTheme);
      case TypeSelectorStyle.chips:
        return _buildChipsSelector(context, colorScheme, textTheme);
      case TypeSelectorStyle.tabs:
        return _buildTabsSelector(context, colorScheme, textTheme);
    }
  }

  /// Enhanced segmented button with proper Material Design 3 styling
  Widget _buildSegmentedSelector(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    // Show all types in a fixed, non-scrollable layout
    return SegmentedButton<CaptureType>(
      segments: CaptureType.values
          .map((type) => ButtonSegment<CaptureType>(
                value: type,
                icon: Icon(
                  type.icon,
                  size: 22,
                  semanticLabel: type.label,
                ),
                label: showLabels
                    ? Text(
                        type.label,
                        style: textTheme.labelMedium?.copyWith(
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                tooltip: type.description,
              ))
          .toList(),
      selected: {selectedType},
      onSelectionChanged: (Set<CaptureType> selection) {
        if (selection.isNotEmpty) {
          if (enableHapticFeedback) {
            HapticFeedback.selectionClick();
          }
          onTypeChanged(selection.first);
        }
      },
      showSelectedIcon: false,
      multiSelectionEnabled: false,
      emptySelectionAllowed: false,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.secondaryContainer;
          }
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.surfaceContainerHighest;
          }
          return colorScheme.surface;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onSecondaryContainer;
          }
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.onSurface;
          }
          return colorScheme.onSurfaceVariant;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.onSurface.withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.hovered)) {
            return colorScheme.onSurface.withValues(alpha: 0.05);
          }
          return null;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BorderSide(color: colorScheme.secondary, width: 1);
          }
          return BorderSide(color: colorScheme.outline, width: 1);
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: showLabels ? 8 : 12,
            vertical: 10,
          ),
        ),
        minimumSize: WidgetStateProperty.all(
          Size(showLabels ? 60 : 48, 44),
        ),
      ),
    );
  }

  /// Grid layout for larger screens with detailed cards
  Widget _buildGridSelector(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: CaptureType.values.length,
      itemBuilder: (context, index) {
        final type = CaptureType.values[index];
        final isSelected = selectedType == type;

        return Card(
          elevation: isSelected ? 3 : 1,
          shadowColor: colorScheme.shadow,
          surfaceTintColor: isSelected ? colorScheme.secondaryContainer : null,
          child: InkWell(
            onTap: () {
              if (enableHapticFeedback) {
                HapticFeedback.selectionClick();
              }
              onTypeChanged(type);
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: colorScheme.primary, width: 2)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? colorScheme.primaryContainer
                          : colorScheme.surfaceContainerHighest,
                    ),
                    child: Icon(
                      type.icon,
                      size: 24,
                      color: isSelected
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    type.label,
                    style: textTheme.titleSmall?.copyWith(
                      color: isSelected
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      letterSpacing: 0.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (showDescriptions) ...[
                    const SizedBox(height: 4),
                    Text(
                      type.description,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        letterSpacing: 0.4,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// List layout with detailed descriptions
  Widget _buildListSelector(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      children: CaptureType.values.map((type) {
        final isSelected = selectedType == type;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: isSelected ? 2 : 0,
          surfaceTintColor: isSelected ? colorScheme.secondaryContainer : null,
          child: ListTile(
            selected: isSelected,
            selectedTileColor:
                colorScheme.secondaryContainer.withValues(alpha: 0.3),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerHighest,
              ),
              child: Icon(
                type.icon,
                size: 20,
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            title: Text(
              type.label,
              style: textTheme.titleMedium?.copyWith(
                color: isSelected
                    ? colorScheme.onSecondaryContainer
                    : colorScheme.onSurface,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.15,
              ),
            ),
            subtitle: Text(
              type.description,
              style: textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? colorScheme.onSecondaryContainer.withValues(alpha: 0.8)
                    : colorScheme.onSurfaceVariant,
                letterSpacing: 0.25,
              ),
            ),
            trailing: isSelected
                ? Icon(
                    Icons.check_circle,
                    color: colorScheme.primary,
                    size: 20,
                  )
                : null,
            onTap: () {
              if (enableHapticFeedback) {
                HapticFeedback.selectionClick();
              }
              onTypeChanged(type);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isSelected
                  ? BorderSide(color: colorScheme.primary, width: 1)
                  : BorderSide.none,
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Chip-based selector with flexible wrapping
  Widget _buildChipsSelector(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: CaptureType.values.map((type) {
        final isSelected = selectedType == type;

        return FilterChip(
          selected: isSelected,
          label: Text(
            type.label,
            style: textTheme.labelLarge?.copyWith(
              color: isSelected
                  ? colorScheme.onSecondaryContainer
                  : colorScheme.onSurfaceVariant,
              letterSpacing: 0.1,
              fontWeight: FontWeight.w500,
            ),
          ),
          avatar: Icon(
            type.icon,
            size: 18,
            color: isSelected
                ? colorScheme.onSecondaryContainer
                : colorScheme.onSurfaceVariant,
          ),
          onSelected: (selected) {
            if (selected) {
              if (enableHapticFeedback) {
                HapticFeedback.selectionClick();
              }
              onTypeChanged(type);
            }
          },
          backgroundColor: colorScheme.surface,
          selectedColor: colorScheme.secondaryContainer,
          side: BorderSide(
            color: isSelected ? colorScheme.secondary : colorScheme.outline,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      }).toList(),
    );
  }

  /// Tab-based selector for horizontal scrolling
  Widget _buildTabsSelector(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final currentIndex = CaptureType.values.indexOf(selectedType);

    return DefaultTabController(
      length: CaptureType.values.length,
      initialIndex: currentIndex >= 0 ? currentIndex : 0,
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: colorScheme.primary,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              labelStyle: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
              ),
              unselectedLabelStyle: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
              ),
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return colorScheme.primary.withValues(alpha: 0.1);
                }
                if (states.contains(WidgetState.hovered)) {
                  return colorScheme.primary.withValues(alpha: 0.05);
                }
                return null;
              }),
              splashFactory: InkRipple.splashFactory,
              onTap: (index) {
                if (index >= 0 && index < CaptureType.values.length) {
                  if (enableHapticFeedback) {
                    HapticFeedback.selectionClick();
                  }
                  onTypeChanged(CaptureType.values[index]);
                }
              },
              tabs: CaptureType.values
                  .map((type) => Tab(
                        icon: Icon(
                          type.icon,
                          size: 20,
                          semanticLabel: type.label,
                        ),
                        text: showLabels ? type.label : null,
                        height: showLabels ? 64 : 48,
                      ))
                  .toList(),
            ),
          ),
          if (showDescriptions) ...[
            const SizedBox(height: 16),
            // Description for selected type
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Container(
                key: ValueKey(selectedType),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
                child: Text(
                  selectedType.description,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 0.25,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Different layout styles for the type selector
enum TypeSelectorStyle {
  segmented, // Segmented button (default, compact)
  grid, // Grid layout (visual, detailed)
  list, // List layout (detailed descriptions)
  chips, // Chip-based (flexible wrapping)
  tabs, // Tab-based (horizontal scrolling)
}

/// Responsive type selector that adapts to screen size
class ResponsiveTypeSelector extends ConsumerWidget {
  final CaptureType selectedType;
  final ValueChanged<CaptureType> onTypeChanged;
  final bool showDescriptions;
  final bool showTitle;
  final EdgeInsetsGeometry? padding;

  const ResponsiveTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
    this.showDescriptions = false,
    this.showTitle = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Adaptive layout based on screen size
    TypeSelectorStyle style;
    bool showLabels = true;

    if (screenWidth < 600) {
      // Mobile: Compact segmented button
      style = TypeSelectorStyle.segmented;
      showLabels = true;
    } else if (screenWidth < 900) {
      // Tablet: Grid layout
      style = TypeSelectorStyle.grid;
      showLabels = true;
    } else {
      // Desktop: List with descriptions
      style = TypeSelectorStyle.list;
      showLabels = true;
    }

    return TypeSelector(
      selectedType: selectedType,
      onTypeChanged: onTypeChanged,
      style: style,
      showLabels: showLabels,
      showDescriptions: showDescriptions || screenWidth > 900,
      showTitle: showTitle,
      padding: padding,
    );
  }
}
