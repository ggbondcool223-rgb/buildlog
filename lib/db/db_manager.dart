import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'build_log_entity.dart';

class DB extends GetxService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<DB> init() async {
    await database;
    print('Database initialized successfully');
    return this;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'build_log.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE build_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        unit TEXT NOT NULL,
        project_name TEXT NOT NULL,
        project_supervisor TEXT NOT NULL,
        supervisor TEXT NOT NULL,
        weather INTEGER,
        photo_path TEXT,
        notes TEXT,
        date TEXT NOT NULL,
        create_time INTEGER NOT NULL
      )
    ''');
    print('Table build_log created');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE build_log_new (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          unit TEXT NOT NULL,
          project_name TEXT NOT NULL,
          project_supervisor TEXT NOT NULL,
          supervisor TEXT NOT NULL,
          weather INTEGER,
          photo_path TEXT,
          notes TEXT,
          date TEXT NOT NULL,
          create_time INTEGER NOT NULL
        )
      ''');

      await db.execute('''
        INSERT INTO build_log_new (id, unit, project_name, project_supervisor, supervisor, weather, photo_path, notes, date, create_time)
        SELECT id, unit, project_name, project_supervisor, supervisor, 
               CASE WHEN weather IS NULL OR weather = '' THEN 0 ELSE CAST(weather AS INTEGER) END,
               photo_path, notes, date, create_time
        FROM build_log
      ''');

      await db.execute('DROP TABLE build_log');
      await db.execute('ALTER TABLE build_log_new RENAME TO build_log');

      print('Database upgraded to version 2: weather field changed to INTEGER');
    }
  }

  Future<int> insertBuildLog(BuildLogEntity log) async {
    final db = await database;
    return await db.insert('build_log', log.toMap());
  }

  Future<List<BuildLogEntity>> queryBuildLogsByDate(String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'build_log',
      where: 'date = ?',
      whereArgs: [date],
      orderBy: 'create_time DESC',
    );
    return maps.map((map) => BuildLogEntity.fromMap(map)).toList();
  }

  Future<BuildLogEntity?> queryBuildLogById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'build_log',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return BuildLogEntity.fromMap(maps.first);
  }

  Future<Set<String>> getLogDatesInMonth(String month) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'build_log',
      columns: ['date'],
      where: 'date LIKE ?',
      whereArgs: ['$month%'],
      distinct: true,
    );
    return maps.map((map) => map['date'] as String).toSet();
  }

  Future<Map<String, int>> getLogCountByDateInMonth(String month) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT date, COUNT(*) as count 
      FROM build_log 
      WHERE date LIKE ? 
      GROUP BY date
    ''',
      ['$month%'],
    );

    final Map<String, int> result = {};
    for (var map in maps) {
      result[map['date'] as String] = map['count'] as int;
    }
    return result;
  }

  Future<int> deleteAllBuildLogs() async {
    final db = await database;
    return await db.delete('build_log');
  }

  Future<int> getMonthLogCount(String month) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM build_log WHERE date LIKE ?',
      ['$month%'],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
