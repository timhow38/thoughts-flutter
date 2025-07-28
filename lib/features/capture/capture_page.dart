import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/type_selector.dart';
import '../../repositories/ideas_repository.dart';

final _captureTypeProvider =
    StateProvider<CaptureType>((ref) => CaptureType.text);
final _contentProvider = StateProvider<String>((ref) => '');
final _titleProvider = StateProvider<String>((ref) => '');
final _submittingProvider = StateProvider<bool>((ref) => false);
final _categoryProvider = StateProvider<String?>((ref) => null);
final _tagProvider = StateProvider<List<String>>((ref) => []);
final _currentRoomProvider = StateProvider<String?>((ref) => null);

class CapturePage extends ConsumerWidget {
  final String? roomId; // Optional room ID for room ideas

  const CapturePage({super.key, this.roomId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(_captureTypeProvider);
    final content = ref.watch(_contentProvider);
    final title = ref.watch(_titleProvider);
    final submitting = ref.watch(_submittingProvider);
    final selectedCategory = ref.watch(_categoryProvider);
    final selectedTags = ref.watch(_tagProvider);
    final repository = ref.watch(ideasRepositoryProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Set current room in provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(_currentRoomProvider.notifier).state = roomId;
    });

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Content Type Navigation at the top
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
              ),
              child: TypeSelector(
                selectedType: type,
                onTypeChanged: (newType) {
                  ref.read(_captureTypeProvider.notifier).state = newType;
                },
                style: TypeSelectorStyle.segmented,
                showLabels: false,
                showDescriptions: false,
                showTitle: false,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              ),
            ),

            // Main content area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Content Card
                    Expanded(
                      child: Card(
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Title Field
                              TextField(
                                style: textTheme.titleLarge?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Title (optional)',
                                  hintText: 'Give your idea a title',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                                onChanged: (v) =>
                                    ref.read(_titleProvider.notifier).state = v,
                              ),
                              const SizedBox(height: 20),

                              // Content based on type
                              Expanded(
                                child: _buildContentField(
                                    context, ref, type, content, submitting),
                              ),

                              const SizedBox(height: 20),

                              // Tags and Categories
                              _buildTagsAndCategories(
                                  context, ref, selectedCategory, selectedTags),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: submitting ||
                                    _isContentEmpty(type, content, title)
                                ? null
                                : () =>
                                    _savePersonalIdea(context, ref, repository),
                            icon: submitting
                                ? SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: colorScheme.onPrimary,
                                    ),
                                  )
                                : Icon(Icons.person),
                            label: Text(
                              submitting ? 'Saving...' : 'Save Personal',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: null, // Disabled for now
                            icon: Icon(Icons.group),
                            label: Text('Save to Room'),
                            style: FilledButton.styleFrom(
                              backgroundColor:
                                  colorScheme.surfaceContainerHighest,
                              foregroundColor: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentField(
    BuildContext context,
    WidgetRef ref,
    CaptureType type,
    String content,
    bool submitting,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    switch (type) {
      case CaptureType.text:
        return TextField(
          minLines: 8,
          maxLines: 12,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            labelText: 'What are you thinking?',
            hintText: 'Write your idea or note here...',
            alignLabelWithHint: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          onChanged: (v) => ref.read(_contentProvider.notifier).state = v,
          enabled: !submitting,
        );

      case CaptureType.image:
        return _buildMediaPlaceholder(
          context,
          icon: Icons.photo_camera,
          title: 'Add Image',
          subtitle: 'Take a photo or select from gallery',
          color: colorScheme.primary,
        );

      case CaptureType.video:
        return _buildMediaPlaceholder(
          context,
          icon: Icons.videocam,
          title: 'Add Video',
          subtitle: 'Record a video or select from gallery',
          color: colorScheme.secondary,
        );

      case CaptureType.audio:
        return _buildMediaPlaceholder(
          context,
          icon: Icons.mic,
          title: 'Add Audio',
          subtitle: 'Record audio or select from files',
          color: colorScheme.tertiary,
        );

      case CaptureType.link:
        return Column(
          children: [
            TextField(
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                labelText: 'URL',
                hintText: 'https://example.com',
                prefixIcon: Icon(Icons.link, color: colorScheme.primary),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              keyboardType: TextInputType.url,
              onChanged: (v) => ref.read(_contentProvider.notifier).state = v,
              enabled: !submitting,
            ),
            const SizedBox(height: 16),
            TextField(
              minLines: 3,
              maxLines: 6,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Add a description or note about this link...',
                alignLabelWithHint: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              enabled: !submitting,
            ),
          ],
        );

      case CaptureType.document:
        return _buildMediaPlaceholder(
          context,
          icon: Icons.description,
          title: 'Add Document',
          subtitle: 'Select files, PDFs, or documents',
          color: colorScheme.error,
        );
    }
  }

  Widget _buildMediaPlaceholder(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.1),
            ),
            child: Icon(
              icon,
              size: 40,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              // TODO: Implement media capture
            },
            icon: Icon(Icons.add),
            label: Text('Add $title'),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsAndCategories(
    BuildContext context,
    WidgetRef ref,
    String? selectedCategory,
    List<String> selectedTags,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Organization',
          style: textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Category chip
            GestureDetector(
              onTap: () {
                // TODO: Show category picker dialog
              },
              child: Chip(
                label: Text(
                  selectedCategory ?? 'Category',
                  style: textTheme.labelMedium,
                ),
                avatar: Icon(
                  Icons.category_outlined,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                backgroundColor: colorScheme.secondaryContainer,
                side: BorderSide.none,
              ),
            ),
            const SizedBox(width: 12),
            // Tag chips
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...selectedTags.map((tag) => InputChip(
                        label: Text(tag, style: textTheme.labelMedium),
                        onDeleted: () {
                          final list = [...selectedTags];
                          list.remove(tag);
                          ref.read(_tagProvider.notifier).state = list;
                        },
                        backgroundColor: colorScheme.tertiaryContainer,
                        side: BorderSide.none,
                      )),
                  ActionChip(
                    label: Text('Tags', style: textTheme.labelMedium),
                    avatar: Icon(
                      Icons.add,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    backgroundColor: colorScheme.tertiaryContainer,
                    side: BorderSide.none,
                    onPressed: () {
                      // TODO: Show tag picker dialog
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Check if content is empty based on capture type
  bool _isContentEmpty(CaptureType type, String content, String title) {
    switch (type) {
      case CaptureType.text:
        return content.trim().isEmpty && title.trim().isEmpty;
      case CaptureType.link:
        return content.trim().isEmpty; // URL is required
      case CaptureType.image:
      case CaptureType.video:
      case CaptureType.audio:
      case CaptureType.document:
        // For media types, we'd check if media is selected
        // For now, allow saving with just title/description
        return false;
    }
  }

  /// Save the idea as a personal idea
  Future<void> _savePersonalIdea(
      BuildContext context, WidgetRef ref, IdeasRepository repository) async {
    final type = ref.read(_captureTypeProvider);
    final content = ref.read(_contentProvider);
    final title = ref.read(_titleProvider);
    final category = ref.read(_categoryProvider);
    final tags = ref.read(_tagProvider);

    // Set submitting state
    ref.read(_submittingProvider.notifier).state = true;

    try {
      await repository.createIdea(
        type: type,
        title: title.trim().isEmpty ? null : title.trim(),
        content: content.trim().isEmpty ? null : content.trim(),
        roomId: null, // Always null for personal ideas
        tags: tags,
        category: category,
      );

      // Reset submitting state first
      ref.read(_submittingProvider.notifier).state = false;

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Personal idea saved successfully!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );

        // Clear form
        _clearForm(ref);

        // Small delay to ensure UI updates, then navigate
        await Future.delayed(const Duration(milliseconds: 100));

        if (context.mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      // Reset submitting state on error
      ref.read(_submittingProvider.notifier).state = false;

      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save idea: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Show room selector dialog
  Future<void> _showRoomSelector(
      BuildContext context, WidgetRef ref, IdeasRepository repository) async {
    // For now, we'll create a simple dialog
    // In a real app, you'd load available rooms from storage
    final availableRooms = [
      {'id': 'room1', 'name': 'Team Brainstorm'},
      {'id': 'room2', 'name': 'Project Ideas'},
      {'id': 'room3', 'name': 'Innovation Lab'},
    ];

    final selectedRoom = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Room'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: availableRooms.map((room) {
              return ListTile(
                leading: Icon(Icons.group),
                title: Text(room['name']!),
                subtitle: Text('Room ID: ${room['id']}'),
                onTap: () => Navigator.of(context).pop(room),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (selectedRoom != null) {
      await _saveToRoom(context, ref, repository, selectedRoom['id']!);
    }
  }

  /// Save the idea to a specific room
  Future<void> _saveToRoom(BuildContext context, WidgetRef ref,
      IdeasRepository repository, String roomId) async {
    final type = ref.read(_captureTypeProvider);
    final content = ref.read(_contentProvider);
    final title = ref.read(_titleProvider);
    final category = ref.read(_categoryProvider);
    final tags = ref.read(_tagProvider);

    // Set submitting state
    ref.read(_submittingProvider.notifier).state = true;

    try {
      await repository.createIdea(
        type: type,
        title: title.trim().isEmpty ? null : title.trim(),
        content: content.trim().isEmpty ? null : content.trim(),
        roomId: roomId,
        tags: tags,
        category: category,
      );

      // Reset submitting state first
      ref.read(_submittingProvider.notifier).state = false;

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Idea saved and shared with room!'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );

        // Clear form
        _clearForm(ref);

        // Small delay to ensure UI updates, then navigate
        await Future.delayed(const Duration(milliseconds: 100));

        if (context.mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      // Reset submitting state on error
      ref.read(_submittingProvider.notifier).state = false;

      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save idea to room: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Clear the form after successful save
  void _clearForm(WidgetRef ref) {
    ref.read(_contentProvider.notifier).state = '';
    ref.read(_titleProvider.notifier).state = '';
    ref.read(_categoryProvider.notifier).state = null;
    ref.read(_tagProvider.notifier).state = [];
    ref.read(_captureTypeProvider.notifier).state = CaptureType.text;
  }
}
