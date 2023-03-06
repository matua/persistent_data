// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dao.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  SafeUserDao? _userDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `safe_users` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `firstName` TEXT NOT NULL, `lastName` TEXT NOT NULL, `age` INTEGER NOT NULL, `image` TEXT NOT NULL, `phoneNumber` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  SafeUserDao get userDao {
    return _userDaoInstance ??= _$SafeUserDao(database, changeListener);
  }
}

class _$SafeUserDao extends SafeUserDao {
  _$SafeUserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _safeUserInsertionAdapter = InsertionAdapter(
            database,
            'safe_users',
            (SafeUser item) => <String, Object?>{
                  'id': item.id,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'age': item.age,
                  'image': item.image,
                  'phoneNumber': item.phoneNumber
                }),
        _safeUserUpdateAdapter = UpdateAdapter(
            database,
            'safe_users',
            ['id'],
            (SafeUser item) => <String, Object?>{
                  'id': item.id,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'age': item.age,
                  'image': item.image,
                  'phoneNumber': item.phoneNumber
                }),
        _safeUserDeletionAdapter = DeletionAdapter(
            database,
            'safe_users',
            ['id'],
            (SafeUser item) => <String, Object?>{
                  'id': item.id,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'age': item.age,
                  'image': item.image,
                  'phoneNumber': item.phoneNumber
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SafeUser> _safeUserInsertionAdapter;

  final UpdateAdapter<SafeUser> _safeUserUpdateAdapter;

  final DeletionAdapter<SafeUser> _safeUserDeletionAdapter;

  @override
  Future<List<SafeUser>> getAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM safe_users',
        mapper: (Map<String, Object?> row) => SafeUser(
            id: row['id'] as int?,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            age: row['age'] as int,
            image: row['image'] as String,
            phoneNumber: row['phoneNumber'] as String));
  }

  @override
  Future<void> deleteAllUsers() async {
    await _queryAdapter.queryNoReturn('DELETE FROM safe_users');
  }

  @override
  Future<void> addUser(SafeUser safeUser) async {
    await _safeUserInsertionAdapter.insert(safeUser, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUser(SafeUser safeUser) async {
    await _safeUserUpdateAdapter.update(safeUser, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUser(SafeUser safeUser) async {
    await _safeUserDeletionAdapter.delete(safeUser);
  }
}
