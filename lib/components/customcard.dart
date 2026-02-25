import 'package:AceDeck/components/alertdialog.dart';
import 'package:AceDeck/components/glass_container.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                onEdit(context);
              },
              backgroundColor: Colors.purple.shade400,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(16),
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
              borderRadius: BorderRadius.circular(16),
              autoClose: true,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: GlassContainer(
          borderRadius: 18,
          padding: EdgeInsets.zero,
          tintColor: isDark
              ? Colors.white.withValues(alpha: 0.07)
              : Colorslist.first.withValues(alpha: 0.15),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              height: 110,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: [
                    Colorslist.first.withValues(alpha: isDark ? 0.35 : 0.5),
                    Colorslist.last.withValues(alpha: isDark ? 0.15 : 0.3),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      gameName.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'BlackOpsOne',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white.withValues(alpha: 0.6),
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
