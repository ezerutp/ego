import 'package:flutter/material.dart';
import 'package:ego/theme/color.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.darkGray,
      selectedItemColor: AppColors.orange,
      unselectedItemColor: Colors.white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Miembros'),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_membership),
          label: 'Membresías',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
        BottomNavigationBarItem(icon: Icon(Icons.backup), label: 'Backup'),
        /*
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Configuración',
        ), */
      ],
    );
  }
}
