import 'package:AceDeck/components/alertdialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CustomCard extends StatelessWidget {
  final VoidCallback onTap;
  final String gameName;
  final void Function(BuildContext context) onDelete;
  final void Function(BuildContext context) onEdit;
  final List<Color> Colorslist;

  CustomCard({
    required this.onTap,
    required this.gameName,
    required this.onDelete,
    required this.onEdit,
    required this.Colorslist,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              onEdit(context);
            },
            backgroundColor: Colors.purple.shade400,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(20),
            autoClose: true,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (context) {
                  return customalertdialog(
                    title: "Delete Game",
                    content: "Are you sure you want to delete this game?",
                    onPressed: () {
                      onDelete(context);
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
            backgroundColor: Colors.red.shade400,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(20),
            autoClose: true,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SizedBox(
            width: 2,
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
              colors: Colorslist,
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
