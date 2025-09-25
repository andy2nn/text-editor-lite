import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.actions, this.title, this.toolbarHeight});
  final Widget? title;
  final List<Widget>? actions;
  final double? toolbarHeight;

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      actions: actions,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
    );
  }
}
