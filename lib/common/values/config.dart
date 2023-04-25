import 'package:flutter/material.dart';

///全局常量配置文件

///是否正式环境
const isRelease = bool.fromEnvironment('dart.vm.product');

///是否开启代理
const openProxy = false;

///代理地址
const networkProxy = "192.168.0.222:8888";

final ThemeData defaultTheme = ThemeData(primarySwatch: Colors.red);

///全局通用间距边距
const double spacing = 10;
const double halfSpacing = 5;
