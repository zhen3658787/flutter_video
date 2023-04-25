import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video/common/utils/index.dart';
import 'package:flutter_video/model/index.dart';

class WrapVideoPlayer {
  final dynamic _id;
  final FijkPlayer _player = FijkPlayer();
  VideoEntity? _videoEntity;
  int _aotuPlayVideoHash = 0;
  FijkState _currentState = FijkState.idle;
  late bool _isStar, _isPaused;
  ValueChanged<String>? _callback;
  WrapVideoPlayer({id}) : _id = id {
    _init();
  }

  FijkPlayer get player => _player;

  String get coverUrl => _videoEntity?.coverPicUrl ?? "";

  _init() {
    _player.addListener(_playerListener);
  }

  dispose() {
    _player.removeListener(_playerListener);
    _player.dispose();
  }

  addListener(callback) {
    _callback = callback;
  }

  removeListener() {
    _callback = null;
  }

  _playerListener() async {
    var state = _player.state;
    switch (state) {
      case FijkState.idle:
        if (_currentState == FijkState.idle) return;
        _currentState = FijkState.idle;
        p("$_id State.idle");
        if (_videoEntity == null) return;
        await _player.setLoop(0);
        await _player.setDataSource(_videoEntity?.playurl ?? "",
            showCover: true);
        break;
      case FijkState.initialized:
        if (_currentState == FijkState.initialized) return;
        _currentState = FijkState.initialized;
        p("$_id State.initialized   ${_videoEntity?.alias}");
        // _player.prepareAsync();
        break;
      case FijkState.asyncPreparing:
        break;
      case FijkState.prepared:
        if (_currentState == FijkState.prepared || _isStar) return;
        _currentState = FijkState.prepared;
        p("$_id State.prepared   ${_videoEntity?.alias}");
        _isStar = true;
        _checkStar();
        break;
      case FijkState.started:
        if (_currentState == FijkState.started) return;
        _currentState = FijkState.started;
        if (_callback == null) return;
        _callback!("播放器$_id ${_videoEntity!.alias}");
        p("$_id State.started   ${_videoEntity?.alias}");
        break;
      case FijkState.paused:
        if (_currentState == FijkState.paused) return;
        _currentState = FijkState.paused;
        p("$_id State.paused   ${_videoEntity?.alias}");
        break;
      case FijkState.completed:
        break;
      case FijkState.stopped:
        break;
      case FijkState.error:
        if (_currentState == FijkState.error) return;
        _currentState = FijkState.error;
        p("$_id State.error");
        _isStar = false;
        await _player.reset();
        break;
      case FijkState.end:
        break;
    }
  }

  ///可以自动开始播放的页面绑定
  bindingAutoPlay(VideoEntity videoEntity) {
    _aotuPlayVideoHash = videoEntity.hashCode;
    binding(videoEntity);
    _isPaused = false;
  }

  binding(VideoEntity videoEntity) async {
    // if (_videoEntity != null && _videoEntity.hashCode == videoEntity.hashCode) {
    //   return;
    // }
    _videoEntity = null;
    p("$_id _binding ${videoEntity.alias}");
    _videoEntity = videoEntity;
    _resetTag();
    await _player.reset();
    await _player.setLoop(0);
    await _player.setDataSource(_videoEntity!.playurl, showCover: true);
  }

  ///播放视频
  _playVideo() {
    _player.start();
  }

  ///检查是否可以播放
  _checkStar() {
    if (_isStar && !_isPaused) {
      _playVideo();
      return;
    }
    if (_aotuPlayVideoHash == _videoEntity.hashCode && !_isPaused) {
      _playVideo();
    }
  }

  ///重置播放控制标记
  _resetTag() {
    _isStar = false;
    _isPaused = true;
  }

  ///外部条件可以播放视频
  markStar() {
    _isPaused = false;
    _checkStar();
  }

  ///划出界面后，需要调用该方法，暂停音视频
  pause() async {
    _isPaused = true;
    if (_player.isPlayable()) {
      await _player.pause();
    }
  }

  idle() async {
    _videoEntity = null;
    _aotuPlayVideoHash = -1;
    _resetTag();
    await _player.reset();
  }
}
