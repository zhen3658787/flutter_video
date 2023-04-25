import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_video/common/values/assets.dart';

class BannerApi {
  Future<Map<String, dynamic>> requestData() async {
    var loadString = await rootBundle.loadString(AssetsJson.bannerList);
    return jsonDecode(loadString);
  }
}
