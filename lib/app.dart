import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/capture/capture_page.dart';
import 'features/navigation/nav_bar.dart';
import 'features/ideas/idea_card.dart';
import 'features/ideas/ideas_list_page.dart';
import 'features/rooms/room_card.dart';
import 'models/idea.dart';
import 'models/room.dart';

// State management with proper disposal
final _tabProvider = StateProvider<int>((ref) => 1); // Start with Ideas tab
final _searchQueryProvider = StateProvider<String>((ref) => '');
final _selectedFilterProvider = StateProvider<String?>((ref) => null);

// Sample data for demonstration - following Material Design 3 patterns
final List<Idea> _sampleIdeas = [
  Idea(
    id: '1',
    text:
        'Create a new mobile app for idea sharing with real-time collaboration features and offline-first architecture.',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  Idea(
    id: '2',
    text:
        'Design a minimalist UI with Material Design 3 principles for better user experience and accessibility.',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Idea(
    id: '3',
    text:
        'Implement comprehensive security measures including end-to-end encryption and biometric authentication.',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Idea(
    id: '4',
    text:
        'Add support for different media types: text, images, videos, and audio recordings with proper compression.',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
];

final List<Room> _sampleRooms = [
  Room(
    id: '1',
    code: 'ABC123',
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
    lastActive: DateTime.now().subtract(const Duration(hours: 1)),
  ),
  Room(
    id: '2',
    code: 'XYZ789',
    password: 'secret',
    createdAt: DateTime.now().subtract(const Duration(days: 14)),
    lastActive: DateTime.now().subtract(const Duration(days: 1)),
  ),
];

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(_tabProvider);

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: const [
          CapturePage(),
          IdeasListPage(),
          RoomsScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: NavBar(
        currentIndex: index,
        onTap: (idx) {
          // Haptic feedback for better UX
          HapticFeedback.selectionClick();
          ref.read(_tabProvider.notifier).state = idx;
        },
      ),
      // Context-aware FAB
      floatingActionButton: _buildContextualFAB(context, index, ref),
    );
  }

  Widget? _buildContextualFAB(BuildContext context, int index, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    if (index == 1) {
      // Ideas screen - Quick capture FAB
      return FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CapturePage(),
            ),
          );
        },
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        icon: const Icon(Icons.add),
        label: const Text('New Idea'),
      );
    } else if (index == 2) {
      // Rooms screen - Create room FAB
      return FloatingActionButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          _showCreateRoomDialog(context);
        },
        backgroundColor: colorScheme.secondaryContainer,
        foregroundColor: colorScheme.onSecondaryContainer,
        child: const Icon(Icons.group_add),
      );
    }
    return null;
  }

  void _showCreateRoomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateRoomDialog(),
    );
  }
}

class IdeasListScreen extends ConsumerWidget {
  const IdeasListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(_searchQueryProvider);
    final selectedFilter = ref.watch(_selectedFilterProvider);

