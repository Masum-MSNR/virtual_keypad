import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

/// Example: Password Entry
///
/// Demonstrates secure PIN/password input with virtual keyboard.
class PasswordEntryExample extends StatefulWidget {
  const PasswordEntryExample({super.key});

  @override
  State<PasswordEntryExample> createState() => _PasswordEntryExampleState();
}

class _PasswordEntryExampleState extends State<PasswordEntryExample> {
  final _controller = VirtualKeypadController();
  bool _obscureText = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VirtualKeypadScope(
      child: Scaffold(
        appBar: AppBar(title: const Text('Password Entry')),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock, size: 64, color: Colors.grey),
                    const SizedBox(height: 24),
                    Text(
                      'Enter Your Password',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Use the virtual keyboard below',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    VirtualKeypadTextField(
                      controller: _controller,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() => _obscureText = !_obscureText);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Password entered: ${_controller.text}',
                              ),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('Submit'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            VirtualKeypad(
              theme: VirtualKeypadTheme.light,
              hideWhenUnfocused: true,
            ),
          ],
        ),
      ),
    );
  }
}
