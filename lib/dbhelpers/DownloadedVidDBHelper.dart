import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../models/Downloaded_Video_Model.dart';

class DownloadedVidDatabaseHelper {

  static DownloadedVidDatabaseHelper? _databaseHelper;   // Singleton DatabaseHelper
  static Database? _database;                // Singleton Database

  String downloadlisttable = 'downloads_table';
  String colId = 'id';
  String colVideoTitle = 'videotitle';
  String colVideoThumbnailUrl = 'videothumbnailurl';
  String colChannelThumbnailurl = 'channelthumbnailurl';
  String colChannelTitle = 'channeltitle';
  String colChannelDescription = 'channeldescription';
  String colTaskId = 'taskid';
  String colFilePath = 'filepath';

  DownloadedVidDatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DownloadedVidDatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DownloadedVidDatabaseHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper!;
  }
  Future<Database?> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'downloadlist.db';

    // Open/create the database at a given path
    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $downloadlisttable($colId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$colVideoTitle TEXT, ''$colVideoThumbnailUrl TEXT, $colChannelThumbnailurl INTEGER,'
        ' $colChannelTitle TEXT, $colChannelDescription TEXT, $colTaskId TEXT'
        ', $colFilePath TEXT)');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getDownloadsMapList() async {
    Database? db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db!.query(downloadlisttable, orderBy: '$colId DESC');
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertDownload(DownloadedVideo downloadedVideo) async {
    Database? db = await this.database;
    var result = await db!.insert(downloadlisttable, downloadedVideo.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateDownload(DownloadedVideo downloadedVideo) async {
    var db = await this.database;
    var result = await db!.update(downloadlisttable, downloadedVideo.toMap(), where: '$colId = ?', whereArgs: [downloadedVideo.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteDownload(int id) async {
    var db = await this.database;
    int result = await db!.rawDelete('DELETE FROM $downloadlisttable WHERE $colId = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int?> getCount() async {
    Database? db = await this.database;
    List<Map<String, dynamic>> x = await db!.rawQuery('SELECT COUNT (*) from $downloadlisttable');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<DownloadedVideo>> getNoteList() async {

    var downloadsMapList = await getDownloadsMapList(); // Get 'Map List' from database
    int count = downloadsMapList.length;         // Count the number of map entries in db table
    List<DownloadedVideo> downloadsList = [];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      downloadsList.add(DownloadedVideo.fromMapObject(downloadsMapList[i]));
    }

    return downloadsList;
  }

}


