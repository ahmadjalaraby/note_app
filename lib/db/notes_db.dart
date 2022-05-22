import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note_model.dart';

class NotesDatabase {
  final String tableNotes = 'notes';
  static final NotesDatabase instance = NotesDatabase._init();
  static final List<String> values = [
    /// Add all fields
    "id", "title", "content", "color", "date",
  ];

  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const titleType = 'TEXT NOT NULL';
    const contentType = 'TEXT NOT NULL';
    const colorType = 'TEXT NOT NULL';
    const dateType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE NOTES ( 
  ${values.elementAt(0)} $idType, 
  ${values.elementAt(1)} $titleType,
  ${values.elementAt(2)} $contentType,
  ${values.elementAt(3)} $colorType,
  ${values.elementAt(4)} $dateType
  )
''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;

    final id = await db.insert(tableNotes, note.toMap());
    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: values,
      where: '${values.first} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;

    final orderBy = '${values.last} ASC';

    final result = await db.query(tableNotes, orderBy: orderBy);

    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;

    return db.update(
      tableNotes,
      note.toMap(),
      where: '${values.first} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${values.first} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    _database = null;
    db.close();
  }
}
