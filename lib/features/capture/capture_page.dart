import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Capture types
enum CaptureType { text, image, video, audio }

final _captureTypeProvider =
    StateProvider<CaptureType>((ref) => CaptureType.text);
final _contentProvider = StateProvider<String>((ref) => '');
final _titleProvider = StateProvider<String>((ref) => '');
final _submittingProvider = StateProvider<bool>((ref) => false);
final _categoryProvider = StateProvider<String?>((ref) => null);
final _tagProvider = StateProvider<List<String>>((ref) => []);

class CapturePage extends ConsumerWidget {
  const CapturePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(_captureTypeProvider);
    final content = ref.watch(_contentProvider);
    final title = ref.watch(_titleProvider);
    final submitting = ref.watch(_submittingProvider);
    final selectedCategory = ref.watch(_categoryProvider);
    final selectedTags = ref.watch(_tagProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('Capture Idea'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              // TODO: Handle close/discard
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Type Selector using SegmentedButton
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Type',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SegmentedButton<CaptureType>(
                        segments: [
                          ButtonSegment<CaptureType>(
                            value: CaptureType.text,
                            icon: Icon(Icons.text_fields, size: 20),
                            label: Text('Text'),
                          ),
                          ButtonSegment<CaptureType>(
                            value: CaptureType.image,
                            icon: Icon(Icons.photo_camera, size: 20),
                            label: Text('Image'),
                          ),
                          ButtonSegment<CaptureType>(
                            value: CaptureType.video,
                            icon: Icon(Icons.videocam, size: 20),
                            label: Text('Video'),
                          ),
                          ButtonSegment<CaptureType>(
                            value: CaptureType.audio,
                            icon: Icon(Icons.mic, size: 20),
                            label: Text('Audio'),
                          ),
                        ],
                        selected: {type},
                        onSelectionChanged: (set) =>
                            ref.read(_captureTypeProvider.notifier).state = set.first,
                        showSelectedIcon: false,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Content Card
              Expanded(
                child: Card(
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
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          onChanged: (v) =>
                              ref.read(_titleProvider.notifier).state = v,
                          controller: TextEditingController(text: title),
                        ),
                        const SizedBox(height: 20),
                        
                        // Content based on type
                        Expanded(
                          child: _buildContentField(context, ref, type, content, submitting),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Tags and Categories
                        _buildTagsAndCategories(context, ref, selectedCategory, selectedTags),
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
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Save as draft
                      },
                      icon: Icon(Icons.save_outlined),
                      label: Text('Save Draft'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: submitting || content.trim().isEmpty
                          ? null
                          : () async {
                              // TODO: Save/submit logic
                            },
                      icon: Icon(Icons.check),
                      label: Text(
                        type == CaptureType.text ? 'Save Idea' : 'Save Media',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
          onChanged: (v) =>
              ref.read(_contentProvider.notifier).state = v,
          controller: TextEditingController(text: content),
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
              color: color.withOpacity(0.1),
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
}
