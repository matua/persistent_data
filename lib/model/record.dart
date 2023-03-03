import 'category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'record.freezed.dart';

@freezed
class Record with _$Record {
  const factory Record(
      {required int id, required Category category, required String name, required String description}) = _Record;
}
