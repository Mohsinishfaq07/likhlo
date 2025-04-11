// inventory_card.dart
import 'package:flutter/material.dart';
import 'package:likhlo/Utils/Model/InventoryModel.dart';

class InventoryCard extends StatelessWidget {
  final InventoryModel inventory; // Inventory data passed to this widget

  const InventoryCard({super.key, required this.inventory});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder (can be replaced with a real image)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blueGrey[100],
              ),
              child: Icon(Icons.inventory, color: Colors.white),
            ),
            const SizedBox(width: 16),
            // Inventory details (name and type)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    inventory.inventoryName, // Display inventory name
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    inventory.inventoryType, // Display inventory type
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
