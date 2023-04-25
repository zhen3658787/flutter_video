import 'dart:convert';

import 'package:flutter_video/generated/json/base/json_field.dart';
import 'package:flutter_video/generated/json/video_response_entity.g.dart';

import 'video_entity.dart';

@JsonSerializable()
class VideoResponseEntity {
  late int p;
  late int pageCount;
  late List<VideoEntity> content;

  VideoResponseEntity();

  factory VideoResponseEntity.fromJson(Map<String, dynamic> json) =>
      $VideoResponseEntityFromJson(json);

  Map<String, dynamic> toJson() => $VideoResponseEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
