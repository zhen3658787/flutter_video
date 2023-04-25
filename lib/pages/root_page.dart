import 'package:flutter/material.dart';
import 'package:flutter_video/common/values/strings.dart';
import 'package:flutter_video/common/widgets/index.dart';
import 'package:flutter_video/pages/index.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final List<BottomNavigationBarItem> _navigationBarList = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: S.home,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.face),
      label: S.follow,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.message),
      label: S.messge,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: S.personal,
    ),
  ];

  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: _navigationBarList,
        onTap: (value) => _changePage(value),
        currentIndex: _currentIndex,
      ),
    );
  }

  PageView _buildPage() {
    return PageView.builder(
      itemBuilder: (context, index) {
        Widget page =
            const KeepAliveWrapper(keepAlive: false, child: HomePage());
        switch (index) {
          case 1:
            page =
                const KeepAliveWrapper(keepAlive: false, child: FollowPage());
            break;
          case 2:
            page =
                const KeepAliveWrapper(keepAlive: false, child: MessagePage());
            break;
          case 3:
            page =
                const KeepAliveWrapper(keepAlive: false, child: PersonalPage());
            break;
        }
        return page;
      },
      itemCount: _navigationBarList.length,
      onPageChanged: (value) => _currentIndex,
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  void _changePage(int index) {
    if (index != _currentIndex) {
      debugPrint("${widget.runtimeType} changePage($index)");
      _currentIndex = index;
      _pageController.jumpToPage(index);
      setState(() {});
    }
  }
}