    // Filter ideas based on search and filter
    final filteredIdeas = _sampleIdeas.where((idea) {
      if (searchQuery.isNotEmpty) {
        return idea.text?.toLowerCase().contains(searchQuery.toLowerCase()) ??
            false;
      }
      return true;
    }).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, ref, searchQuery),
          if (filteredIdeas.isEmpty)
            SliverFillRemaining(
              child: _buildEmptyState(context),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              sliver: SliverList.builder(
                itemCount: filteredIdeas.length,
                itemBuilder: (context, index) {
                  final idea = filteredIdeas[index];
                  return IdeaCard(
                    idea: idea,
                    onTap: () => _navigateToIdeaDetail(context, idea),
                    onLongPress: () => _showIdeaContextMenu(context, idea),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(
      BuildContext context, WidgetRef ref, String searchQuery) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      snap: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'My Ideas',
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => _showSearchDelegate(context, ref),
          tooltip: 'Search ideas',
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.filter_list),
          tooltip: 'Filter ideas',
          onSelected: (value) {
            ref.read(_selectedFilterProvider.notifier).state = value;
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'recent',
              child: Text('Recent'),
            ),
            const PopupMenuItem(
              value: 'text',
              child: Text('Text only'),
            ),
            const PopupMenuItem(
              value: 'media',
              child: Text('With media'),
            ),
            const PopupMenuItem(
              value: 'shared',
              child: Text('Shared in rooms'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Material Design 3 expressive illustration
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
            const SizedBox(height: 32),
            Text(
              'No ideas yet',
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start capturing your thoughts and ideas. Your creativity begins here.',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                // Navigate to capture page
              },
              icon: const Icon(Icons.add),
              label: const Text('Capture Your First Idea'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDelegate(BuildContext context, WidgetRef ref) {
    showSearch(
      context: context,
      delegate: IdeaSearchDelegate(ref),
    );
  }

  void _navigateToIdeaDetail(BuildContext context, Idea idea) {
    // TODO: Navigate to idea detail page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening idea: ${idea.id}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showIdeaContextMenu(BuildContext context, Idea idea) {
    showModalBottomSheet(
      context: context,
      builder: (context) => IdeaContextMenu(idea: idea),
    );
  }
}

class RoomsScreen extends ConsumerWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          if (_sampleRooms.isEmpty)
            SliverFillRemaining(
              child: _buildEmptyState(context),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              sliver: SliverList.builder(
                itemCount: _sampleRooms.length,
                itemBuilder: (context, index) {
                  final room = _sampleRooms[index];
                  return RoomCard(
                    room: room,
                    onTap: () => _navigateToRoom(context, room),
                    onLongPress: () => _showRoomContextMenu(context, room),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      snap: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Rooms',
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.qr_code_scanner),
          onPressed: () => _showJoinRoomDialog(context),
          tooltip: 'Join room',
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.secondaryContainer,
              ),
              child: Icon(
                Icons.group,
                size: 60,
                color: colorScheme.onSecondaryContainer,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No rooms yet',
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create a room to share ideas with friends in real-time collaboration.',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: () => _showCreateRoomDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Create Room'),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () => _showJoinRoomDialog(context),
                  icon: const Icon(Icons.login),
                  label: const Text('Join Room'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateRoomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateRoomDialog(),
    );
  }

  void _showJoinRoomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const JoinRoomDialog(),
    );
  }

  void _navigateToRoom(BuildContext context, Room room) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening room: ${room.code}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showRoomContextMenu(BuildContext context, Room room) {
    showModalBottomSheet(
      context: context,
      builder: (context) => RoomContextMenu(room: room),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            snap: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Settings',
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Profile Section
                _buildProfileCard(context, colorScheme, textTheme),
                const SizedBox(height: 16),

                // Settings Sections
                _buildSettingsSection(
                  context,
                  title: 'Appearance',
                  items: [
                    _buildSettingsItem(
                      context,
                      icon: Icons.palette_outlined,
                      title: 'Theme',
                      subtitle: 'System',
                      onTap: () => _showThemeDialog(context),
                    ),
                    _buildSettingsItem(
                      context,
                      icon: Icons.text_fields,
                      title: 'Text Size',
                      subtitle: 'Medium',
                      onTap: () => _showTextSizeDialog(context),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _buildSettingsSection(
                  context,
                  title: 'Data & Privacy',
                  items: [
                    _buildSettingsItem(
                      context,
                      icon: Icons.backup_outlined,
                      title: 'Backup & Sync',
                      subtitle: 'Local storage only',
                      onTap: () => _showBackupDialog(context),
                    ),
                    _buildSettingsItem(
                      context,
                      icon: Icons.security_outlined,
                      title: 'Privacy',
                      subtitle: 'No data shared',
                      onTap: () => _showPrivacyDialog(context),
                    ),
                    _buildSettingsItem(
                      context,
                      icon: Icons.delete_outline,
                      title: 'Clear Data',
                      subtitle: 'Remove all local data',
                      onTap: () => _showClearDataDialog(context),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _buildSettingsSection(
                  context,
                  title: 'About',
                  items: [
                    _buildSettingsItem(
                      context,
                      icon: Icons.info_outline,
                      title: 'Version',
                      subtitle: '1.0.0',
                      onTap: null,
                    ),
                    _buildSettingsItem(
                      context,
                      icon: Icons.description_outlined,
                      title: 'Terms of Service',
                      subtitle: null,
                      onTap: () => _showTermsDialog(context),
                    ),
                    _buildSettingsItem(
                      context,
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      subtitle: null,
                      onTap: () => _showPrivacyPolicyDialog(context),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(
      BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primaryContainer,
              ),
              child: Icon(
                Icons.person_outline,
                size: 32,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Guest User',
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sign in to sync across devices',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton(
              onPressed: () => _showSignInDialog(context),
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required List<Widget> items,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: Icon(
        icon,
        color: colorScheme.onSurfaceVariant,
        size: 24,
      ),
      title: Text(
        title,
        style: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      trailing: onTap != null
          ? Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            )
          : null,
      onTap: onTap,
    );
  }

  // Dialog methods
  void _showSignInDialog(BuildContext context) {
    // TODO: Implement sign in dialog
  }

  void _showThemeDialog(BuildContext context) {
    // TODO: Implement theme selection dialog
  }

  void _showTextSizeDialog(BuildContext context) {
    // TODO: Implement text size dialog
  }

  void _showBackupDialog(BuildContext context) {
    // TODO: Implement backup dialog
  }

  void _showPrivacyDialog(BuildContext context) {
    // TODO: Implement privacy dialog
  }

  void _showClearDataDialog(BuildContext context) {
    // TODO: Implement clear data dialog
  }

  void _showTermsDialog(BuildContext context) {
    // TODO: Implement terms dialog
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    // TODO: Implement privacy policy dialog
  }
}

// Search delegate for ideas
class IdeaSearchDelegate extends SearchDelegate<String> {
  final WidgetRef ref;

  IdeaSearchDelegate(this.ref);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _sampleIdeas
        .where((idea) =>
            idea.text?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final idea = results[index];
        return IdeaCard(
          idea: idea,
          onTap: () {
            close(context, idea.text ?? '');
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}

// Context menu widgets
class IdeaContextMenu extends StatelessWidget {
  final Idea idea;

  const IdeaContextMenu({super.key, required this.idea});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class RoomContextMenu extends StatelessWidget {
  final Room room;

  const RoomContextMenu({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Room'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share Code'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Leave Room'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

// Dialog widgets
class CreateRoomDialog extends StatelessWidget {
  const CreateRoomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Room'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Room Name (optional)',
              hintText: 'Enter room name',
            ),
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'Password (optional)',
              hintText: 'Enter password',
            ),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Create'),
        ),
      ],
    );
  }
}

class JoinRoomDialog extends StatelessWidget {
  const JoinRoomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Join Room'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Room Code',
              hintText: 'Enter 6-digit code',
            ),
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'Password (if required)',
              hintText: 'Enter password',
            ),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Join'),
        ),
      ],
    );
  }
}
