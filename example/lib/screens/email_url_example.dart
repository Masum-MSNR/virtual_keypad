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
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: const Text('Email & URL'),
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: Colors.white,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                behavior: HitTestBehavior.opaque,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Email section
                      _InputCard(
                        icon: Icons.alternate_email_rounded,
                        gradientColors: const [
                          Color(0xFF43e97b),
                          Color(0xFF38f9d7),
                        ],
                        title: 'Email Address',
                        description:
                            'Shows @ and . on the primary keyboard row',
                        isValid: _isValidEmail(_emailController.text),
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
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Color(0xFF43e97b),
                                width: 2,
                              ),
                            ),
                            prefixIcon: const Icon(Icons.email_outlined),
                            suffixIcon:
                                _isValidEmail(_emailController.text)
                                    ? const _AnimatedCheckmark()
                                    : null,
                            filled: true,
                            fillColor: colorScheme.surfaceContainerLowest,
                          ),
                        ),
                      ),

                      // Separator
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      colorScheme.outlineVariant
                                          .withValues(alpha: 0.4),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: Icon(
                                Icons.more_horiz_rounded,
                                size: 18,
                                color: colorScheme.outlineVariant
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      colorScheme.outlineVariant
                                          .withValues(alpha: 0.4),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // URL section
                      _InputCard(
                        icon: Icons.link_rounded,
                        gradientColors: const [
                          Color(0xFF4facfe),
                          Color(0xFF00f2fe),
                        ],
                        title: 'URL Input',
                        description:
                            'Shows /, :, and . with a Go action button',
                        isValid: _isValidUrl(_urlController.text),
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
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Color(0xFF4facfe),
                                width: 2,
                              ),
                            ),
                            prefixIcon: const Icon(Icons.language_rounded),
                            suffixIcon: _isValidUrl(_urlController.text)
                                ? const _AnimatedCheckmark()
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

/// A card-style input section with gradient icon circle and validity indicator.
class _InputCard extends StatelessWidget {
  const _InputCard({
    required this.icon,
    required this.gradientColors,
    required this.title,
    required this.description,
    required this.field,
    required this.isValid,
  });

  final IconData icon;
  final List<Color> gradientColors;
  final String title;
  final String description;
  final Widget field;
  final bool isValid;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Gradient circle icon
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: gradientColors.first.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(icon, size: 20, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
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
            const SizedBox(height: 16),
            field,
          ],
        ),
      ),
    );
  }
}

/// Animated green checkmark with a subtle glow.
class _AnimatedCheckmark extends StatefulWidget {
  const _AnimatedCheckmark();

  @override
  State<_AnimatedCheckmark> createState() => _AnimatedCheckmarkState();
}

class _AnimatedCheckmarkState extends State<_AnimatedCheckmark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scale = CurvedAnimation(parent: _anim, curve: Curves.elasticOut);
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        margin: const EdgeInsets.all(10),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF43e97b).withValues(alpha: 0.4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }
}
