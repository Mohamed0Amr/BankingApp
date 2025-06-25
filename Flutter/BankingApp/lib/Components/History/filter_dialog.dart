import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  bool _showIncome = true;
  bool _showExpenses = true;
  String _selectedPeriod = 'Last 30 days';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Transactions'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CheckboxListTile(
            title: const Text('Income'),
            value: _showIncome,
            onChanged: (value) {
              setState(() {
                _showIncome = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Expenses'),
            value: _showExpenses,
            onChanged: (value) {
              setState(() {
                _showExpenses = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedPeriod,
            items: const [
              DropdownMenuItem(
                value: 'Last 7 days',
                child: Text('Last 7 days'),
              ),
              DropdownMenuItem(
                value: 'Last 30 days',
                child: Text('Last 30 days'),
              ),
              DropdownMenuItem(
                value: 'Last 3 months',
                child: Text('Last 3 months'),
              ),
              DropdownMenuItem(
                value: 'Custom range',
                child: Text('Custom range'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedPeriod = value!;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Time Period',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            // Apply filters here
            Navigator.pop(context);
          },
          child: const Text('Apply Filters'),
        ),
      ],
    );
  }
}