import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video/common/utils/print.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  static const String tag = '==LifecycleEventHandler==';
  final AsyncCallback? resumeCallBack;
  final AsyncCallback? suspendingCallBack;

  LifecycleEventHandler({
    this.resumeCallBack,
    this.suspendingCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        p(tag + state.toString());
        if (resumeCallBack != null) {
          await resumeCallBack!();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        p(tag + state.toString());
        if (suspendingCallBack != null) {
          await suspendingCallBack!();
        }
        break;
    }
  }
}
