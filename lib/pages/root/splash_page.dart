import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_video/common/utils/index.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final int _countDown = 3;
  int _currentSeconds = 0;
  final ValueNotifier<String> _btnText = ValueNotifier("");
  Timer? _timer;

  //////////////////////////////////////////////////////////////////////////////////
  ///
  void resetTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadConfig();
    _currentSeconds = _countDown;
    _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds-- == 0) {
        _goHomePage();
        return;
      }
      _btnText.value = "倒计时  $_currentSeconds s";
    });
  }

  @override
  void dispose() {
    if (mounted) _btnText.dispose();
    resetTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const Align(
              alignment: Alignment.center,
              child: Text(
                "SplashPage...广告页",
                style: TextStyle(color: Colors.white),
              )),
          Positioned(
            right: 30,
            bottom: 30,
            child: OutlinedButton(
              onPressed: _goHomePage,
              child: ValueListenableBuilder(
                builder: (BuildContext context, value, Widget? child) {
                  return Text(
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                      value);
                },
                valueListenable: _btnText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///跳转到应用主页
  void _goHomePage() {
    p('跳转到主页', widget);
    resetTimer();
    Routes.pushReplacementNamed(context, Routes.root);
  }

  ///加载应用配置和网络参数
  void _loadConfig() {}
}
