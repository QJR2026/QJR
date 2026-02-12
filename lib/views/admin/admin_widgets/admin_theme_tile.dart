import 'package:flutter/material.dart';
import 'package:motivational/extensions/media_query_extension.dart';
import 'package:motivational/app/my_app_view.dart';
import 'package:motivational/model/quote_theme.dart';
import 'package:motivational/utils/my_colors.dart';

import '../../../utils/routes.dart';

class AdminThemeTile extends StatelessWidget {
  const AdminThemeTile({
    super.key,
    required this.index,
    required this.color,
    required this.notificationSubTheme,
    required this.delete,
    required this.update,
  });
  final Function(QuoteTheme model) delete, update;
  final QuoteTheme notificationSubTheme;
  final Color color;
  final int index;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MyApp.gState.pushNamed(
          Routes.adminThemeDetailScreen,
          arguments: {
            "themeModel": notificationSubTheme,
          },
        );
      },
      child: Hero(
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
            // height: 100.pxV(),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 65.percentWidth(),
                  child: Text(
                    (notificationSubTheme.name ?? ''),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: MyColors.colorE1E1,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      _showPopupMenu(context, details.globalPosition,
                          notificationSubTheme);
                    },
                    child: const Icon(Icons.more_vert,
                        size: 20, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPopupMenu(
      BuildContext context, Offset position, QuoteTheme model) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          position.dx+30, position.dy, position.dx + 30, position.dy + 50),
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
