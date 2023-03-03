import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'category.freezed.dart';

@freezed
class Category with _$Category {
  const factory Category({required int id, required String name}) = _Category;
}
