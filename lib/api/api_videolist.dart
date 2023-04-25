import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_video/common/values/index.dart';

//读取asset下的json
class VideoListApi {
  Future<Map<String, dynamic>> requestData(int page) async {
    var loadString = await rootBundle.loadString(AssetsJson.videoList);
    return jsonDecode(loadString);
  }
}
