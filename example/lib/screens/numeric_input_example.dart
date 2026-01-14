import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

class NumericInputExample extends StatefulWidget {
  const NumericInputExample({super.key});

  @override
  State<NumericInputExample> createState() => _NumericInputExampleState();
}

class _NumericInputExampleState extends State<NumericInputExample> {
  final _controller = VirtualKeypadController();

  @override
  void dispose() {
    _controller.dispose();
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
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Enter Amount',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 24),
                      VirtualKeypadTextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          prefixText: '\$ ',
                          border: OutlineInputBorder(),
                        ),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () => _controller.clear(),
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            VirtualKeypad(type: KeyboardType.number),
          ],
        ),
      ),
    );
  }
}
