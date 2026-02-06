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

  int get _filledCount {
    var count = 0;
    if (_nameController.text.isNotEmpty) count++;
    if (_emailController.text.isNotEmpty) count++;
    if (_passwordController.text.isNotEmpty) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return VirtualKeypadScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Multi-Field Form'),
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
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Progress bar
                      ListenableBuilder(
                        listenable: Listenable.merge([
                          _nameController,
                          _emailController,
                          _passwordController,
                        ]),
                        builder: (context, _) {
                          final filled = _filledCount;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Step $filled of 3',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    filled == 3 ? '✓ Ready' : 'In Progress',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: filled == 3
                                          ? const Color(0xFF43A047)
                                          : colorScheme.onSurface
                                              .withValues(alpha: 0.4),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: filled / 3,
                                  backgroundColor: colorScheme.outlineVariant
                                      .withValues(alpha: 0.25),
                                  color: filled == 3
                                      ? const Color(0xFF43A047)
                                      : colorScheme.primary,
                                  minHeight: 4,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'Create Account',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Fill in your details to get started',
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildField(
                        controller: _nameController,
                        stepNumber: '1',
                        label: 'Full Name',
                        hint: 'John Doe',
                        icon: Icons.person_outline_rounded,
                        keyboardType: KeyboardType.name,
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        controller: _emailController,
                        stepNumber: '2',
                        label: 'Email',
                        hint: 'john@example.com',
                        icon: Icons.email_outlined,
                        keyboardType: KeyboardType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        controller: _passwordController,
                        stepNumber: '3',
                        label: 'Password',
                        hint: 'Create a password',
                        icon: Icons.lock_outline_rounded,
                        keyboardType: KeyboardType.visiblePassword,
                        isPassword: true,
                      ),
                      const SizedBox(height: 28),

                      SizedBox(
                        height: 52,
                        child: ListenableBuilder(
                          listenable: Listenable.merge([
                            _nameController,
                            _emailController,
                            _passwordController,
                          ]),
                          builder: (context, _) {
                            final ready = _filledCount == 3;
                            return FilledButton(
                              onPressed: ready
                                  ? () {
                                      FocusScope.of(context).unfocus();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              const Icon(Icons.check_circle,
                                                  color: Colors.white,
                                                  size: 18),
                                              const SizedBox(width: 10),
                                              Text(
                                                'Welcome, ${_nameController.text}!',
                                              ),
                                            ],
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          backgroundColor:
                                              const Color(0xFF43A047),
                                        ),
                                      );
                                    }
                                  : null,
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
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

  Widget _buildField({
    required VirtualKeypadController controller,
    required String stepNumber,
    required String label,
    required String hint,
    required IconData icon,
    required KeyboardType keyboardType,
    bool isPassword = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 14),
          child: ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              final done = controller.text.isNotEmpty;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done
                      ? const Color(0xFF43A047)
                      : colorScheme.surfaceContainerHigh,
                  border: done
                      ? null
                      : Border.all(
                          color:
                              colorScheme.outlineVariant.withValues(alpha: 0.6),
                        ),
                ),
                child: Center(
                  child: done
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : Text(
                          stepNumber,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color:
                                colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: VirtualKeypadTextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: isPassword,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
              prefixIcon: Icon(icon),
              filled: true,
              fillColor: colorScheme.surfaceContainerLowest,
            ),
          ),
        ),
      ],
    );
  }
}
