import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/idea.dart';
import '../services/storage_service.dart';
import '../features/capture/widgets/type_selector.dart';

/// Repository for managing ideas with local storage and room synchronization
class IdeasRepository {
  final StorageService _storageService;

  IdeasRepository(this._storageService);

  /// Create a new idea from capture data
  Future<Idea> createIdea({
    required CaptureType type,
    String? title,
    String? content,
    String? url,
    String? imageUrl,
    String? audioUrl,
    String? videoUrl,
    String? roomId,
    List<String> tags = const [],
    String? category,
  }) async {
    final now = DateTime.now();
    final idea = Idea(
      id: const Uuid().v4(),
      text: _buildTextContent(type, title, content),
      url: type == CaptureType.link ? (url ?? content) : null,
      imageUrl: type == CaptureType.image ? imageUrl : null,
      audioUrl: type == CaptureType.audio ? audioUrl : null,
      videoUrl: type == CaptureType.video ? videoUrl : null,
      createdAt: now,
      roomId: roomId,
      tags: tags,
      category: category,
    );

    // Save locally
    if (roomId != null) {
      await _storageService.addRoomIdea(roomId, idea);
    } else {
      await _storageService.addPersonalIdea(idea);
    }

    // TODO: If room idea, also send to room members via WebSocket/API
    if (roomId != null) {
      await _syncIdeaToRoom(idea);
    }

    return idea;
  }

  /// Build text content based on capture type
  String? _buildTextContent(CaptureType type, String? title, String? content) {
    if (type == CaptureType.link) return null; // Links use url field

    final parts = <String>[];
    if (title?.isNotEmpty == true) parts.add(title!);
    if (content?.isNotEmpty == true) parts.add(content!);

    return parts.isEmpty ? null : parts.join('\n\n');
  }

  /// Get personal ideas
  Future<List<Idea>> getPersonalIdeas() async {
    return await _storageService.loadPersonalIdeas();
  }

  /// Get ideas for a specific room
  Future<List<Idea>> getRoomIdeas(String roomId) async {
    return await _storageService.getIdeasForRoom(roomId);
  }

  /// Get all ideas (personal + room ideas)
  Future<List<Idea>> getAllIdeas() async {
    final personal = await _storageService.loadPersonalIdeas();
    final roomIdeas = await _storageService.loadRoomIdeas();

    final allRoomIdeas = <Idea>[];
    for (final ideas in roomIdeas.values) {
      allRoomIdeas.addAll(ideas);
    }

    return [...personal, ...allRoomIdeas];
  }

  /// Update an existing idea
  Future<void> updateIdea(Idea idea) async {
    final updatedIdea = idea.copyWith(updatedAt: DateTime.now());
    await _storageService.updateIdea(updatedIdea);

    // TODO: If room idea, sync changes to room members
    if (idea.roomId != null) {
      await _syncIdeaToRoom(updatedIdea);
    }
  }

  /// Delete an idea
  Future<void> deleteIdea(String ideaId, {String? roomId}) async {
    await _storageService.deleteIdea(ideaId, roomId: roomId);

    // TODO: If room idea, notify room members of deletion
    if (roomId != null) {
      await _syncIdeaDeletion(ideaId, roomId);
    }
  }

  /// Toggle idea pin status
  Future<void> togglePin(Idea idea) async {
    final updated = idea.copyWith(
      isPinned: !idea.isPinned,
      updatedAt: DateTime.now(),
    );
    await updateIdea(updated);
  }

  /// Archive/unarchive an idea
  Future<void> toggleArchive(Idea idea) async {
    final updated = idea.copyWith(
      isArchived: !idea.isArchived,
      updatedAt: DateTime.now(),
    );
    await updateIdea(updated);
  }

  /// Add tags to an idea
  Future<void> addTags(Idea idea, List<String> newTags) async {
    final uniqueTags = {...idea.tags, ...newTags}.toList();
    final updated = idea.copyWith(
      tags: uniqueTags,
      updatedAt: DateTime.now(),
    );
    await updateIdea(updated);
  }

  /// Remove tags from an idea
  Future<void> removeTags(Idea idea, List<String> tagsToRemove) async {
    final updatedTags =
        idea.tags.where((tag) => !tagsToRemove.contains(tag)).toList();
    final updated = idea.copyWith(
      tags: updatedTags,
      updatedAt: DateTime.now(),
    );
    await updateIdea(updated);
  }

  /// Set idea category
  Future<void> setCategory(Idea idea, String? category) async {
    final updated = idea.copyWith(
      category: category,
      updatedAt: DateTime.now(),
    );
    await updateIdea(updated);
  }

  /// Search ideas
  Future<List<Idea>> searchIdeas(String query, {String? roomId}) async {
    return await _storageService.searchIdeas(query, roomId: roomId);
  }

  /// Get ideas by type
  Future<List<Idea>> getIdeasByType(IdeaType type, {String? roomId}) async {
    final ideas =
        roomId != null ? await getRoomIdeas(roomId) : await getPersonalIdeas();

    return ideas.where((idea) => idea.type == type).toList();
  }

  /// Get ideas by category
  Future<List<Idea>> getIdeasByCategory(String category,
      {String? roomId}) async {
    final ideas =
        roomId != null ? await getRoomIdeas(roomId) : await getPersonalIdeas();

    return ideas.where((idea) => idea.category == category).toList();
  }

