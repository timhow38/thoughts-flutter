class Idea {
  final String id;
  final String? text; // Text snippet
  final String? url; // Link/URL idea
  final String? imageUrl; // For pictures, only storing url
  final DateTime createdAt;
  final String? roomId; // If shared in room

  Idea({
    required this.id,
    this.text,
    this.url,
    this.imageUrl,
    required this.createdAt,
    this.roomId,
  });

// TODO: Add serialization/deserialization for local persistence (Hive/Isar/etc)
// TODO: Add helper functions for copy/update/merge for CRDT/collab logic.
}
