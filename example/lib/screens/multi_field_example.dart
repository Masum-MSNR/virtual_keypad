import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

/// Example: Multi-Field Form
///
/// Demonstrates multiple text fields with shared keyboard.
class MultiFieldExample extends StatefulWidget {
  const MultiFieldExample({super.key});

  @override
  State<MultiFieldExample> createState() => _MultiFieldExampleState();
}

class _MultiFieldExampleState extends State<MultiFieldExample> {
  final _usernameController = VirtualKeypadController();
  final _emailController = VirtualKeypadController();
  final _passwordController = VirtualKeypadController();

  @override
  void dispose() {
    _usernameController.dispose();
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Create Account',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap a field to activate it, then use the virtual keyboard',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    VirtualKeypadTextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 16),
                    VirtualKeypadTextField(
                      controller: _emailController,
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Username: ${_usernameController.text}, '
                              'Email: ${_emailController.text}',
                            ),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('Create Account'),
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
