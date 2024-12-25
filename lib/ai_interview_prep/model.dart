class ConversationEntry {
  final String speaker;
  final String german;
  final String english;

  ConversationEntry({
    required this.speaker,
    required this.german,
    required this.english,
  });

  // Factory method for creating an instance from a JSON-like map
  factory ConversationEntry.fromJson(Map<String, dynamic> json) {
    return ConversationEntry(
      speaker: json['speaker'] ?? '',
      german: json['german'] ?? '',
      english: json['english'] ?? '',
    );
  }

  // Method to convert an instance to a JSON-like map
  Map<String, String> toJson() {
    return {
      'speaker': speaker,
      'german': german,
      'english': english,
    };
  }
}
