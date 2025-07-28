import 'package:flutter/foundation.dart';

/// Represents a collaborative room with real-time synchronization
/// Following Material Design 3 patterns and CRDT architecture
@immutable
class Room {
  final String id;
  final String code; // 6-digit alphanumeric code for easy sharing
  final String? name; // Optional display name
  final String? description; // Room description
  final String? password; // Optional password protection
  final DateTime createdAt;
  final DateTime lastActive;
  final String? ownerId; // Creator of the room
  final List<String> memberIds; // Active members
  final int maxMembers; // Member limit
  final bool isPublic; // Public discovery
  final bool isArchived; // Soft deletion
  final RoomSettings settings; // Collaboration settings
  final Map<String, dynamic>? metadata; // Extensible properties

  const Room({
    required this.id,
    required this.code,
    this.name,
    this.description,
    this.password,
    required this.createdAt,
    required this.lastActive,
    this.ownerId,
    this.memberIds = const [],
    this.maxMembers = 10,
    this.isPublic = false,
    this.isArchived = false,
    this.settings = const RoomSettings(),
    this.metadata,
  });

  /// Creates a copy with updated fields
  Room copyWith({
    String? id,
    String? code,
    String? name,
    String? description,
    String? password,
    DateTime? createdAt,
    DateTime? lastActive,
    String? ownerId,
    List<String>? memberIds,
    int? maxMembers,
    bool? isPublic,
    bool? isArchived,
    RoomSettings? settings,
    Map<String, dynamic>? metadata,
  }) {
    return Room(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      ownerId: ownerId ?? this.ownerId,
      memberIds: memberIds ?? this.memberIds,
      maxMembers: maxMembers ?? this.maxMembers,
      isPublic: isPublic ?? this.isPublic,
      isArchived: isArchived ?? this.isArchived,
      settings: settings ?? this.settings,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Display name with fallback to code
  String get displayName => name ?? 'Room $code';

  /// Check if room is password protected
  bool get isPasswordProtected => password != null && password!.isNotEmpty;

  /// Check if room is full
  bool get isFull => memberIds.length >= maxMembers;

  /// Get member count
  int get memberCount => memberIds.length;

  /// Check if user is owner
  bool isOwner(String userId) => ownerId == userId;

  /// Check if user is member
  bool isMember(String userId) => memberIds.contains(userId);

  /// Generate a new room code (6-digit alphanumeric)
  static String generateCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    var code = '';
    var seed = random;

    for (int i = 0; i < 6; i++) {
      seed = (seed * 1103515245 + 12345) & 0x7fffffff;
      code += chars[seed % chars.length];
    }

    return code;
  }

  /// Validate room code format
  static bool isValidCode(String code) {
    return RegExp(r'^[A-Z0-9]{6}$').hasMatch(code);
  }

  /// Serialization for local persistence and network sync
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
      'ownerId': ownerId,
      'memberIds': memberIds,
      'maxMembers': maxMembers,
      'isPublic': isPublic,
      'isArchived': isArchived,
      'settings': settings.toJson(),
      'metadata': metadata,
    };
  }

  /// Deserialization from storage/network
  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
      password: json['password'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActive: DateTime.parse(json['lastActive'] as String),
      ownerId: json['ownerId'] as String?,
      memberIds: List<String>.from(json['memberIds'] as List? ?? []),
      maxMembers: json['maxMembers'] as int? ?? 10,
      isPublic: json['isPublic'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      settings: RoomSettings.fromJson(
          json['settings'] as Map<String, dynamic>? ?? {}),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Room && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Room(id: $id, code: $code, name: $displayName, members: $memberCount)';
}

/// Room collaboration settings
@immutable
class RoomSettings {
  final bool allowGuestAccess; // Allow non-registered users
  final bool requireApproval; // Require owner approval to join
  final bool allowMediaSharing; // Enable media uploads
  final bool enableNotifications; // Push notifications
  final int messageRetentionDays; // Auto-delete old messages
  final bool enableEncryption; // End-to-end encryption

  const RoomSettings({
    this.allowGuestAccess = true,
    this.requireApproval = false,
    this.allowMediaSharing = true,
    this.enableNotifications = true,
    this.messageRetentionDays = 30,
    this.enableEncryption = false,
  });

  RoomSettings copyWith({
    bool? allowGuestAccess,
    bool? requireApproval,
    bool? allowMediaSharing,
    bool? enableNotifications,
    int? messageRetentionDays,
    bool? enableEncryption,
  }) {
    return RoomSettings(
      allowGuestAccess: allowGuestAccess ?? this.allowGuestAccess,
      requireApproval: requireApproval ?? this.requireApproval,
      allowMediaSharing: allowMediaSharing ?? this.allowMediaSharing,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      messageRetentionDays: messageRetentionDays ?? this.messageRetentionDays,
      enableEncryption: enableEncryption ?? this.enableEncryption,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allowGuestAccess': allowGuestAccess,
      'requireApproval': requireApproval,
      'allowMediaSharing': allowMediaSharing,
      'enableNotifications': enableNotifications,
      'messageRetentionDays': messageRetentionDays,
      'enableEncryption': enableEncryption,
    };
  }

  factory RoomSettings.fromJson(Map<String, dynamic> json) {
    return RoomSettings(
      allowGuestAccess: json['allowGuestAccess'] as bool? ?? true,
      requireApproval: json['requireApproval'] as bool? ?? false,
      allowMediaSharing: json['allowMediaSharing'] as bool? ?? true,
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      messageRetentionDays: json['messageRetentionDays'] as int? ?? 30,
      enableEncryption: json['enableEncryption'] as bool? ?? false,
    );
  }
}
