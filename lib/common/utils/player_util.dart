import 'package:flutter/services.dart';
import 'package:flutter_video/common/widgets/index.dart';

class PlayerUtil {
  static const length = 3;
  static PlayerUtil? _instance;
  late List<WrapVideoPlayer> playerList;
  ValueChanged<String>? _callback;
  PlayerUtil._initial() {
    init();
  }

  factory PlayerUtil() => _instance ??= PlayerUtil._initial();

  init() {
    playerList = [
      WrapVideoPlayer(id: "播放器1"),
      WrapVideoPlayer(id: "播放器2"),
      WrapVideoPlayer(id: "播放器3"),
    ];
  }

  WrapVideoPlayer getPlayer(int index) {
    return playerList[index];
  }

  addListener(ValueChanged<String>? callback) {
    _callback = callback;
    for (var element in playerList) {
      element.addListener(_callback);
    }
  }

  removeListener() {
    for (var element in playerList) {
      element.removeListener();
      _callback = null;
    }
  }

  idle() {
    for (var element in playerList) {
      element.idle();
    }
  }

  dispose() {
    for (var element in playerList) {
      element.dispose();
    }
    _instance = null;
  }
}
