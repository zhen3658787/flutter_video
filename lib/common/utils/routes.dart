import 'package:flutter/material.dart';
import 'package:flutter_video/pages/index.dart';

class Routes {
  static String root = "RootPage";
  static String home = "HomePage";
  static String follow = "FollowPage";
  static String message = "MessagePage";
  static String personal = "PersonalPage";
  static Map<String, WidgetBuilder> routes = {
    root: (context) => const RootPage(),
    home: (context) => const HomePage(),
    follow: (context) => const FollowPage(),
    message: (context) => const MessagePage(),
    personal: (context) => const PersonalPage(),
  };

  static push(BuildContext context, MaterialPageRoute route) {
    Navigator.push(context, route);
  }

  static pushNamed(BuildContext context, String pageName, {Object? arguments}) {
    Navigator.pushNamed(context, pageName, arguments: arguments);
  }

  static pushReplacementNamed(BuildContext context, String pageName,
      {Object? arguments}) {
    Navigator.of(context).pushReplacementNamed(pageName, arguments: arguments);
  }
}
