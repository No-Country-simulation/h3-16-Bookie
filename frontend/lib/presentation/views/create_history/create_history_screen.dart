import 'package:flutter/material.dart';

class CreateHistoryScreen extends StatelessWidget {
  static const String name = 'create_history';

  const CreateHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create History'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Text('Create History'),
      ),
    );
  }
}
