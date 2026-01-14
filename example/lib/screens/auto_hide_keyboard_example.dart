import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

/// Example: Auto-Hide Keyboard
/// 
/// Demonstrates the hideWhenUnfocused feature - keyboard only appears
/// when a VirtualKeypadTextField is focused.
class AutoHideKeyboardExample extends StatefulWidget {
  const AutoHideKeyboardExample({super.key});

  @override
  State<AutoHideKeyboardExample> createState() =>
      _AutoHideKeyboardExampleState();
}

class _AutoHideKeyboardExampleState extends State<AutoHideKeyboardExample> {
  final _usernameController = VirtualKeypadController();
  final _emailController = VirtualKeypadController();
  final _displayController = VirtualKeypadController(text: 'Display only text');

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _displayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VirtualKeypadScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Auto-Hide Keyboard'),
        ),
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                // Tap anywhere to unfocus and hide keyboard
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
                              const Icon(Icons.keyboard_hide, size: 48),
                              const SizedBox(height: 12),
                              Text(
                                'hideWhenUnfocused Demo',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'The keyboard will automatically appear when you '
                                'tap on an editable field, and disappear when you '
                                'tap elsewhere.\n\n'
                                'Tap outside the text fields to hide the keyboard.',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Editable field
                      Text(
                        'Editable Fields',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      VirtualKeypadTextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          hintText: 'Tap to focus and show keyboard',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      VirtualKeypadTextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Another editable field',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),
                      
                      // Read-only field (won't activate keyboard)
                      Text(
                        'Read-Only Field',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'This field is read-only and won\'t activate the keyboard.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      VirtualKeypadTextField(
                        controller: _displayController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Read-Only Display',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                          filled: true,
                        ),
                      ),
                      
                      const SizedBox(height: 100), // Space for keyboard
                    ],
                  ),
                ),
              ),
            ),
            
            // Keyboard with auto-hide feature
            VirtualKeypad(
              theme: VirtualKeypadTheme.light,
              hideWhenUnfocused: true, // <-- The key feature!
            ),
          ],
        ),
      ),
    );
  }
}
