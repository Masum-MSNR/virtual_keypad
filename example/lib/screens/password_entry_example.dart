import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

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
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock, size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'Enter Password',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 24),
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
                                content: Text('Password: ${_controller.text}'),
                              ),
                            );
                          },
                          child: const Text('Submit'),
                        ),
                      ),
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
