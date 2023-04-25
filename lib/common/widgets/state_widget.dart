import 'package:flutter/material.dart';

class StateWidget extends StatelessWidget {
  const StateWidget({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context);
    return SizedBox(
      width: queryData.size.width,
      height: queryData.padding.top,
      child: ColoredBox(color: color ?? Theme.of(context).primaryColor),
    );
  }
}
