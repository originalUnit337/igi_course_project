import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text('leading'),
        title: Text('ogo'),
        centerTitle: true,
        actions: [
          Icon(Icons.home),
          Icon(Icons.search),
          Icon(Icons.notifications),
          Icon(Icons.more_vert),
          Icon(Icons.dark_mode)
        ],
      ),
    );
  }
}