  /// Get ideas by tags
  Future<List<Idea>> getIdeasByTags(List<String> tags, {String? roomId}) async {
    final ideas =
        roomId != null ? await getRoomIdeas(roomId) : await getPersonalIdeas();

    return ideas
        .where((idea) => tags.any((tag) => idea.tags.contains(tag)))
        .toList();
  }

  /// Get recent ideas (last 7 days)
  Future<List<Idea>> getRecentIdeas({String? roomId, int days = 7}) async {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final ideas =
        roomId != null ? await getRoomIdeas(roomId) : await getPersonalIdeas();

    return ideas.where((idea) => idea.createdAt.isAfter(cutoff)).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get pinned ideas
  Future<List<Idea>> getPinnedIdeas({String? roomId}) async {
    final ideas =
        roomId != null ? await getRoomIdeas(roomId) : await getPersonalIdeas();

    return ideas.where((idea) => idea.isPinned && !idea.isArchived).toList();
  }

  /// Get all unique tags
  Future<List<String>> getAllTags({String? roomId}) async {
    final ideas =
        roomId != null ? await getRoomIdeas(roomId) : await getPersonalIdeas();

    final allTags = <String>{};
    for (final idea in ideas) {
      allTags.addAll(idea.tags);
    }

    return allTags.toList()..sort();
  }

  /// Get all unique categories
  Future<List<String>> getAllCategories({String? roomId}) async {
    final ideas =
        roomId != null ? await getRoomIdeas(roomId) : await getPersonalIdeas();

    final categories = ideas
        .where((idea) => idea.category != null)
        .map((idea) => idea.category!)
        .toSet()
        .toList();

    return categories..sort();
  }

  /// Sync idea to room members (placeholder for real-time sync)
  Future<void> _syncIdeaToRoom(Idea idea) async {
    // TODO: Implement WebSocket/API call to sync idea to room members
    // This would typically involve:
    // 1. Send idea to server/room channel
    // 2. Server broadcasts to all room members
    // 3. Other clients receive and store locally

    // For now, just log the sync operation
    print('🔄 Syncing idea ${idea.id} to room ${idea.roomId}');
  }

  /// Sync idea deletion to room members
  Future<void> _syncIdeaDeletion(String ideaId, String roomId) async {
    // TODO: Implement deletion sync
    print('🗑️ Syncing deletion of idea $ideaId from room $roomId');
  }

  /// Handle incoming room idea from other members
  Future<void> handleIncomingRoomIdea(Idea idea) async {
    if (idea.roomId == null) return;

    // Check if we already have this idea
    final existingIdeas = await getRoomIdeas(idea.roomId!);
    final exists = existingIdeas.any((existing) => existing.id == idea.id);

    if (!exists) {
      await _storageService.addRoomIdea(idea.roomId!, idea);
    } else {
      // Update existing idea if this version is newer
      final existing = existingIdeas.firstWhere((e) => e.id == idea.id);
      if (idea.updatedAt != null &&
          (existing.updatedAt == null ||
              idea.updatedAt!.isAfter(existing.updatedAt!))) {
        await _storageService.updateIdea(idea);
      }
    }
  }

  /// Export ideas to JSON (for backup/sharing)
  Future<Map<String, dynamic>> exportIdeas({String? roomId}) async {
    final ideas =
        roomId != null ? await getRoomIdeas(roomId) : await getPersonalIdeas();

    return {
      'ideas': ideas.map((idea) => idea.toJson()).toList(),
      'exportedAt': DateTime.now().toIso8601String(),
      'roomId': roomId,
      'version': 1,
    };
  }

  /// Import ideas from JSON
  Future<void> importIdeas(Map<String, dynamic> data, {String? roomId}) async {
    final ideasJson = data['ideas'] as List<dynamic>? ?? [];
    final ideas = ideasJson
        .map((json) => Idea.fromJson(json as Map<String, dynamic>))
        .toList();

    for (final idea in ideas) {
      final ideaWithRoom = roomId != null
          ? idea.copyWith(roomId: roomId)
          : idea.copyWith(roomId: null);

      if (roomId != null) {
        await _storageService.addRoomIdea(roomId, ideaWithRoom);
      } else {
        await _storageService.addPersonalIdea(ideaWithRoom);
      }
    }
  }
}

/// Riverpod providers for ideas repository
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final ideasRepositoryProvider = Provider<IdeasRepository>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return IdeasRepository(storageService);
});

/// Provider for personal ideas
final personalIdeasProvider = FutureProvider<List<Idea>>((ref) async {
  final repository = ref.watch(ideasRepositoryProvider);
  return await repository.getPersonalIdeas();
});

/// Provider for room ideas
final roomIdeasProvider =
    FutureProvider.family<List<Idea>, String>((ref, roomId) async {
  final repository = ref.watch(ideasRepositoryProvider);
  return await repository.getRoomIdeas(roomId);
});

/// Provider for all ideas
final allIdeasProvider = FutureProvider<List<Idea>>((ref) async {
  final repository = ref.watch(ideasRepositoryProvider);
  return await repository.getAllIdeas();
});

/// Provider for recent ideas
final recentIdeasProvider =
    FutureProvider.family<List<Idea>, String?>((ref, roomId) async {
  final repository = ref.watch(ideasRepositoryProvider);
  return await repository.getRecentIdeas(roomId: roomId);
});

/// Provider for pinned ideas
final pinnedIdeasProvider =
    FutureProvider.family<List<Idea>, String?>((ref, roomId) async {
  final repository = ref.watch(ideasRepositoryProvider);
  return await repository.getPinnedIdeas(roomId: roomId);
});
