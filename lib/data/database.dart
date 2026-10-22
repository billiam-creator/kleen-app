import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart'; // generated file, doesn't exist yet

class Clients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get phone => text()();
  TextColumn get area => text().nullable()();
  TextColumn get addressNotes => text().nullable()();
  TextColumn get source => text()();
  IntColumn get referredBy => integer().nullable().references(Clients, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Clients])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // A Stream re-emits whenever the table changes, so the UI updates itself.
  Stream<List<Client>> watchClients() =>
      (select(clients)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();

  Future<int> addClient(ClientsCompanion client) =>
      into(clients).insert(client);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'kleen.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}