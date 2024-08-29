import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final Function(int index) navigateToScreen;

  const BottomNavBar({super.key, required this.navigateToScreen});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<IconData> listIcon = [
    Icons.home,
    Icons.grid_view_outlined,
    Icons.favorite_outline,
    Icons.account_circle_outlined,
  ];
  int selectedIconIndex = 0;

  @override
  void initState() {
    selectedIconIndex = widget.navigateToScreen(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 20),
      width: width,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: listIcon
            .map(
              (e) => IconButton(
                  onPressed: () {

                    setState(() {
                      selectedIconIndex = listIcon.indexOf(e);
                    });

                    widget.navigateToScreen(selectedIconIndex);
                  },
                  icon: Icon(
                    e,
                    color: selectedIconIndex == listIcon.indexOf(e)
                        ? Colors.green
                        : Colors.white,
                  )),
            )
            .toList(),
      ),
    );
  }
}
