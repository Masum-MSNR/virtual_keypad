import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

/// Example: Custom Theme
/// 
/// Demonstrates customized keyboard appearance.
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
    // Custom purple theme
    const customTheme = VirtualKeypadTheme(
      backgroundColor: Color(0xFF2D1B69),
      keyColor: Color(0xFF4A3580),
      keyTextColor: Colors.white,
      actionKeyColor: Color(0xFF6B4EAE),
      keyBorderRadius: 16,
      horizontalGap: 8,
      verticalGap: 10,
    );

    return VirtualKeypadScope(
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1035),
        appBar: AppBar(
          title: const Text('Custom Theme'),
          backgroundColor: const Color(0xFF2D1B69),
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.palette, size: 64, color: Colors.purple),
                    const SizedBox(height: 24),
                    Text(
                      'Custom Styled Keyboard',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'VirtualKeypadTheme allows full customization',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 32),
                    VirtualKeypadTextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Type something',
                        labelStyle: const TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.purple),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.purpleAccent,
                            width: 2,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.edit,
                          color: Colors.purple,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF2D1B69),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            VirtualKeypad(theme: customTheme),
          ],
        ),
      ),
    );
  }
}
