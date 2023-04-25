import 'package:flutter_video/model/index.dart';

import 'base/json_convert_content.dart';

VideoResponseEntity $VideoResponseEntityFromJson(Map<String, dynamic> json) {
  final VideoResponseEntity videoResponseEntity = VideoResponseEntity();
  final int? p = jsonConvert.convert<int>(json['p']);
  if (p != null) {
    videoResponseEntity.p = p;
  }
  final int? pageCount = jsonConvert.convert<int>(json['pageCount']);
  if (pageCount != null) {
    videoResponseEntity.pageCount = pageCount;
  }
  final List<VideoEntity>? content =
      jsonConvert.convertListNotNull<VideoEntity>(json['content']);
  if (content != null) {
    videoResponseEntity.content = content;
  }
  return videoResponseEntity;
}

Map<String, dynamic> $VideoResponseEntityToJson(VideoResponseEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['p'] = entity.p;
  data['pageCount'] = entity.pageCount;
  data['content'] = entity.content.map((v) => v.toJson()).toList();
  return data;
}
