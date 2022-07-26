import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/Note.dart';

class DatabaseConnect{

  static final String tableName = "notes";
  Database? _database;

  Future<Database> get database async{

    final dbpath = await getDatabasesPath();

    const dbname = 'notes.db';

    final path = join(dbpath, dbname);
    
    _database = await openDatabase(path, version: 1, onCreate: _createDB);

    return _database!;
  }

  Future<void> _createDB(Database db, int version) async{

    await db.execute('''
       CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title VARCHAR,
        description TEXT, 
        date TEXT
        )
     '''
    );
  }

  Future<void> insertNote(Note note) async {
    final db = await database;
    await db.insert(
        tableName,
        note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteNote(Note note) async{
    final db = await database;

    await db.delete(
      tableName,
      where: 'id == ?',
      whereArgs: [note.id],
    );
  }

  Future<List<Note>> getNote() async{
    final db = await database;

    List<Map<String, dynamic>> items = await db.query(
      'note',
      orderBy: 'id DESC',
    );

    return List.generate(
        items.length,
            (i) => Note(
                id: items[i]['id'],
                title: items[i]['title'],
                description: items[i]['description'],
                date: items[i]['date']
            ),
    );
  }
}


