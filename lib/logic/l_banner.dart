import 'package:flutter/material.dart';
import 'package:flutter_video/api/api.dart';
import 'package:flutter_video/common/utils/index.dart';
import 'package:flutter_video/model/index.dart';

class BannerLogic with ChangeNotifier {
  List<BannerEntity> bannerList = <BannerEntity>[];

  Future requestData() async {
    var requestData = await BannerApi().requestData();
    String flag = requestData['flag'];

    try {
      if (flag == '001') {
        var bannersJson = requestData['content'];
        if (bannersJson != null && bannersJson is List) {
          bannerList.clear();
          for (var element in bannersJson) {
            var myBanner = BannerEntity.fromJson(element);
            bannerList.add(myBanner);
            NetworkImage(myBanner.image).resolve(ImageConfiguration.empty);
          }
          notifyListeners();
          return;
        }
      } else {
        p("$runtimeType service $flag");
      }
    } catch (e) {
      p("$runtimeType Network $e");
    }
  }
}
