import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

class CustomThemeExample extends StatefulWidget {
  const CustomThemeExample({super.key});

  @override
  State<CustomThemeExample> createState() => _CustomThemeExampleState();
}

class _CustomThemeExampleState extends State<CustomThemeExample> {
  final _controller = VirtualKeypadController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const theme = VirtualKeypadTheme(
      backgroundColor: Color(0xFF1A1A2E),
      keyColor: Color(0xFF16213E),
      keyTextColor: Colors.white,
      actionKeyColor: Color(0xFF0F3460),
      keyBorderRadius: 12,
    );

    return VirtualKeypadScope(
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F1A),
        appBar: AppBar(
          title: const Text('Custom Theme'),
          backgroundColor: const Color(0xFF1A1A2E),
          foregroundColor: Colors.white,
        ),
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
                        'Themed Keyboard',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'VirtualKeypadTheme customizes appearance',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      VirtualKeypadTextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Type here',
                          labelStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF0F3460),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF16213E),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            VirtualKeypad(theme: theme),
          ],
        ),
      ),
    );
  }
}
