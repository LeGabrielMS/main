import 'package:flutter/material.dart';
import 'package:main/model/todo.dart';

class ToDoTile extends StatelessWidget {
  final ToDo toDo;
  final void Function()? onEditPressed;
  final void Function()? onDeletePressed;
  final void Function(bool?)? onCompletedChanged;

  const ToDoTile({
    super.key,
    required this.toDo,
    this.onEditPressed,
    this.onDeletePressed,
    this.onCompletedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 5),
      child: ListTile(
        leading: Checkbox(
          value: toDo.isCompleted,
          onChanged: onCompletedChanged,
          activeColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        title: Text(
          toDo.title,
          style: TextStyle(
            decoration: toDo.isCompleted ? TextDecoration.lineThrough : null,
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: Theme.of(context).colorScheme.inversePrimary,
              onPressed: onEditPressed,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Theme.of(context).colorScheme.error,
              onPressed: onDeletePressed,
            ),
          ],
        ),
      ),
    );
  }
}
