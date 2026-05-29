import 'package:carrypill/presentations/pages/homepage/tabs/suborder/request_delivery_history_tab.dart';
import 'package:carrypill/presentations/pages/homepage/tabs/suborder/request_pickup_history_tab.dart';
import 'package:flutter/material.dart';

class OrderTab extends StatelessWidget {
  const OrderTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Delivery',
                icon: Icon(Icons.delivery_dining_rounded),
              ),
              Tab(
                text: 'Pickup',
                icon: Icon(Icons.store_mall_directory_outlined),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            RequestDeliveryHistoryTab(),
            RequestPickupHistoryTab(),
          ],
        ),
      ),
    );
  }
}
