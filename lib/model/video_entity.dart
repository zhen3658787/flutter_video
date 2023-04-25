import 'dart:convert';

import 'package:flutter_video/generated/json/base/json_field.dart';
import 'package:flutter_video/generated/json/video_entity.g.dart';

@JsonSerializable()
class VideoEntity {
  late String vid;
  late String uid = '';
  late String coverPicUrl;
  late String coverTitle;
  late String alias = '';
  late String picuser;
  late String vnum;
  late String znum;
  late String sec;
  late String id;
  late int islike;
  late String playurl;
  late int islive;
  late String type;

  VideoEntity();

  VideoEntity.of(
      {required this.playurl,
      required this.coverPicUrl,
      this.alias = '',
      this.uid = ''});

  factory VideoEntity.fromJson(Map<String, dynamic> json) =>
      $VideoEntityFromJson(json);

  Map<String, dynamic> toJson() => $VideoEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  @override
  int get hashCode => uid.hashCode + alias.hashCode;

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }
}
