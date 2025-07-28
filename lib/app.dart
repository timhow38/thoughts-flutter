import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/capture/capture_page.dart';
import 'features/navigation/nav_bar.dart';
import 'features/ideas/idea_card.dart';
import 'features/rooms/room_card.dart';
import 'models/idea.dart';
import 'models/room.dart';

final _tabProvider = StateProvider<int>((ref) => 0);

// Sample data for demonstration
final List<Idea> _sampleIdeas = [
  Idea(
    id: '1',
    text: 'Create a new mobile app for idea sharing with real-time collaboration features.',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  Idea(
    id: '2',
    text: 'Design a minimalist UI with Material Design 3 principles for better user experience.',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Idea(
    id: '3',
    text: 'Implement offline-first architecture for better privacy and reliability.',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Idea(
    id: '4',
    text: 'Add support for different media types: text, images, videos, and audio recordings.',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
];

final List<Room> _sampleRooms = [
  Room(
    id: '1',
    code: 'ABC123',
    lastActive: DateTime.now().subtract(const Duration(hours: 1)),
  ),
  Room(
    id: '2',
    code: 'XYZ789',
    password: 'secret',
    lastActive: DateTime.now().subtract(const Duration(days: 1)),
  ),
];

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(_tabProvider);
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: const [
          CapturePage(),
          IdeasListScreenM3(),
          RoomsScreenM3(),
          SettingsScreenM3(),
        ],
      ),
      bottomNavigationBar: NavBar(
        currentIndex: index,
        onTap: (idx) => ref.read(_tabProvider.notifier).state = idx,
      ),
      // Floating Action Button for quick capture
      floatingActionButton: index == 1 || index == 2 ? FloatingActionButton(
        onPressed: () {
          // Navigate to capture page
          ref.read(_tabProvider.notifier).state = 0;
        },
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        child: Icon(Icons.add),
      ) : null,
    );
  }
}

class IdeasListScreenM3 extends StatelessWidget {
  const IdeasListScreenM3();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('My Ideas'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter functionality
            },
          ),
        ],
      ),
      body: _sampleIdeas.isEmpty
          ? _buildEmptyState(context, colorScheme, textTheme)
          : _buildIdeasList(context),
    );
  }
  
  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Material Design 3 expressive container
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
              'Start capturing your thoughts and ideas using the capture page.',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                // TODO: Navigate to capture page
              },
              icon: Icon(Icons.add),
              label: Text('Capture Your First Idea'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildIdeasList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _sampleIdeas.length,
      itemBuilder: (context, index) {
        final idea = _sampleIdeas[index];
        return IdeaCard(
          idea: idea,
          onTap: () {
            // TODO: Navigate to idea detail
          },
          onLongPress: () {
            // TODO: Show context menu
          },
        );
      },
    );
  }
}

class RoomsScreenM3 extends StatelessWidget {
  const RoomsScreenM3();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Rooms'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // TODO: Create new room
            },
          ),
        ],
      ),
      body: _sampleRooms.isEmpty
          ? _buildEmptyState(context, colorScheme, textTheme)
          : _buildRoomsList(context),
    );
  }
  
  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Material Design 3 expressive container
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
              'Create a room to share ideas with friends in real-time.',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                // TODO: Create new room
              },
              icon: Icon(Icons.add),
              label: Text('Create Room'),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Join room
              },
              icon: Icon(Icons.login),
              label: Text('Join Room'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRoomsList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _sampleRooms.length,
      itemBuilder: (context, index) {
        final room = _sampleRooms[index];
        return RoomCard(
          room: room,
          onTap: () {
            // TODO: Navigate to room
          },
          onLongPress: () {
            // TODO: Show context menu
          },
        );
      },
    );
  }
}

class SettingsScreenM3 extends StatelessWidget {
  const SettingsScreenM3();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios, size: 16),
                    onPressed: () {
                      // TODO: Navigate to sign in
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Settings Sections
          _buildSettingsSection(
            context,
            title: 'Appearance',
            items: [
              _buildSettingsItem(
                context,
                icon: Icons.dark_mode,
                title: 'Theme',
                subtitle: 'System',
                onTap: () {
                  // TODO: Theme settings
                },
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
                icon: Icons.backup,
                title: 'Backup & Sync',
                subtitle: 'Local storage only',
                onTap: () {
                  // TODO: Backup settings
                },
              ),
              _buildSettingsItem(
                context,
                icon: Icons.security,
                title: 'Privacy',
                subtitle: 'No data shared',
                onTap: () {
                  // TODO: Privacy settings
                },
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
                onTap: () {
                  // TODO: Show terms
                },
              ),
              _buildSettingsItem(
                context,
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                subtitle: null,
                onTap: () {
                  // TODO: Show privacy policy
                },
              ),
            ],
          ),
        ],
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
}
