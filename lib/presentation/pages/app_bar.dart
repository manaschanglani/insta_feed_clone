import 'package:flutter/material.dart';

class InstagramAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const InstagramAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Instagram',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications coming soon')),
            );
          },
          icon: const Icon(Icons.favorite_border, color: Colors.black),
        ),
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Messages coming soon')),
            );
          },
          icon: const Icon(Icons.send_outlined, color: Colors.black),
        ),
      ],
    );
  }
}