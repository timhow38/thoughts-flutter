import 'package:flutter/foundation.dart';

/// Represents an idea with comprehensive metadata and media support
/// Following Material Design 3 data patterns and offline-first architecture
@immutable
class Idea {
  final String id;
  final String? text; // Text content with rich formatting support
  final String? url; // Link/URL with metadata extraction
  final String? imageUrl; // Image with compression and caching
  final String? audioUrl; // Audio recordings with transcription
  final String? videoUrl; // Video content with thumbnails
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? roomId; // Shared room reference
  final List<String> tags; // Categorization and filtering
  final String? category; // Primary category
  final bool isPinned; // User prioritization
  final bool isArchived; // Soft deletion
  final Map<String, dynamic>? metadata; // Extensible properties

  const Idea({
    required this.id,
    this.text,
    this.url,
    this.imageUrl,
    this.audioUrl,
    this.videoUrl,
    required this.createdAt,
    this.updatedAt,
    this.roomId,
    this.tags = const [],
    this.category,
    this.isPinned = false,
    this.isArchived = false,
    this.metadata,
  });

  /// Creates a copy with updated fields
  Idea copyWith({
    String? id,
    String? text,
    String? url,
    String? imageUrl,
    String? audioUrl,
    String? videoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? roomId,
    List<String>? tags,
    String? category,
    bool? isPinned,
    bool? isArchived,
    Map<String, dynamic>? metadata,
  }) {
    return Idea(
      id: id ?? this.id,
      text: text ?? this.text,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      roomId: roomId ?? this.roomId,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Determines the primary content type for UI rendering
  IdeaType get type {
    if (videoUrl != null) return IdeaType.video;
    if (audioUrl != null) return IdeaType.audio;
    if (imageUrl != null) return IdeaType.image;
    if (url != null) return IdeaType.link;
    return IdeaType.text;
  }

  /// Checks if idea has any media content
  bool get hasMedia => imageUrl != null || audioUrl != null || videoUrl != null;

  /// Gets display text with fallback
  String get displayText => text ?? url ?? 'Untitled idea';

  /// Serialization for local persistence (Hive/Isar)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'url': url,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'videoUrl': videoUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'roomId': roomId,
      'tags': tags,
      'category': category,
      'isPinned': isPinned,
      'isArchived': isArchived,
      'metadata': metadata,
    };
  }

  /// Deserialization from local storage
  factory Idea.fromJson(Map<String, dynamic> json) {
    return Idea(
      id: json['id'] as String,
      text: json['text'] as String?,
      url: json['url'] as String?,
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      roomId: json['roomId'] as String?,
      tags: List<String>.from(json['tags'] as List? ?? []),
      category: json['category'] as String?,
      isPinned: json['isPinned'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Idea && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Idea(id: $id, type: $type, text: ${text?.substring(0, text!.length > 50 ? 50 : text!.length)}...)';
}

/// Enumeration of idea content types for UI rendering
enum IdeaType {
  text,
  image,
  audio,
  video,
  link,
}
