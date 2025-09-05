import 'package:flutter/material.dart';
import '../../models/tool.dart';

class ToolDetailPage extends StatelessWidget {
  const ToolDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tool = ModalRoute.of(context)!.settings.arguments as Tool;

    return Scaffold(
      appBar: AppBar(title: Text(tool.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: tool.image.startsWith('http')
                ? Image.network(tool.image, fit: BoxFit.cover)
                : Image.asset(tool.image, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  tool.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${tool.category} • ${tool.location}',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 10),
                Text(tool.description),
                const SizedBox(height: 12),
                Text(
                  'Rs. ${tool.pricePerDay.toStringAsFixed(0)}/day',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Replace with actual rent flow
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Rent flow coming soon')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text('Rent this tool'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
