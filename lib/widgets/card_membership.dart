import 'package:ego/theme/color.dart';
import 'package:flutter/material.dart';

// Corregir esto: hay que quitar lo estatico y hacer un constructor
class CardMembership {
  static Widget buildMembershipTile(
    String name,
    String status,
    bool isPersonalizado, {
    VoidCallback? onEdit,
    VoidCallback? onUpdate,
    VoidCallback? onDelete,
  }) {
    return Card(
      color: isPersonalizado ? AppColors.gold : AppColors.darkGray,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          name,
          style: TextStyle(
            color: isPersonalizado ? AppColors.black : Colors.white,
            fontWeight: isPersonalizado ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          status,
          style: TextStyle(
            color: isPersonalizado ? AppColors.black : AppColors.green,
            fontWeight: isPersonalizado ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.update,
                color: isPersonalizado ? AppColors.black : AppColors.white,
              ),
              onPressed: onUpdate ?? () {},
            ),
            IconButton(
              icon: Icon(
                Icons.delete_forever,
                color: isPersonalizado ? AppColors.black : AppColors.white,
              ),
              onPressed:
                  onDelete ??
                  () {
                    print('Eliminar $name');
                  },
            ),
          ],
        ),
      ),
    );
  }
}
