import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/nav_bar_provider.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {

    final NavBarProvider navbarProvider = Provider.of<NavBarProvider>(context);

    return BottomNavigationBar(
      currentIndex: navbarProvider.currentIndex,
      showSelectedLabels: false,
      showUnselectedLabels: false,

      selectedIconTheme: IconThemeData(
        color: Theme.of(context).primaryColor
      ),

      unselectedIconTheme: const IconThemeData(
        color: Colors.grey
      ),
      items: [

        BottomNavigationBarItem(
          icon: Icon( Icons.list_outlined ),
          label: 'Lista',
          backgroundColor: Theme.of(context).primaryColor,
        ),

        BottomNavigationBarItem(
          icon: Icon( Icons.bar_chart ),
          label: 'Estadisticas',
          backgroundColor: Theme.of(context).primaryColor,
        ),

      ],
      onTap: (value) => navbarProvider.currentIndex = value,
    );
  }
}