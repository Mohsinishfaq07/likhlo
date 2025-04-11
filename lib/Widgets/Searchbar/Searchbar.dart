// search_bar_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchBarWidget extends ConsumerWidget {
  final TextEditingController searchController;
  final StateProvider<String> searchControllerProvider;

  const SearchBarWidget({
    super.key,
    required this.searchController,
    required this.searchControllerProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: searchController, // Using the passed controller
      onChanged: (val) {
        // Update the search text in Riverpod state
        ref.read(searchControllerProvider.notifier).state = val;
      },
      decoration: InputDecoration(
        hintText: 'Search by name, amount, or mobile...',
        prefixIcon: const Icon(Icons.search, color: Colors.blue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
// searchbar.dart

class InventorySearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;

  const InventorySearchBar({
    super.key,
    required this.searchController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        labelText: 'Search Inventories',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
      onChanged: (query) {
        onSearch(query); // Call the callback when the text changes
      },
    );
  }
}
