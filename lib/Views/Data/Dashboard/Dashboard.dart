import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:likhlo/Utils/Provider/CustomerProvider.dart';
import 'package:likhlo/Utils/Textstyle/Textstyle.dart';
import 'package:likhlo/Views/Data/Add/AddCustomer.dart';
import 'package:likhlo/Widgets/Button/GivenorTakenButton.dart';
import 'package:likhlo/Widgets/Cards/Cards.dart'; // Assuming a customer card widget exists
import 'package:likhlo/Widgets/Searchbar/Searchbar.dart'; // Assuming the search bar widget is in this file

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final TextEditingController _searchController =
      TextEditingController(); // Controller for search bar

  @override
  void dispose() {
    _searchController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fetch customer data stream
    final dataAsyncValue = ref.watch(customersStreamProvider);

    return GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          titleTextStyle: AppStyle(22, FontWeight.bold, Colors.white),
          title: const Text('Customer Dashboard'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [
            // Search and Filter Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Pass the controller and provider to the SearchBarWidget
                  SearchBarWidget(
                    searchController: _searchController,
                    searchControllerProvider: searchControllerProvider,
                  ),
                  const SizedBox(height: 16),
                  // Given/Taken Buttons
                  Row(
                    children: [
                      GivenTakenButtonWidget(
                        loanType: 'given',
                        label: 'Add Given',
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        icon: Icons.add,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      const AddCustomer(loanType: 'given'),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      GivenTakenButtonWidget(
                        loanType: 'taken',
                        label: 'Add Taken',
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        icon: Icons.add,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      const AddCustomer(loanType: 'taken'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Records List
            Expanded(
              child: dataAsyncValue.when(
                data: (data) {
                  final query =
                      ref.watch(searchControllerProvider).toLowerCase();

                  final filteredData =
                      data.where((item) {
                        final customer = item; // Assuming Customer model
                        return customer.name.toLowerCase().contains(query) ||
                            customer.mobile.toLowerCase().contains(query) ||
                            customer.amount.toString().contains(query);
                      }).toList();

                  if (filteredData.isEmpty) {
                    return const Center(child: Text('No records found'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final customer = filteredData[index];
                      return CustomerCard(
                        customer: customer,
                      ); // Assuming CustomerCard widget
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
