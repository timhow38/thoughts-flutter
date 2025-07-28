import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/idea.dart';
import '../../repositories/ideas_repository.dart';
import '../capture/capture_page.dart';

/// Page displaying personal ideas list
class IdeasListPage extends ConsumerWidget {
  const IdeasListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalIdeasAsync = ref.watch(personalIdeasProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'My Ideas',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        surfaceTintColor: colorScheme.surfaceTint,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: personalIdeasAsync.when(
        data: (ideas) =>
            _buildIdeasList(context, ideas, colorScheme, textTheme),
        loading: () => Center(
          child: CircularProgressIndicator(
            color: colorScheme.primary,
          ),
        ),
        error: (error, stack) =>
            _buildErrorState(context, error, colorScheme, textTheme),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CapturePage(),
            ),
          );
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildIdeasList(
    BuildContext context,
    List<Idea> ideas,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    if (ideas.isEmpty) {
      return _buildEmptyState(context, colorScheme, textTheme);
    }

    // Sort ideas by creation date (newest first)
    final sortedIdeas = [...ideas]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh the ideas list
        // The provider will automatically update
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedIdeas.length,
        itemBuilder: (context, index) {
          final idea = sortedIdeas[index];
          return _buildIdeaCard(context, idea, colorScheme, textTheme);
        },
      ),
    );
  }

  Widget _buildIdeaCard(
    BuildContext context,
    Idea idea,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to idea detail page
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with type icon and date
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getTypeColor(idea.type, colorScheme)
                          .withValues(alpha: 0.1),
                    ),
                    child: Icon(
                      _getTypeIcon(idea.type),
                      size: 16,
                      color: _getTypeColor(idea.type, colorScheme),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTypeLabel(idea.type),
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          _formatDate(idea.createdAt),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (idea.isPinned)
                    Icon(
                      Icons.push_pin,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Content
              Text(
                idea.displayText,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              // Tags
              if (idea.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: idea.tags.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],

              // Category
              if (idea.category != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.category_outlined,
                      size: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      idea.category!,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primaryContainer,
              ),
              child: Icon(
                Icons.lightbulb_outline,
                size: 60,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Ideas Yet',
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start capturing your thoughts and ideas.\nTap the + button to create your first idea!',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CapturePage(),
                  ),
                );
              },
              icon: Icon(Icons.add),
              label: Text('Create First Idea'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    Object error,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error Loading Ideas',
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                // Trigger a refresh by invalidating the provider
                // ref.invalidate(personalIdeasProvider);
              },
              icon: Icon(Icons.refresh),
              label: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(IdeaType type) {
    switch (type) {
      case IdeaType.text:
        return Icons.text_fields;
      case IdeaType.image:
        return Icons.photo_camera;
      case IdeaType.video:
        return Icons.videocam;
      case IdeaType.audio:
        return Icons.mic;
      case IdeaType.link:
        return Icons.link;
    }
  }

  Color _getTypeColor(IdeaType type, ColorScheme colorScheme) {
    switch (type) {
      case IdeaType.text:
        return colorScheme.primary;
      case IdeaType.image:
        return colorScheme.secondary;
      case IdeaType.video:
        return colorScheme.tertiary;
      case IdeaType.audio:
        return colorScheme.error;
      case IdeaType.link:
        return Colors.orange;
    }
  }

  String _getTypeLabel(IdeaType type) {
    switch (type) {
      case IdeaType.text:
        return 'Text';
      case IdeaType.image:
        return 'Image';
      case IdeaType.video:
        return 'Video';
      case IdeaType.audio:
        return 'Audio';
      case IdeaType.link:
        return 'Link';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
