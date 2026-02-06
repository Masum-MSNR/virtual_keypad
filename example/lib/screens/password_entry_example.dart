import 'package:flutter/material.dart';
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

    return VirtualKeypadScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Password Entry'),
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
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF4facfe).withValues(alpha: 0.2),
                                const Color(0xFF00f2fe).withValues(alpha: 0.12),
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.shield_rounded,
                            size: 36,
                            color: Color(0xFF4facfe),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Welcome Back',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sign in to your account',
                          style: TextStyle(
                            color:
                                colorScheme.onSurface.withValues(alpha: 0.5),
                            fontSize: 14,
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
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            prefixIcon:
                                const Icon(Icons.person_outline_rounded),
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
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            prefixIcon:
                                const Icon(Icons.lock_outline_rounded),
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

                        // Strength indicator
                        if (_passwordController.text.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: _passwordStrength / 5,
                                    backgroundColor: colorScheme.outlineVariant
                                        .withValues(alpha: 0.3),
                                    color:
                                        _strengthColor(_passwordStrength),
                                    minHeight: 4,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _strengthLabel(_passwordStrength),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      _strengthColor(_passwordStrength),
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
                              foregroundColor: colorScheme.primary,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                            ),
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Sign in button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
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
