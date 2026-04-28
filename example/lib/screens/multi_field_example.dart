import 'package:flutter/material.dart';
import 'package:virtual_keypad_example/example_page_layout.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

const _kGradientStart = Color(0xFFfa709a);
const _kGradientEnd = Color(0xFFfee140);
const _kGreenComplete = Color(0xFF43A047);

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

  List<bool> get _stepsDone => [
    _nameController.text.isNotEmpty,
    _emailController.text.isNotEmpty,
    _passwordController.text.isNotEmpty,
  ];

  @override
  Widget build(BuildContext context) {
    return VirtualKeypadScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Multi-Field Form'),
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: Colors.white,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [_kGradientStart, _kGradientEnd],
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
                child: ListenableBuilder(
                  listenable: Listenable.merge([
                    _nameController,
                    _emailController,
                    _passwordController,
                  ]),
                  builder: (context, _) {
                    final filled = _filledCount;
                    final done = _stepsDone;
                    return ExampleScrollableContent(
                      topPadding: 20,
                      bottomPadding: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ── Progress dots ──
                          _ProgressDots(filled: filled),
                          const SizedBox(height: 28),

                          // ── Header ──
                          Text(
                            'Create Account',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Fill in your details to get started',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.55),
                                ),
                          ),
                          const SizedBox(height: 28),

                          // ── Stepper fields ──
                          _StepperColumn(
                            steps: [
                              _StepItem(
                                done: done[0],
                                stepNumber: '1',
                                isLast: false,
                                child: _buildField(
                                  controller: _nameController,
                                  label: 'Full Name',
                                  hint: 'John Doe',
                                  icon: Icons.person_outline_rounded,
                                  keyboardType: KeyboardType.name,
                                ),
                              ),
                              _StepItem(
                                done: done[1],
                                stepNumber: '2',
                                isLast: false,
                                child: _buildField(
                                  controller: _emailController,
                                  label: 'Email',
                                  hint: 'john@example.com',
                                  icon: Icons.email_outlined,
                                  keyboardType: KeyboardType.emailAddress,
                                ),
                              ),
                              _StepItem(
                                done: done[2],
                                stepNumber: '3',
                                isLast: true,
                                child: _buildField(
                                  controller: _passwordController,
                                  label: 'Password',
                                  hint: 'Create a password',
                                  icon: Icons.lock_outline_rounded,
                                  keyboardType: KeyboardType.visiblePassword,
                                  isPassword: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),

                          // ── Create Account button ──
                          _GradientButton(
                            enabled: filled == 3,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 10),
                                      Text('Welcome, ${_nameController.text}!'),
                                    ],
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: _kGreenComplete,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
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
    required String label,
    required String hint,
    required IconData icon,
    required KeyboardType keyboardType,
    bool isPassword = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return VirtualKeypadTextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kGradientStart, width: 2),
        ),
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}

// ─── Progress dots (3 circles connected by lines) ────────────────────────────

class _ProgressDots extends StatelessWidget {
  const _ProgressDots({required this.filled});
  final int filled;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(
      context,
    ).colorScheme.outlineVariant.withValues(alpha: 0.4);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 3; i++) ...[
          _Dot(active: i < filled),
          if (i < 2)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 36,
              height: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: i < filled - 1
                    ? _kGreenComplete
                    : (i < filled
                          ? _kGradientStart.withValues(alpha: 0.5)
                          : muted),
              ),
            ),
        ],
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(
      context,
    ).colorScheme.outlineVariant.withValues(alpha: 0.4);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: active ? 18 : 14,
      height: active ? 18 : 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? _kGreenComplete : Colors.transparent,
        border: active ? null : Border.all(color: muted, width: 2),
        boxShadow: active
            ? [
                BoxShadow(
                  color: _kGreenComplete.withValues(alpha: 0.35),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: active
          ? const Center(
              child: Icon(Icons.check, size: 11, color: Colors.white),
            )
          : null,
    );
  }
}

// ─── Vertical stepper column ─────────────────────────────────────────────────

class _StepperColumn extends StatelessWidget {
  const _StepperColumn({required this.steps});
  final List<_StepItem> steps;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: steps);
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.done,
    required this.stepNumber,
    required this.isLast,
    required this.child,
  });

  final bool done;
  final String stepNumber;
  final bool isLast;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circle + connector line
          SizedBox(
            width: 32,
            child: Column(
              children: [
                const SizedBox(height: 14),
                // Step circle
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: done
                        ? _kGreenComplete
                        : colorScheme.surfaceContainerHigh,
                    border: done
                        ? null
                        : Border.all(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.6,
                            ),
                          ),
                    boxShadow: done
                        ? [
                            BoxShadow(
                              color: _kGreenComplete.withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: done
                          ? const Icon(
                              Icons.check,
                              key: ValueKey('check'),
                              size: 14,
                              color: Colors.white,
                            )
                          : Text(
                              stepNumber,
                              key: ValueKey('num$stepNumber'),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                // Connector line
                if (!isLast)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: CustomPaint(
                        painter: _DottedLinePainter(
                          color: done
                              ? _kGreenComplete.withValues(alpha: 0.5)
                              : colorScheme.outlineVariant.withValues(
                                  alpha: 0.35,
                                ),
                        ),
                        child: const SizedBox(width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Field
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Dotted line painter ─────────────────────────────────────────────────────

class _DottedLinePainter extends CustomPainter {
  _DottedLinePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const dashHeight = 4.0;
    const gap = 4.0;
    final centerX = size.width / 2;
    var y = 0.0;

    while (y < size.height) {
      canvas.drawLine(
        Offset(centerX, y),
        Offset(centerX, y + dashHeight),
        paint,
      );
      y += dashHeight + gap;
    }
  }

  @override
  bool shouldRepaint(_DottedLinePainter old) => old.color != color;
}

// ─── Gradient "Create Account" button ────────────────────────────────────────

class _GradientButton extends StatelessWidget {
  const _GradientButton({required this.enabled, required this.onPressed});
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: enabled ? 1.0 : 0.45,
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [_kGradientStart, _kGradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: _kGradientStart.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: MaterialButton(
            onPressed: enabled ? onPressed : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            splashColor: Colors.white24,
            highlightColor: Colors.white10,
            child: const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
