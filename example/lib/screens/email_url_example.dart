import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

class EmailUrlExample extends StatefulWidget {
  const EmailUrlExample({super.key});

  @override
  State<EmailUrlExample> createState() => _EmailUrlExampleState();
}

class _EmailUrlExampleState extends State<EmailUrlExample> {
  final _emailController = VirtualKeypadController();
  final _urlController = VirtualKeypadController();

  @override
  void dispose() {
    _emailController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String text) {
    if (text.isEmpty) return false;
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text);
  }

  bool _isValidUrl(String text) {
    if (text.isEmpty) return false;
    return text.contains('.') && text.length > 4;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return VirtualKeypadScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Email & URL'),
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                behavior: HitTestBehavior.opaque,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Explanation
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: colorScheme.primaryContainer
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              color: colorScheme.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'The keyboard adapts its layout based on input type — '
                                'showing relevant keys like @ . / :',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Email section
                      _InputSection(
                        icon: Icons.alternate_email_rounded,
                        iconColor: const Color(0xFF43e97b),
                        title: 'Email Address',
                        description:
                            'Shows @ and . on the primary keyboard row',
                        field: VirtualKeypadTextField(
                          controller: _emailController,
                          keyboardType: KeyboardType.emailAddress,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'user@example.com',
                            hintStyle: TextStyle(
                              color: colorScheme.onSurface
                                  .withValues(alpha: 0.25),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            prefixIcon:
                                const Icon(Icons.email_outlined),
                            suffixIcon:
                                _isValidEmail(_emailController.text)
                                    ? const Icon(Icons.check_circle,
                                        color: Color(0xFF43A047), size: 20)
                                    : null,
                            filled: true,
                            fillColor: colorScheme.surfaceContainerLowest,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // URL section
                      _InputSection(
                        icon: Icons.link_rounded,
                        iconColor: const Color(0xFF4facfe),
                        title: 'URL Input',
                        description:
                            'Shows /, :, and . with a Go action button',
                        field: VirtualKeypadTextField(
                          controller: _urlController,
                          keyboardType: KeyboardType.url,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            labelText: 'Website',
                            hintText: 'https://example.com',
                            hintStyle: TextStyle(
                              color: colorScheme.onSurface
                                  .withValues(alpha: 0.25),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            prefixIcon:
                                const Icon(Icons.language_rounded),
                            suffixIcon: _isValidUrl(_urlController.text)
                                ? const Icon(Icons.check_circle,
                                    color: Color(0xFF43A047), size: 20)
                                : null,
                            filled: true,
                            fillColor: colorScheme.surfaceContainerLowest,
                          ),
                          onSubmitted: (_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.open_in_browser,
                                        color: Colors.white, size: 18),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Opening ${_urlController.text}',
                                    ),
                                  ],
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
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

class _InputSection extends StatelessWidget {
  const _InputSection({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.field,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final Widget field;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        field,
      ],
    );
  }
}
