import 'package:flutter/material.dart';
import 'package:motivational/extensions/media_query_extension.dart';
import 'package:motivational/model/sub_theme.dart';
import 'package:motivational/utils/my_colors.dart';

class AdminQuoteTile extends StatelessWidget {
  const AdminQuoteTile({
    super.key,
    required this.index,
    required this.color,
    required this.notificationSubTheme,
    required this.delete,
    required this.update,
    this.maxLine = 2,
  });
  final Function(SubTheme model) delete, update;
  final SubTheme notificationSubTheme;
  final Color color;
  final int index, maxLine;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: (notificationSubTheme.id ?? '').toString(),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: Colors.black.withOpacity(0.3),
        color: color,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
          alignment: Alignment.center,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 65.percentWidth(),
                child: Text(
                  (notificationSubTheme.description ?? ''),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: MyColors.colorE1E1,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: maxLine,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (maxLine <= 2)
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTapDown: (d) {
                      
                      _showPopupMenu(
                          context, d.globalPosition, notificationSubTheme);
                    },
                    child: const Icon(Icons.more_vert,
                        size: 20, color: Colors.black),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPopupMenu(
      BuildContext context, Offset position, SubTheme model) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          position.dx, position.dy, position.dx +10, position.dy + 50),
      items: const [
        PopupMenuItem(
          value: 'edit',
          child: Text('Edit'),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Text('Delete'),
        ),
      ],
    ).then((value) {
      if (value != null) {
        if (value == 'edit') {
          update(model);
        } else if (value == 'delete') {
          delete(model);
        }
      }
    });
  }
}
