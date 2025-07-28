class Room {
  final String id;
  final String code; // TODO: Logic for generating and validating codes not implemented yet
  final String? password; // For room privacy, can be null
  final DateTime lastActive;

  // TODO: Add members list if account/membership is implemented

  Room({
    required this.id,
    required this.code,
    this.password,
    required this.lastActive,
  });

// TODO: Add serialization/deserialization, CRDT state, etc.
}
