import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yepp/core/router/app_route_config.dart';
import 'package:yepp/core/router/app_route_constant.dart';

class HomePage extends StatefulWidget {
  final Widget child;

  const HomePage({super.key, required this.child});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body:widget.child,
      // PageView(
      //     onPageChanged: (value) => setState(() {
      //           _selectedIndex = value;
      //         }),
      //     controller: _pageController,
      //     children: [widget.child]),
      bottomNavigationBar: CrystalNavigationBar(
        selectedItemColor: Colors.white70,
        unselectedItemColor: Colors.black87,
        backgroundColor: Colors.blue.withOpacity(0.3),
        items: [
          CrystalNavigationBarItem(
            icon: Icons.home,
          ),
          CrystalNavigationBarItem(
            icon: Icons.favorite,
          ),
          CrystalNavigationBarItem(
            icon: Icons.settings,
          ),
        ],
        onTap: (index) {
          // setState(() {
          //   _selectedIndex = value;
          // });
          // _pageController.jumpToPage(value);
          _onItemTapped(index, context);
        },
        // currentIndex: _selectedIndex,
        currentIndex: _getSelectedIndex(context),
      ),
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed(AppRouteConstant.homeNavigationRoute);
        break;
      case 1:
        context.goNamed(AppRouteConstant.favoriteNavigationRoute);
        break;
      case 2:
        context.goNamed(AppRouteConstant.settingsNavigationRoute);
        break;
    }
  }

  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;

    if (location.startsWith(homeNavPath)) {
      return 0;
    }
    if (location.startsWith(favoriteNavPath)) {
      return 1;
    }
    if (location.startsWith(settingsNavPath)) {
      return 2;
    }
    return 0;
  }
}
