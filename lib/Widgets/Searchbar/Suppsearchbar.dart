import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final Function(String) onSearchChanged; // A callback to pass the query

  const SearchWidget({super.key, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Search Supplier',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: onSearchChanged, // Trigger the callback when text changes
      ),
    );
  }
}
