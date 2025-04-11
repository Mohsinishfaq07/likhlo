// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:likhlo/Utils/Model/InventoryModel.dart';
// import 'package:likhlo/Utils/Provider/InventoryProvider.dart';
// import 'package:likhlo/Widgets/CustomTextField.dart';

// class AddProductScreen extends ConsumerStatefulWidget {
//   final String inventoryType;

//   const AddProductScreen({super.key, required this.inventoryType});

//   @override
//   _AddProductScreenState createState() => _AddProductScreenState();
// }

// class _AddProductScreenState extends ConsumerState<AddProductScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _quantityController = TextEditingController();
//   bool _isAvailable = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Product'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             CustomTextField(
//               controller: _nameController,
//               label: 'Product Name',
//               hintText: 'Enter product name',
//             ),
//             CustomTextField(
//               controller: _descriptionController,
//               label: 'Description',
//               hintText: 'Enter product description',
//             ),
//             CustomTextField(
//               controller: _priceController,
//               label: 'Price',
//               hintText: 'Enter product price',
//               keyboardType: TextInputType.number,
//             ),
//             CustomTextField(
//               controller: _quantityController,
//               label: 'Quantity',
//               hintText: 'Enter product quantity',
//               keyboardType: TextInputType.number,
//             ),
//             Row(
//               children: [
//                 Text('Available: '),
//                 Switch(
//                   value: _isAvailable,
//                   onChanged: (value) {
//                     setState(() {
//                       _isAvailable = value;
//                     });
//                   },
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 final product = Inventory(
//                   productName: _nameController.text,
//                   description: _descriptionController.text,
//                   price: double.parse(_priceController.text),
//                   quantity: int.parse(_quantityController.text),
//                   isAvailable: _isAvailable,
//                 );
//                 ref.read(inventoryRepositoryProvider).addInventoryItem`(
//                   product,
//                   widget.inventoryType,
//                 );
//                 Navigator.pop(context);
//               },
//               child: Text('Add Product'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
