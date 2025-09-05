import 'package:flutter/material.dart';

class RentalsPage extends StatelessWidget {
  const RentalsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Rentals')),
      body: const Center(child: Text('Active and past rentals placeholder')),
    );
  }
}
