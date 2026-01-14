import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

/// Example: Numeric Input
/// 
/// Demonstrates number pad for numeric input only.
class NumericInputExample extends StatefulWidget {
  const NumericInputExample({super.key});

  @override
  State<NumericInputExample> createState() => _NumericInputExampleState();
}

class _NumericInputExampleState extends State<NumericInputExample> {
  final _amountController = VirtualKeypadController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VirtualKeypadScope(
      child: Scaffold(
        appBar: AppBar(title: const Text('Numeric Input')),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.attach_money,
                      size: 64,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Enter Amount',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 32),
                    VirtualKeypadTextField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () => _amountController.clear(),
                          child: const Text('Clear'),
                        ),
                        FilledButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Amount: \$${_amountController.text}',
                                ),
                              ),
                            );
                          },
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            VirtualKeypad(
              type: KeyboardType.number,
              theme: VirtualKeypadTheme.light,
            ),
          ],
        ),
      ),
    );
  }
}
