import 'package:bookie/shared/data/histories.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeFirstSearch extends StatefulWidget {
  final PageController pageController;
  const HomeFirstSearch({super.key, required this.pageController});

  @override
  State<HomeFirstSearch> createState() => _HomeFirstSearchState();
}

class _HomeFirstSearchState extends State<HomeFirstSearch> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> allStories = [];
  List<Map<String, dynamic>> filteredStories = [];

  @override
  void initState() {
    super.initState();
    // Combinar historias leídas y no leídas
    allStories = [...readStories, ...unreadStories];
    filteredStories = allStories;
  }

  void _onSearch(String query) {
    setState(() {
      filteredStories = allStories
          .where((story) =>
              story['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _hideSearchSection() {
    widget.pageController.animateToPage(0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    _searchController.clear();
    _onSearch('');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _hideSearchSection,
              ),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Buscar historias...',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _onSearch,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredStories.length,
            itemBuilder: (context, index) {
              final story = filteredStories[index];
              return ListTile(
                leading: Image.network(
                  story['imageUrl'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(story['title']),
                subtitle:
                    Text(story.containsKey('chapter') ? story['chapter'] : ''),
                onTap: () {
                  // Acción al seleccionar una historia
                  context.push('/story/${story['id']}');
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
