import 'package:flutter/material.dart';

class HealthLockerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final bool showBackButton;
  final Widget? secondaryAction;

  const HealthLockerAppBar({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionPressed,
    this.showBackButton = true,
    this.secondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00456A);

    return AppBar(
      toolbarHeight: 90,
      backgroundColor: primaryColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      leading: showBackButton 
          ? IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            )
          : null,
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        if (secondaryAction != null) ...[
          secondaryAction!,
          const SizedBox(width: 8),
        ],
        if (actionLabel != null)
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Center(
              child: GestureDetector(
                onTap: onActionPressed,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    actionLabel!,
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          )
        else
          const SizedBox(width: 48), // To balance the leading arrow
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
