import 'package:app9_notas_diarias/model/Note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesHelper {

  static final String tableName = "notes";
  static final NotesHelper _notesHelper = NotesHelper._internal();
  static Database? _db;

  factory NotesHelper(){
    return _notesHelper;
  }

  NotesHelper._internal(){
  }

  get db async {

    if( _db != null ){
      return _db;
    }else{
      _db = await initiateDB();
      return _db;
    }

  }

  _onCreate(Database db, int version) async {

    String sql =
        "CREATE TABLE $tableName ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "title VARCHAR, "
        "description TEXT, "
        "date DATETIME)";
    await db.execute(sql);

  }

  initiateDB() async {

    final dBPath = await getDatabasesPath();
    final dBLocale = join(dBPath, "My_Notes.db");

    var db = await openDatabase(dBLocale, version: 1, onCreate: _onCreate);
    return db;

  }

  Future<int> saveNote(Note note) async {

    var database = await db;

    int result = await database.insert(tableName, note.toMap());
    return result;

  }

}