import 'package:flutter/material.dart';

class SearchItemList extends StatelessWidget {
  const SearchItemList({
    super.key,
    required this.location,
    required this.press,
  });

  final String location;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        ListTile(
          onTap: press,
          horizontalTitleGap: 3,
          minLeadingWidth: 0,
          minTileHeight: 45,
          leading: const Icon(Icons.location_on, size: 20),
          title: Text(
            location,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: isDarkmode ? Colors.grey : Colors.grey[700],
        ),
      ],
    );
  }
}
