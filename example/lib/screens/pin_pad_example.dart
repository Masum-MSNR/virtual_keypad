import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

class PinPadExample extends StatefulWidget {
  const PinPadExample({super.key});

  @override
  State<PinPadExample> createState() => _PinPadExampleState();
}

class _PinPadExampleState extends State<PinPadExample>
    with SingleTickerProviderStateMixin {
  final _controller = VirtualKeypadController();
  static const _pinLength = 4;
  bool _showSuccess = false;
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  static final KeyboardLayout _pinLayout = [
    [
      VirtualKey.character(text: '1'),
      VirtualKey.character(text: '2'),
      VirtualKey.character(text: '3'),
    ],
    [
      VirtualKey.character(text: '4'),
      VirtualKey.character(text: '5'),
      VirtualKey.character(text: '6'),
    ],
    [
      VirtualKey.character(text: '7'),
      VirtualKey.character(text: '8'),
      VirtualKey.character(text: '9'),
    ],
    [
      VirtualKey.action(action: KeyAction.backSpace),
      VirtualKey.character(text: '0'),
      VirtualKey.action(action: KeyAction.done, label: '✓'),
    ],
  ];

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: -6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6, end: 4), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 4, end: 0), weight: 1),
    ]).animate(_shakeController);
    _controller.addListener(_onPinChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onPinChanged);
    _controller.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _onPinChanged() {
    setState(() {});

    if (_controller.text.length == _pinLength) {
      Future.delayed(const Duration(milliseconds: 250), () {
        if (!mounted) return;
        final pin = _controller.text;

        // Simulate: "1234" is correct, anything else shakes
        if (pin == '1234') {
          setState(() => _showSuccess = true);
          Future.delayed(const Duration(seconds: 2), () {
            if (!mounted) return;
            setState(() => _showSuccess = false);
            _controller.clear();
          });
        } else {
          _shakeController.forward(from: 0);
          Future.delayed(const Duration(milliseconds: 500), () {
            if (!mounted) return;
            _controller.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white, size: 18),
                  SizedBox(width: 10),
                  Text('Incorrect PIN — try 1234'),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red.shade600,
              duration: const Duration(seconds: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final enteredLength = _controller.text.length;

    return VirtualKeypadScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PIN Pad'),
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _showSuccess
                            ? Container(
                                key: const ValueKey('success'),
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF43A047)
                                      .withValues(alpha: 0.15),
                                ),
                                child: const Icon(
                                  Icons.check_circle_rounded,
                                  size: 40,
                                  color: Color(0xFF43A047),
                                ),
                              )
                            : Container(
                                key: const ValueKey('lock'),
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFFf093fb)
                                          .withValues(alpha: 0.2),
                                      const Color(0xFFf5576c)
                                          .withValues(alpha: 0.12),
                                    ],
                                  ),
                                ),
                                child: const Icon(
                                  Icons.lock_rounded,
                                  size: 36,
                                  color: Color(0xFFf093fb),
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),

                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          _showSuccess ? 'Unlocked!' : 'Enter PIN',
                          key: ValueKey(_showSuccess),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: _showSuccess
                                    ? const Color(0xFF43A047)
                                    : null,
                              ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _showSuccess
                            ? 'Access granted'
                            : 'Enter your $_pinLength-digit PIN (hint: 1234)',
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.45),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // PIN dots with shake
                      AnimatedBuilder(
                        animation: _shakeAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_shakeAnimation.value, 0),
                            child: child,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_pinLength, (index) {
                            final isFilled = index < enteredLength;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              width: isFilled ? 20 : 16,
                              height: isFilled ? 20 : 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _showSuccess
                                    ? const Color(0xFF43A047)
                                    : isFilled
                                        ? colorScheme.primary
                                        : Colors.transparent,
                                border: Border.all(
                                  color: _showSuccess
                                      ? const Color(0xFF43A047)
                                      : isFilled
                                          ? colorScheme.primary
                                          : colorScheme.outline
                                              .withValues(alpha: 0.35),
                                  width: 2,
                                ),
                                boxShadow: isFilled && !_showSuccess
                                    ? [
                                        BoxShadow(
                                          color: colorScheme.primary
                                              .withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : null,
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Hidden text field
                      SizedBox(
                        height: 0,
                        child: Opacity(
                          opacity: 0,
                          child: VirtualKeypadTextField(
                            controller: _controller,
                            maxLength: _pinLength,
                            autofocus: true,
                          ),
                        ),
                      ),

                      TextButton(
                        onPressed: () => _controller.clear(),
                        style: TextButton.styleFrom(
                          foregroundColor:
                              colorScheme.onSurface.withValues(alpha: 0.45),
                        ),
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            VirtualKeypad(
              type: KeyboardType.custom,
              customLayout: _pinLayout,
              height: 280,
            ),
          ],
        ),
      ),
    );
  }
}
