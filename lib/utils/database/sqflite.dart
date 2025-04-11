import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import '../../ai_interview_prep/model.dart';

class DatabaseHelper {
  static const _databaseName = "data.db";
  static const _databaseVersion = 3;
  static const table = 'conversation_table';
  static const columnId = 'id';
  static const columnWord = 'word';
  static const columnSpeaker = 'speaker';
  static const columnGerman = 'german';
  static const columnEnglish = 'english';

  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }


  // Initialize the database
  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      // Web-specific initialization
      databaseFactory = databaseFactoryFfiWeb;
      String path = 'assets/$_databaseName';
      return await databaseFactory.openDatabase(path, options: OpenDatabaseOptions(
        version: _databaseVersion,
        onCreate: _onCreate,
      ));
    } else {
      // Android/iOS initialization
      var databasesPath = await getDatabasesPath();
      String path = '$databasesPath/$_databaseName';
      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
      );
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnWord TEXT NOT NULL,
        $columnSpeaker TEXT NOT NULL,
        $columnGerman TEXT NOT NULL,
        $columnEnglish TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE chat_sessions(
        session_id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        memory TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE vocabs(
        id INTEGER PRIMARY KEY,
        word TEXT NOT NULL,
        german_data TEXT NOT NULL,
        data_forms TEXT NOT NULL,
        example_sentences TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }
  // Insert a conversation entry into the database
  Future<void> insertConversation(
      String word, List<ConversationEntry> conversationEntries) async {
    final db = await database;
    Batch batch = db.batch();

    for (var entry in conversationEntries) {
      batch.insert(table, {
        columnWord: word,
        columnSpeaker: entry.speaker,
        columnGerman: entry.german,
        columnEnglish: entry.english,
      });
    }

    await batch.commit(noResult: true);
  }

  // Retrieve all conversations for a word
  Future<List<Map<String, dynamic>>> getConversations(String word) async {
    final db = await database;
    return await db.query(table, where: '$columnWord = ?', whereArgs: [word]);
  }

  // Insert or update chat session
  Future<void> upsertChatSession({
    required String sessionId,
    required String title,
    required String memory,
  }) async {
    final db = await database;

    // Check if session exists
    final existing = await db.query(
      'chat_sessions',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      limit: 1,
    );

    if (existing.isEmpty) {
      // Insert new session
      await db.insert(
        'chat_sessions',
        {
          'session_id': sessionId,
          'title': title,
          'memory': memory,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      // Update existing session
      await db.update(
        'chat_sessions',
        {
          'title': title,
          'memory': memory,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'session_id = ?',
        whereArgs: [sessionId],
      );
    }
  }

  // Get all chat sessions
  Future<List<Map<String, dynamic>>> getAllSessions() async {
    final db = await database;
    return await db.query('chat_sessions', orderBy: 'updated_at DESC');
  }

  // Get specific chat session
  Future<Map<String, dynamic>?> getSession(String sessionId) async {
    final db = await database;
    final results = await db.query(
      'chat_sessions',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      limit: 1,
    );

    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  // Delete chat session
  Future<void> deleteSession(String sessionId) async {
    final db = await database;
    await db.delete(
      'chat_sessions',
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );
  }




    // Insert a conversation entry into the database
  Future<void> insertVocabs(
      String word, dynamic result) async {
    final db = await database;
    Batch batch = db.batch();

      batch.insert("vocabs", {
        "word":word,
        "result":result,
        "created_at": DateTime.now().toIso8601String(),});
      await batch.commit(noResult: true);

    }

  

  // Insert or update chat session
  Future<void> updateVocabs({
    required String word,
    required dynamic germanData,
        required dynamic dataForms,
    required dynamic exampleSentences,

  }) async {
    final db = await database;

    final existing = await db.query(
      'vocabs',
      where: 'word = ?',
      whereArgs: [word],
      limit: 1,
    );

    if (existing.isEmpty) {
      // Insert new session
      await db.insert(
        'vocabs',
        {
          'word': word,
          'german_data': germanData.toString(),
          'data_forms': dataForms.toString(),
          'example_sentences': exampleSentences.toString(),
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      // Update existing session
      await db.update(
        'vocabs',
        {
          'german_data': germanData.toString(),
          'data_forms': dataForms.toString(),
          'example_sentences': exampleSentences.toString(),          
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'word = ?',
        whereArgs: [word],
      );
    }
  }

  // Get all chat sessions
  Future<List<Map<String, dynamic>>> getAllVocabs() async {
    final db = await database;
    return await db.query('vocabs', orderBy: 'updated_at DESC');
  }

  // Get specific chat session
  Future<Map<String, dynamic>?> getVocabs(String word) async {
    final db = await database;
    final results = await db.query(
      'vocabs',
      where: 'word = ?',
      whereArgs: [word],
      limit: 1,
    );

    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  // Delete chat session
  Future<void> deleteVocabs(String word) async {
    final db = await database;
    await db.delete(
      'vocabs',
      where: 'word = ?',
      whereArgs: [word],
    );
  }
}
