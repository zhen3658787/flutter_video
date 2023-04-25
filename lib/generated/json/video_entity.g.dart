import 'package:flutter_video/model/index.dart';

import 'base/json_convert_content.dart';

VideoEntity $VideoEntityFromJson(Map<String, dynamic> json) {
  final VideoEntity videoEntity = VideoEntity();
  final String? vid = jsonConvert.convert<String>(json['vid']);
  if (vid != null) {
    videoEntity.vid = vid;
  }
  final String? uid = jsonConvert.convert<String>(json['uid']);
  if (uid != null) {
    videoEntity.uid = uid;
  }
  final String? coverPicUrl = jsonConvert.convert<String>(json['coverPicUrl']);
  if (coverPicUrl != null) {
    videoEntity.coverPicUrl = coverPicUrl;
  }
  final String? coverTitle = jsonConvert.convert<String>(json['coverTitle']);
  if (coverTitle != null) {
    videoEntity.coverTitle = coverTitle;
  }
  final String? alias = jsonConvert.convert<String>(json['alias']);
  if (alias != null) {
    videoEntity.alias = alias;
  }
  final String? picuser = jsonConvert.convert<String>(json['picuser']);
  if (picuser != null) {
    videoEntity.picuser = picuser;
  }
  final String? vnum = jsonConvert.convert<String>(json['vnum']);
  if (vnum != null) {
    videoEntity.vnum = vnum;
  }
  final String? znum = jsonConvert.convert<String>(json['znum']);
  if (znum != null) {
    videoEntity.znum = znum;
  }
  final String? sec = jsonConvert.convert<String>(json['sec']);
  if (sec != null) {
    videoEntity.sec = sec;
  }
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    videoEntity.id = id;
  }
  final int? islike = jsonConvert.convert<int>(json['islike']);
  if (islike != null) {
    videoEntity.islike = islike;
  }
  final String? playurl = jsonConvert.convert<String>(json['playurl']);
  if (playurl != null) {
    videoEntity.playurl = playurl;
  }
  final int? islive = jsonConvert.convert<int>(json['islive']);
  if (islive != null) {
    videoEntity.islive = islive;
  }
  final String? type = jsonConvert.convert<String>(json['type']);
  if (type != null) {
    videoEntity.type = type;
  }
  return videoEntity;
}

Map<String, dynamic> $VideoEntityToJson(VideoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['vid'] = entity.vid;
  data['uid'] = entity.uid;
  data['coverPicUrl'] = entity.coverPicUrl;
  data['coverTitle'] = entity.coverTitle;
  data['alias'] = entity.alias;
  data['picuser'] = entity.picuser;
  data['vnum'] = entity.vnum;
  data['znum'] = entity.znum;
  data['sec'] = entity.sec;
  data['id'] = entity.id;
  data['islike'] = entity.islike;
  data['playurl'] = entity.playurl;
  data['islive'] = entity.islive;
  data['type'] = entity.type;
  return data;
}
