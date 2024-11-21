import 'package:flutter/material.dart';

class NavBarCustom extends StatelessWidget {
  final String userName;
  final String avatarUrl;
  final VoidCallback onSearchTapped;

  const NavBarCustom({
    super.key,
    required this.userName,
    required this.avatarUrl,
    required this.onSearchTapped,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/images/logo.webp', height: 50),
          Row(
            children: [
              Text(
                "Hola, $userName",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                backgroundImage: NetworkImage(avatarUrl),
                radius: 20,
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onSearchTapped,
                icon: const Icon(
                  Icons.search,
                ),
                color: colors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
