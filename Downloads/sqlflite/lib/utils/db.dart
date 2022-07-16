import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'model.dart';

class MyDb {
// craete, edit, delete, get

  MyDb._();
  static final MyDb db = MyDb._();

  static Database? _database;

  Future<Database> get database async {
    return _database ??= await init();
  }

  Future<Database> init() async {
    return await openDatabase(join(await getDatabasesPath(), 'theNote.db'),
        onCreate: (db, version) {
      db.execute("""
          CREATE TABLE thenote(id INTEGER PRIMARY KEY AUTOINCREMENT, content TEXT , category TEXT, date DATE)
        """);
    }, version: 1);
  }

// Note(ca: dat)

  createData(Note note) async {
    var db = await database;
    await db.insert("thenote", note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  getData() async {
    var db = await database;
    var theInfo = await db.query('thenote');
    if (theInfo.isEmpty) {
      return null;
    } else {
      return theInfo;
    }

    // await db.rawQuery("SELECT * FROM thenote");
  }

  editData(Note note, int id) async {
    var db = await database;
    await db.update('thenote', note.toMap(), where: 'id = ?', whereArgs: [id]);
  }

  deleteData(int id) async {
    var db = await database;
    await db.delete('thenote', where: 'id = ?', whereArgs: [id]);
  }
}

//  s =''
