import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/SavedVideos.dart';

class SavedVideosDatabaseHelper {
  static final _databaseName = 'saved_videos.db';
  static final _databaseVersion = 1;

  static final table = 'saved_videos';

  static final columnId = 'id';
  static final columnCaption = 'caption';
  static final columnPostType = 'postType';
  static final columnHeight = 'height';
  static final columnWidth = 'width';
  static final columnMediaType = 'mediaType';
  static final columnThumbnail = 'thumbnail';
  static final columnUrl = 'url';
  static final columnFileLocationPath = 'fileLocationPath';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnCaption TEXT NOT NULL,
        $columnPostType TEXT NOT NULL,
        $columnHeight INTEGER NOT NULL,
        $columnWidth INTEGER NOT NULL,
        $columnMediaType TEXT NOT NULL,
        $columnThumbnail TEXT NOT NULL,
        $columnUrl TEXT NOT NULL,
        $columnFileLocationPath TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertVideo(SavedVideos video) async {
    final db = await database;
    await db.insert(
      table,
      video.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SavedVideos>> getAllVideos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return SavedVideos(
        id: maps[i][columnId],
        caption: maps[i][columnCaption],
        postType: maps[i][columnPostType],
        height: maps[i][columnHeight],
        width: maps[i][columnWidth],
        mediaType: maps[i][columnMediaType],
        thumbnail: maps[i][columnThumbnail],
        url: maps[i][columnUrl],
        fileLocationPath: maps[i][columnFileLocationPath],
      );
    });
  }
}