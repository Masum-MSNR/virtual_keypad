import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

class MultiFieldExample extends StatefulWidget {
  const MultiFieldExample({super.key});

  @override
  State<MultiFieldExample> createState() => _MultiFieldExampleState();
}

class _MultiFieldExampleState extends State<MultiFieldExample> {
  final _nameController = VirtualKeypadController();
  final _emailController = VirtualKeypadController();
  final _passwordController = VirtualKeypadController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VirtualKeypadScope(
      child: Scaffold(
        appBar: AppBar(title: const Text('Multi-Field Form')),
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                behavior: HitTestBehavior.opaque,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Tap any field to activate the keyboard.\n'
                        'Tap outside to dismiss.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      VirtualKeypadTextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                      const SizedBox(height: 16),
                      VirtualKeypadTextField(
                        controller: _emailController,
                        allowPhysicalKeyboard: true,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      VirtualKeypadTextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Form submitted')),
                          );
                        },
                        child: const Text('Submit'),
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
