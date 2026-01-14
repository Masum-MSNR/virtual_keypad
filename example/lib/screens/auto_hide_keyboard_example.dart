import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

class AutoHideKeyboardExample extends StatefulWidget {
  const AutoHideKeyboardExample({super.key});

  @override
  State<AutoHideKeyboardExample> createState() => _AutoHideKeyboardExampleState();
}

class _AutoHideKeyboardExampleState extends State<AutoHideKeyboardExample> {
  final _field1 = VirtualKeypadController();
  final _field2 = VirtualKeypadController();
  final _readOnlyField = VirtualKeypadController(text: 'Read-only text');

  @override
  void dispose() {
    _field1.dispose();
    _field2.dispose();
    _readOnlyField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VirtualKeypadScope(
      child: Scaffold(
        appBar: AppBar(title: const Text('Auto-Hide Keyboard')),
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                behavior: HitTestBehavior.opaque,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.keyboard_hide, size: 24),
                                  const SizedBox(width: 8),
                                  Text(
                                    'hideWhenUnfocused: true',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Keyboard appears when a field is focused and '
                                'hides with animation when tapping outside.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text('Editable Fields', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      VirtualKeypadTextField(
                        controller: _field1,
                        decoration: const InputDecoration(
                          labelText: 'Field 1',
                          hintText: 'Tap to show keyboard',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      VirtualKeypadTextField(
                        controller: _field2,
                        decoration: const InputDecoration(
                          labelText: 'Field 2',
                          hintText: 'Tap to show keyboard',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text('Read-Only Field', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text(
                        'Read-only fields do not activate the keyboard.',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 12),
                      VirtualKeypadTextField(
                        controller: _readOnlyField,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Read-Only',
                          border: OutlineInputBorder(),
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
            VirtualKeypad(hideWhenUnfocused: true),
          ],
        ),
      ),
    );
  }
}

