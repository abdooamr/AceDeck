import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CustomCard extends StatelessWidget {
  final VoidCallback onTap;
  final String gameName;
  final void Function(BuildContext context) onDelete;
  final void Function(BuildContext context) onEdit;

  CustomCard({
    required this.onTap,
    required this.gameName,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              onDelete(context);
            },
            backgroundColor: Colors.red.shade400,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(10),
            autoClose: true,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (context) {
              onEdit(context);
            },
            backgroundColor: Colors.purple.shade400,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(10),
            autoClose: true,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 120,
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 106, 28, 120),
                Color.fromARGB(255, 223, 45, 255),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  gameName.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: "blackopsone",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
