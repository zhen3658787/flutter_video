import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_video/model/index.dart';

import 'lifecycle_handler.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget(this._imagws,
      {super.key,
      this.width = double.infinity,
      this.height = 0,
      required this.onTap,
      this.curve = Curves.linear,
      this.verticalPadding = 0,
      this.horizontalPadding = 0,
      this.radius = 0});

  final List<BannerEntity> _imagws;
  final double width;
  final double height;
  final ValueChanged<int> onTap;
  final Curve curve;
  final double horizontalPadding;
  final double verticalPadding;
  final double radius;

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final PageController _controller = PageController();
  int _curIndex = 0;
  Timer? _timer;

  ///////////////////////////////////////////////////////////////////////

  late final LifecycleEventHandler _lifecycleEventHandler;

  runable(Timer timer) {
    if (widget._imagws.isEmpty) return;
    _controller.animateToPage(_curIndex++,
        duration: const Duration(milliseconds: 400), curve: Curves.linear);
  }

  _initTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      runable,
    );
  }

  _cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  _resetTimer() {
    _cancelTimer();
    _initTimer();
  }

  @override
  void initState() {
    super.initState();
    _lifecycleEventHandler = LifecycleEventHandler(resumeCallBack: () async {
      _resetTimer();
    }, suspendingCallBack: () async {
      _cancelTimer();
    });
    WidgetsBinding.instance.addObserver(_lifecycleEventHandler);
    _initTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleEventHandler);
    _cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: widget.verticalPadding,
            horizontal: widget.horizontalPadding),
        child: Stack(
          children: [
            _buildPageView(),
            _buildIndicatorView(),
          ],
        ),
      ),
    );
  }

  PageView _buildPageView() {
    return PageView.builder(
      itemCount: widget._imagws.length * 10000,
      controller: _controller,
      itemBuilder: (BuildContext context, int index) {
        var myBanner = widget._imagws[index % widget._imagws.length];
        return GestureDetector(
          onPanDown: (details) => _resetTimer(),
          onTap: () => widget.onTap(index % widget._imagws.length),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
            child: Image.network(
              myBanner.image,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      onPageChanged: (value) {
        setState(() {
          _curIndex = value;
        });
      },
    );
  }

  Widget _buildIndicatorView() {
    List<Widget> list = [];
    for (var element in widget._imagws) {
      list.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: CircleAvatar(
          radius: 4,
          backgroundColor:
              (element == widget._imagws[_curIndex % widget._imagws.length]
                  ? Colors.white
                  : Colors.black38),
        ),
      ));
    }
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: list,
      ),
    );
  }
}
