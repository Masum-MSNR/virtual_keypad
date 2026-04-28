import 'package:flutter/material.dart';
import 'package:virtual_keypad_example/example_page_layout.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

class PasswordEntryExample extends StatefulWidget {
  const PasswordEntryExample({super.key});

  @override
  State<PasswordEntryExample> createState() => _PasswordEntryExampleState();
}

class _PasswordEntryExampleState extends State<PasswordEntryExample> {
  final _usernameController = VirtualKeypadController();
  final _passwordController = VirtualKeypadController();
  bool _obscureText = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  int get _passwordStrength {
    final text = _passwordController.text;
    if (text.isEmpty) return 0;
    var score = 0;
    if (text.length >= 4) score++;
    if (text.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(text)) score++;
    if (RegExp(r'[0-9]').hasMatch(text)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(text)) score++;
    return score.clamp(0, 5);
  }

  Color _strengthColor(int strength) {
    return switch (strength) {
      0 => Colors.transparent,
      1 => Colors.red,
      2 => Colors.orange,
      3 => Colors.amber,
      4 => const Color(0xFF66BB6A),
      _ => const Color(0xFF43A047),
    };
  }

  String _strengthLabel(int strength) {
    return switch (strength) {
      0 => '',
      1 => 'Very Weak',
      2 => 'Weak',
      3 => 'Fair',
      4 => 'Strong',
      _ => 'Very Strong',
    };
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const gradientColors = [Color(0xFF4facfe), Color(0xFF00f2fe)];
    const gradient = LinearGradient(
      colors: gradientColors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final strength = _passwordStrength;

    return VirtualKeypadScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Password Entry'),
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: Colors.white,
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: gradient),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ExampleScrollableContent(
                onTap: () => FocusScope.of(context).unfocus(),
                topPadding: 24,
                bottomPadding: 16,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Profile avatar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: gradient,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x404facfe),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Sign in to continue',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Username field
                    VirtualKeypadTextField(
                      controller: _usernameController,
                      keyboardType: KeyboardType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Username or Email',
                        hintText: 'john@example.com',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF4facfe),
                            width: 2,
                          ),
                        ),
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerLowest,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    VirtualKeypadTextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF4facfe),
                            width: 2,
                          ),
                        ),
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
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
                        filled: true,
                        fillColor: colorScheme.surfaceContainerLowest,
                      ),
                    ),

                    // Strength indicator (5 rounded bars)
                    if (_passwordController.text.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ...List.generate(5, (i) {
                            final active = i < strength;
                            return Expanded(
                              child: Container(
                                height: 5,
                                margin: EdgeInsets.only(right: i < 4 ? 6 : 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: active
                                      ? _strengthColor(strength)
                                      : colorScheme.outlineVariant.withValues(
                                          alpha: 0.3,
                                        ),
                                ),
                              ),
                            );
                          }),
                          const SizedBox(width: 12),
                          Text(
                            _strengthLabel(strength),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _strengthColor(strength),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF4facfe),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        ),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Sign in button with gradient
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x404facfe),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: FilledButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Signed in as ${_usernameController.text.isEmpty ? 'user' : _usernameController.text}',
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            VirtualKeypad(
              hideWhenUnfocused: true,
              enableEmojiKey: true,
            ),
          ],
        ),
      ),
    );
  }
}
