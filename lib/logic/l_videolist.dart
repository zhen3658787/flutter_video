import 'package:flutter/material.dart';
import 'package:flutter_video/api/api.dart';
import 'package:flutter_video/common/utils/index.dart';
import 'package:flutter_video/model/index.dart';

class VideoListLogic with ChangeNotifier {
  int _page = 1;
  int _pageCount = 1;
  final List<VideoEntity> _videoList = <VideoEntity>[];

  Future requestData([bool isFirstPage = false]) async {
    if (isFirstPage) {
      _page = 1;
    } else {
      if (_page == _pageCount) return;
      _page++;
    }
    Map<String, dynamic> result = await VideoListApi().requestData(_page);
    var flag = result['flag'];
    try {
      if (flag == "001") {
        var videoResponseEntity =
            VideoResponseEntity.fromJson(result["content"]);
        _pageCount = videoResponseEntity.pageCount;
        var list = videoResponseEntity.content;
        if (_page == 1) {
          _videoList.clear();
        }
        _videoList.addAll(list);
        notifyListeners();
      } else {
        p("$runtimeType service $flag");
      }
    } catch (e) {
      p("$runtimeType Network $e");
    }
  }

  isEnd() {
    return _pageCount == _page;
  }

  int getListSize() {
    return _videoList.length;
  }

  VideoEntity getVideoEntity(int index) {
    return _videoList[index];
  }
}
