import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import '../models/idea.dart';
import '../models/room.dart';

/// Secure local storage service with AES encryption
/// Handles both personal ideas and room ideas with proper encryption
class StorageService {
  static const String _keyAlias = 'ideas_encryption_key';
  static const String _personalIdeasFile = 'personal_ideas.enc';
  static const String _roomIdeasFile = 'room_ideas.enc';
  static const String _roomsFile = 'rooms.enc';

  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_PKCS1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  late final encrypt.Encrypter _encrypter;
  late final encrypt.IV _iv;
  bool _initialized = false;

  /// Initialize the storage service with encryption
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Get or generate encryption key
      String? keyString = await _secureStorage.read(key: _keyAlias);

      if (keyString == null) {
        // Generate new 256-bit key
        final key = encrypt.Key.fromSecureRandom(32);
        keyString = key.base64;
        await _secureStorage.write(key: _keyAlias, value: keyString);
      }

      final key = encrypt.Key.fromBase64(keyString);
      _encrypter = encrypt.Encrypter(encrypt.AES(key));
      _iv = encrypt.IV
          .fromSecureRandom(16); // Generate random IV for each operation

      _initialized = true;
    } catch (e) {
      throw StorageException('Failed to initialize encryption: $e');
    }
  }

  /// Get application documents directory
  Future<Directory> get _documentsDirectory async {
    return await getApplicationDocumentsDirectory();
  }

  /// Encrypt and save data to file
  Future<void> _saveEncryptedData(
      String filename, Map<String, dynamic> data) async {
    await initialize();

    try {
      final dir = await _documentsDirectory;
      final file = File('${dir.path}/$filename');

      final jsonString = jsonEncode(data);
      final iv = encrypt.IV.fromSecureRandom(16); // New IV for each save
      final encrypted = _encrypter.encrypt(jsonString, iv: iv);

      // Combine IV and encrypted data
      final combined = iv.bytes + encrypted.bytes;
      await file.writeAsBytes(combined);

      if (kDebugMode) {
        print('✅ Saved encrypted data to $filename');
      }
    } catch (e) {
      throw StorageException('Failed to save encrypted data: $e');
    }
  }

  /// Load and decrypt data from file
  Future<Map<String, dynamic>?> _loadEncryptedData(String filename) async {
    await initialize();

    try {
      final dir = await _documentsDirectory;
      final file = File('${dir.path}/$filename');

      if (!await file.exists()) {
        return null;
      }

      final combined = await file.readAsBytes();

      if (combined.length < 16) {
        throw StorageException('Invalid encrypted file format');
      }

      // Extract IV and encrypted data
      final iv = encrypt.IV(Uint8List.fromList(combined.take(16).toList()));
      final encryptedBytes = combined.skip(16).toList();
      final encrypted = encrypt.Encrypted(Uint8List.fromList(encryptedBytes));

      final decrypted = _encrypter.decrypt(encrypted, iv: iv);
      return jsonDecode(decrypted) as Map<String, dynamic>;
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to load encrypted data from $filename: $e');
      }
      return null;
    }
  }

  /// Save personal ideas
  Future<void> savePersonalIdeas(List<Idea> ideas) async {
    final data = {
      'ideas': ideas.map((idea) => idea.toJson()).toList(),
      'lastUpdated': DateTime.now().toIso8601String(),
      'version': 1,
    };

    await _saveEncryptedData(_personalIdeasFile, data);
  }

  /// Load personal ideas
  Future<List<Idea>> loadPersonalIdeas() async {
    final data = await _loadEncryptedData(_personalIdeasFile);

    if (data == null) return [];

    try {
      final ideasJson = data['ideas'] as List<dynamic>? ?? [];
      return ideasJson
          .map((json) => Idea.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to parse personal ideas: $e');
      }
      return [];
    }
  }

  /// Save room ideas (grouped by room)
  Future<void> saveRoomIdeas(Map<String, List<Idea>> roomIdeas) async {
    final data = {
      'roomIdeas': roomIdeas.map((roomId, ideas) => MapEntry(
            roomId,
            ideas.map((idea) => idea.toJson()).toList(),
          )),
      'lastUpdated': DateTime.now().toIso8601String(),
      'version': 1,
    };

    await _saveEncryptedData(_roomIdeasFile, data);
  }

  /// Load room ideas
  Future<Map<String, List<Idea>>> loadRoomIdeas() async {
    final data = await _loadEncryptedData(_roomIdeasFile);

    if (data == null) return {};

    try {
      final roomIdeasJson = data['roomIdeas'] as Map<String, dynamic>? ?? {};
      return roomIdeasJson.map((roomId, ideasJson) {
        final ideas = (ideasJson as List<dynamic>)
            .map((json) => Idea.fromJson(json as Map<String, dynamic>))
            .toList();
        return MapEntry(roomId, ideas);
      });
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to parse room ideas: $e');
      }
      return {};
    }
  }

  /// Save rooms
  Future<void> saveRooms(List<Room> rooms) async {
    final data = {
      'rooms': rooms.map((room) => room.toJson()).toList(),
      'lastUpdated': DateTime.now().toIso8601String(),
      'version': 1,
    };

    await _saveEncryptedData(_roomsFile, data);
  }

  /// Load rooms
  Future<List<Room>> loadRooms() async {
    final data = await _loadEncryptedData(_roomsFile);

    if (data == null) return [];

    try {
      final roomsJson = data['rooms'] as List<dynamic>? ?? [];
      return roomsJson
          .map((json) => Room.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to parse rooms: $e');
      }
      return [];
    }
  }

  /// Add a new personal idea
  Future<void> addPersonalIdea(Idea idea) async {
    final ideas = await loadPersonalIdeas();
    ideas.add(idea);
    await savePersonalIdeas(ideas);
  }

  /// Add a new room idea
  Future<void> addRoomIdea(String roomId, Idea idea) async {
    final roomIdeas = await loadRoomIdeas();
    roomIdeas[roomId] = [...(roomIdeas[roomId] ?? []), idea];
    await saveRoomIdeas(roomIdeas);
  }

  /// Update an existing idea
  Future<void> updateIdea(Idea updatedIdea) async {
    if (updatedIdea.roomId != null) {
      // Update room idea
      final roomIdeas = await loadRoomIdeas();
      final roomId = updatedIdea.roomId!;
      final ideas = roomIdeas[roomId] ?? [];

      final index = ideas.indexWhere((idea) => idea.id == updatedIdea.id);
      if (index != -1) {
        ideas[index] = updatedIdea;
        roomIdeas[roomId] = ideas;
        await saveRoomIdeas(roomIdeas);
      }
    } else {
      // Update personal idea
      final ideas = await loadPersonalIdeas();
      final index = ideas.indexWhere((idea) => idea.id == updatedIdea.id);
      if (index != -1) {
        ideas[index] = updatedIdea;
        await savePersonalIdeas(ideas);
      }
    }
  }

  /// Delete an idea
  Future<void> deleteIdea(String ideaId, {String? roomId}) async {
    if (roomId != null) {
      // Delete room idea
      final roomIdeas = await loadRoomIdeas();
      final ideas = roomIdeas[roomId] ?? [];
      ideas.removeWhere((idea) => idea.id == ideaId);
      roomIdeas[roomId] = ideas;
      await saveRoomIdeas(roomIdeas);
    } else {
      // Delete personal idea
      final ideas = await loadPersonalIdeas();
      ideas.removeWhere((idea) => idea.id == ideaId);
      await savePersonalIdeas(ideas);
    }
  }

  /// Get ideas for a specific room
  Future<List<Idea>> getIdeasForRoom(String roomId) async {
    final roomIdeas = await loadRoomIdeas();
    return roomIdeas[roomId] ?? [];
  }

  /// Search ideas by text content
  Future<List<Idea>> searchIdeas(String query, {String? roomId}) async {
    final lowercaseQuery = query.toLowerCase();

    if (roomId != null) {
      final ideas = await getIdeasForRoom(roomId);
      return ideas
          .where((idea) =>
              idea.displayText.toLowerCase().contains(lowercaseQuery) ||
              idea.tags
                  .any((tag) => tag.toLowerCase().contains(lowercaseQuery)))
          .toList();
    } else {
      final personalIdeas = await loadPersonalIdeas();
      return personalIdeas
          .where((idea) =>
              idea.displayText.toLowerCase().contains(lowercaseQuery) ||
              idea.tags
                  .any((tag) => tag.toLowerCase().contains(lowercaseQuery)))
          .toList();
    }
  }

  /// Clear all data (for logout/reset)
  Future<void> clearAllData() async {
    try {
      final dir = await _documentsDirectory;

      final files = [_personalIdeasFile, _roomIdeasFile, _roomsFile];
      for (final filename in files) {
        final file = File('${dir.path}/$filename');
        if (await file.exists()) {
          await file.delete();
        }
      }

      // Optionally clear the encryption key (user would need to re-setup)
      // await _secureStorage.delete(key: _keyAlias);

      if (kDebugMode) {
        print('✅ Cleared all local data');
      }
    } catch (e) {
      throw StorageException('Failed to clear data: $e');
    }
  }

  /// Get storage statistics
  Future<StorageStats> getStorageStats() async {
    final personalIdeas = await loadPersonalIdeas();
    final roomIdeas = await loadRoomIdeas();
    final rooms = await loadRooms();

    int totalRoomIdeas = 0;
    for (final ideas in roomIdeas.values) {
      totalRoomIdeas += ideas.length;
    }

    return StorageStats(
      personalIdeasCount: personalIdeas.length,
      roomIdeasCount: totalRoomIdeas,
      roomsCount: rooms.length,
      totalIdeasCount: personalIdeas.length + totalRoomIdeas,
    );
  }
}

/// Storage statistics
class StorageStats {
  final int personalIdeasCount;
  final int roomIdeasCount;
  final int roomsCount;
  final int totalIdeasCount;

  const StorageStats({
    required this.personalIdeasCount,
    required this.roomIdeasCount,
    required this.roomsCount,
    required this.totalIdeasCount,
  });
}

/// Custom exception for storage operations
class StorageException implements Exception {
  final String message;
  const StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}
