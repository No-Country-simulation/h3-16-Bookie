import 'package:bookie/config/intl/i18n.dart';
import 'package:bookie/config/persistent/shared_preferences.dart';
import 'package:flutter/material.dart';

class NavBarCustom extends StatelessWidget {
  final VoidCallback onSearchTapped;
  final AppLocalizations? localizations;
  final Function(String) changeLanguage;

  const NavBarCustom({
    super.key,
    required this.onSearchTapped,
    this.localizations,
    required this.changeLanguage,
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
              FutureBuilder(
                future: SharedPreferencesKeys.getCredentials(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Cuando se obtienen los datos exitosamente, muestra la imagen.
                    final userData = snapshot.data!;
                    return CircleAvatar(
                      backgroundImage: NetworkImage(userData.imageUrl ??
                          'https://res.cloudinary.com/dlixnwuhi/image/upload/v1733600879/eiwptc2xepcddfjaavqo.webp'),
                      radius: 20,
                    );
                  } else {
                    // Si no hay datos disponibles.
                    return const CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 20,
                      child: Icon(Icons.person, color: Colors.white),
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
              // const SizedBox(width: 4),
              // IconButton(
              //   onPressed: () {
              //     showModalBottomSheet(
              //       context: context,
              //       builder: (context) {
              //         return Column(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             ListTile(
              //               title: Text("English"),
              //               onTap: () {
              //                 changeLanguage("en");
              //                 Navigator.pop(context);
              //               },
              //             ),
              //             ListTile(
              //               title: Text("Español"),
              //               onTap: () {
              //                 changeLanguage("es");
              //                 Navigator.pop(context);
              //               },
              //             ),
              //             ListTile(
              //               title: Text("Português"),
              //               onTap: () {
              //                 changeLanguage("pt");
              //                 Navigator.pop(context);
              //               },
              //             ),
              //           ],
              //         );
              //       },
              //     );
              //   },
              //   icon: const Icon(
              //     Icons.language,
              //   ),
              //   color: colors.primary,
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
