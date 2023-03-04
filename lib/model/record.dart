import 'package:hive/hive.dart';

import 'category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'record.freezed.dart';

part 'record.g.dart';

@freezed
@HiveType(typeId: 1, adapterName: "RecordAdapter")
class Record extends HiveObject with _$Record {
  Record._();

  factory Record({
    @HiveField(0) required int id,
    @HiveField(1) required Category category,
    @HiveField(2) required String name,
    @HiveField(3) required String description,
  }) = _Record;

  @override
  String toString() => '$name: $description)';
}
