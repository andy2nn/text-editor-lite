import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Нет текстов")),
      floatingActionButton: ElevatedButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
