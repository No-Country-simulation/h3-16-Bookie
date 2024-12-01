import 'package:bookie/config/intl/i18n.dart';
import 'package:flutter/material.dart';

class NavBarCustom extends StatelessWidget {
  final String userName;
  final String avatarUrl;
  final VoidCallback onSearchTapped;
  final AppLocalizations? localizations;
  final Function(String) changeLanguage;

  const NavBarCustom({
    super.key,
    required this.userName,
    required this.avatarUrl,
    required this.onSearchTapped,
    this.localizations,
    required this.changeLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/images/logo.webp', height: 50),
          Row(
            children: [
              // Text(
              //   localizations?.translate("greeting") != null
              //       ? "${localizations?.translate("greeting")}, $userName"
              //       : "",
              //   style: const TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // const SizedBox(width: 12),
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
              // const SizedBox(width: 4),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text("English"),
                            onTap: () {
                              changeLanguage("en");
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: Text("Español"),
                            onTap: () {
                              changeLanguage("es");
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: Text("Português"),
                            onTap: () {
                              changeLanguage("pt");
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.language,
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