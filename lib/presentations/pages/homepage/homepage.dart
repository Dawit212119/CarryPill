import 'package:carrypill/business_logic/provider/patient_provider.dart';
import 'package:carrypill/constants/constant_color.dart';
import 'package:carrypill/data/models/patient.dart';
import 'package:provider/provider.dart';
import 'tabs/home_tab.dart';
import 'tabs/order_tab.dart';
import 'tabs/profile_tab.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final Patient patient;

  const HomePage({super.key, required this.patient});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PatientProvider>(context, listen: false)
          .updatePatient(widget.patient);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcBgHome1,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeTab(patient: widget.patient),
          const OrderTab(),
          ProfileTab(patient: widget.patient),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
