import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video/common/utils/index.dart';
import 'package:flutter_video/logic/logic.dart';
import 'package:flutter_video/model/index.dart';

enum VideoType { single, list }

///播放视频的页面，需传入播放列表model
class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final videoRadius = 18.0;
  final playerLength = PlayerUtil.length;
  late VideoListLogic videoListLogic = VideoListLogic();
  late int _oldIndex;
  late PageController pageController;
  PlayerUtil playerUtil = PlayerUtil();

  late VideoEntity _videoEntity = VideoEntity();
  late VideoType _type;

  @override
  void dispose() {
    if (mounted) playerUtil.idle();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    var arguments = ModalRoute.of(context)?.settings.arguments;
    super.didChangeDependencies();
    if (arguments == null) return;
    _type = (arguments as Map)["VideoType"];
    if (_type == VideoType.list) {
      videoListLogic = arguments["logic"];
      _oldIndex = arguments["index"];
    } else if (_type == VideoType.single) {
      String playUrl = arguments["playurl"];
      String coverPicUrl = arguments["coverPicUrl"];
      _videoEntity = VideoEntity.of(playurl: playUrl, coverPicUrl: coverPicUrl);
      _oldIndex = 0;
    }

    pageController = PageController(initialPage: _oldIndex);

    initBinding();
  }

  initBinding() {
    int playerIndex = _oldIndex % playerLength;
    playerUtil.getPlayer(playerIndex).bindingAutoPlay(_type == VideoType.list
        ? videoListLogic.getVideoEntity(_oldIndex)
        : _videoEntity);

    //如果有上一页，添加到播放列表
    if (_oldIndex > 0) {
      playerIndex = (_oldIndex - 1) % playerLength;
      playerUtil
          .getPlayer(playerIndex)
          .binding(videoListLogic.getVideoEntity(_oldIndex - 1));
    }

    //下一页
    if (_oldIndex + 1 <= videoListLogic.getListSize() - 1) {
      playerIndex = (_oldIndex + 1) % playerLength;
      playerUtil
          .getPlayer(playerIndex)
          .binding(videoListLogic.getVideoEntity(_oldIndex + 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ClipRRect(
        borderRadius: BorderRadius.circular(videoRadius),
        child: PageView.builder(
          controller: pageController,
          scrollDirection: Axis.vertical,
          allowImplicitScrolling: false, //不好用,开了容易引起页面图片错乱
          itemCount: _type == VideoType.list ? videoListLogic.getListSize() : 1,
          onPageChanged: _handleChangePage,
          itemBuilder: (BuildContext context, int index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(videoRadius),
              child: Stack(
                children: [
                  FijkView(
                    fit: FijkFit.fitWidth,
                    fsFit: FijkFit.fitWidth,
                    // panelBuilder:
                    //     (player, data, context, viewSize, texturePos) =>
                    //         const SizedBox.shrink(),
                    player: playerUtil.getPlayer(index % playerLength).player,
                    color: Colors.black,
                    cover: NetworkImage(
                        playerUtil.getPlayer(index % playerLength).coverUrl),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _handleChangePage(newIndex) {
    p("滑动页面 oldIndex:$_oldIndex    newIndex:$newIndex", widget);
    playerUtil.getPlayer(newIndex % playerLength).markStar();
    playerUtil.getPlayer(_oldIndex % playerLength).pause();

    int playerIndex;
    //下一页
    if (newIndex > _oldIndex &&
        newIndex + 1 <= videoListLogic.getListSize() - 1) {
      playerIndex = (newIndex + 1) % playerLength;
      playerUtil
          .getPlayer(playerIndex)
          .binding(videoListLogic.getVideoEntity(newIndex + 1));
      prepareLoadImage(down: newIndex);
    }
    //上一页
    if (newIndex < _oldIndex && newIndex - 1 >= 0) {
      playerIndex = (newIndex - 1) % playerLength;
      playerUtil
          .getPlayer(playerIndex)
          .binding(videoListLogic.getVideoEntity(newIndex - 1));
      prepareLoadImage(up: newIndex);
    }
    _oldIndex = newIndex;
  }

  ///预加载覆盖图片
  prepareLoadImage({int? up, int? down, int count = 5}) {
    if (up == null && down == null) {
      return;
    }
    Future.delayed(Duration.zero, () {
      int targetIndex = up ?? down!;
      for (int i = up ?? down!;
          (up == null
              ? (i < targetIndex + count && i < videoListLogic.getListSize())
              : (i > targetIndex - count && i >= 0));
          (up == null ? i++ : i--)) {
        p("prepareLoadImage ${up == null ? 'down' : 'up'}______$i", widget);
        NetworkImage(videoListLogic.getVideoEntity(i).coverPicUrl)
            .resolve(const ImageConfiguration());
      }
    });
  }
}
