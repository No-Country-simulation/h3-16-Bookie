import 'package:bookie/config/persistent/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavBarCustom extends StatelessWidget {
  final VoidCallback onSearchTapped;
  // final AppLocalizations? localizations;
  // final Function(String) changeLanguage;

  const NavBarCustom({
    super.key,
    required this.onSearchTapped,
    // this.localizations,
    // required this.changeLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Image.asset('assets/images/logo.webp', height: 40)),
          Row(
            children: [
              FutureBuilder(
                future: SharedPreferencesKeys.getCredentials(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final userData = snapshot.data;
                    return GestureDetector(
                      onTap: () async {
                        context.push('/home/4/profile', extra: {
                          'userId': int.parse(userData?.id ?? '0'),
                        });
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(userData?.imageUrl ??
                            "https://res.cloudinary.com/dlixnwuhi/image/upload/v1733600879/eiwptc2xepcddfjaavqo.webp"),
                      ),
                    );
                  } else {
                    return const CircleAvatar(
                      radius: 20,
                    );
                  }
                },
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
