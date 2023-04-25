import 'package:flutter/material.dart';
import 'common/utils/routes.dart';
import 'common/values/index.dart';
import 'pages/index.dart';

void main() {
  runApp(
    MaterialApp(
      theme: defaultTheme,
      debugShowCheckedModeBanner: false,
      title: S.appName,
      routes: Routes.routes,
      home: const SplashPage(),
    ),
  );
}
