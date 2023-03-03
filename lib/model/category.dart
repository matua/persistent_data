import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'category.freezed.dart';

part 'category.g.dart';

@freezed
@HiveType(typeId: 2, adapterName: "CategoryAdapter")
class Category extends HiveObject with _$Category {
  Category._();

  factory Category({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
  }) = _Category;
}
