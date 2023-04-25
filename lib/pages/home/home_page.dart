import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video/common/utils/index.dart';
import 'package:flutter_video/common/values/index.dart';
import 'package:flutter_video/common/widgets/index.dart';
import 'package:flutter_video/logic/logic.dart';
import 'package:flutter_video/pages/index.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<bool> _showGoTop = ValueNotifier<bool>(false);
  final VideoListLogic videoLogic = VideoListLogic();
  final BannerLogic banerLogic = BannerLogic();
  final ScrollController _scrollController = ScrollController();
  late EasyRefreshController _refreshController;

////////////////////////////////////////////////////////////////////////////////////

  scrollListener() {
    if (_scrollController.offset < 1000 && _showGoTop.value) {
      _showGoTop.value = false;
    } else if (_scrollController.offset >= 1000 && !_showGoTop.value) {
      _showGoTop.value = true;
    }
  }

  @override
  void initState() {
    super.initState();
    banerLogic.requestData();
    videoLogic.requestData(true);
    _scrollController.addListener(scrollListener);
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
  }

  @override
  void dispose() {
    if (mounted) {
      _showGoTop.dispose();
      _refreshController.dispose();
      _scrollController.removeListener(scrollListener);
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildMain(),
      floatingActionButton: ValueListenableBuilder<bool>(
        builder: (BuildContext context, value, Widget? child) {
          return Visibility(
            visible: value, //goTop按钮是否显示
            child: child!,
          );
        },
        valueListenable: _showGoTop,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor.withAlpha(220),
          onPressed: () {
            _scrollController.animateTo(0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeIn);
          },
          child: const Icon(Icons.arrow_upward_outlined),
        ),
      ),
    );
  }

  Widget _buildMain() {
    var multiProvider = MultiProvider(
        providers: [
          ChangeNotifierProvider<VideoListLogic>.value(value: videoLogic),
          ChangeNotifierProvider<BannerLogic>.value(value: banerLogic),
        ],
        child: Column(
          children: [
            const StateWidget(),
            Expanded(child: _buildRefresh()),
          ],
        ));
    return multiProvider;
  }

  ///下拉刷新
  Widget _buildRefresh() {
    return EasyRefresh(
        controller: _refreshController,
        header: const ClassicHeader(showMessage: false),
        footer: const ClassicFooter(showMessage: false),
        onRefresh: () async {
          await videoLogic.requestData(true);
          _refreshController.finishRefresh();
          _refreshController.resetFooter();
        },
        onLoad: () async {
          await videoLogic.requestData();
          _refreshController.finishLoad(videoLogic.isEnd()
              ? IndicatorResult.noMore
              : IndicatorResult.success);
        },
        child: VideoScrollSlivers(scrollController: _scrollController));
  }
}

///视频滚动slivers
class VideoScrollSlivers extends StatelessWidget {
  const VideoScrollSlivers({
    super.key,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    var bannerHeight = MediaQuery.of(context).size.width / 580 * 200;
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: EasyRefresh(
            child: BannerWidget(
              horizontalPadding: halfSpacing,
              verticalPadding: halfSpacing,
              radius: spacing,
              //580*260
              context.watch<BannerLogic>().bannerList,
              height: bannerHeight,
              onTap: (int value) {
                p(value.toString());
              },
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: halfSpacing),
          sliver: SliverGrid.builder(
            itemCount: context.watch<VideoListLogic>().getListSize(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                childAspectRatio: 1,
                maxCrossAxisExtent: 200,
                mainAxisExtent: 200,
                mainAxisSpacing: halfSpacing,
                crossAxisSpacing: halfSpacing),
            itemBuilder: (BuildContext context, int index) {
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) =>
                    VideoImageItemWidget(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  index: index,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

///视频展示图片条目
class VideoImageItemWidget extends StatelessWidget {
  const VideoImageItemWidget(
      {super.key,
      required this.width,
      required this.height,
      required this.index});

  final double width;
  final double height;
  final int index;
  /////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    var videoLogic = context.watch<VideoListLogic>();
    var entity = videoLogic.getVideoEntity(index);
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(spacing)),
        child: Stack(
          children: [
            //主播图像
            Image.network(
              entity.coverPicUrl,
              width: width,
              height: height,
              fit: BoxFit.fitWidth,
            ),

            //阴影+文字
            Positioned(
              bottom: 0,
              child: Container(
                width: width,
                padding: const EdgeInsetsDirectional.all(halfSpacing),
                color: const Color.fromRGBO(0, 0, 0, 0.3),
                child: Text(
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                  entity.coverTitle,
                ),
              ),
            ),

            //水波纹
            Material(
              color: Colors.transparent,
              child: Ink(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Routes.pushNamed(
                    context,
                    Routes.video,
                    arguments: {
                      "VideoType": VideoType.list,
                      "logic": videoLogic,
                      "index": index
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
