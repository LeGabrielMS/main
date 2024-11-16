import 'package:flutter/material.dart';
import 'package:main/components/note_settings.dart';
import 'package:popover/popover.dart';

class NoteTile extends StatelessWidget {
  final String text;
  final void Function()? onEditPressed;
  final void Function()? onDeletePressed;
  const NoteTile(
      {super.key,
      required this.text,
      this.onEditPressed,
      this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 5),
      child: ListTile(
        title: Text(text),
        trailing: Builder(builder: (context) {
          return IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => showPopover(
              height: 100,
              width: 100,
              backgroundColor: Theme.of(context).colorScheme.surface,
              context: context,
              bodyBuilder: (context) => NoteSettings(
                onEditTap: onEditPressed,
                onDeleteTap: onDeletePressed,
              ),
            ),
          );
        }),
      ),
    );
  }
}
