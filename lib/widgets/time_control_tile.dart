import 'package:flutter/material.dart';
import '../models/time_control.dart';

/// One time control row: tap to use it, menu on the right to edit or delete.
class TimeControlTile extends StatelessWidget {
  const TimeControlTile({
    super.key,
    required this.control,
    required this.selected,
    required this.onSelect,
    required this.onEdit,
    required this.onDelete,
  });

  final TimeControl control;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onSelect,
      contentPadding: const EdgeInsets.only(left: 16, right: 4),
      leading: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? scheme.primary : scheme.onSurface.withAlpha(90),
            width: selected ? 7 : 2,
          ),
        ),
      ),
      title: Text(control.name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        control.summary,
        style: TextStyle(color: scheme.onSurface.withAlpha(150)),
      ),
      trailing: PopupMenuButton<String>(
        tooltip: 'More',
        icon: Icon(Icons.more_horiz, color: scheme.onSurface.withAlpha(160)),
        onSelected: (v) => v == 'edit' ? onEdit() : onDelete(),
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'edit', child: Text('Edit')),
          PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      ),
    );
  }
}
