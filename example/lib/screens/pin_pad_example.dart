import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

class PinPadExample extends StatefulWidget {
  const PinPadExample({super.key});

  @override
  State<PinPadExample> createState() => _PinPadExampleState();
}

class _PinPadExampleState extends State<PinPadExample>
    with TickerProviderStateMixin {
  final _controller = VirtualKeypadController();
  static const _pinLength = 4;
  bool _showSuccess = false;
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  late final AnimationController _lockController;

  static const _gradient = LinearGradient(
    colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

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

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _lockController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _controller.addListener(_onPinChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onPinChanged);
    _controller.dispose();
    _shakeController.dispose();
    _pulseController.dispose();
    _lockController.dispose();
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
          _lockController.forward(from: 0);
          setState(() => _showSuccess = true);
          Future.delayed(const Duration(seconds: 2), () {
            if (!mounted) return;
            _lockController.reverse();
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
          foregroundColor: Colors.white,
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: _gradient),
          ),
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
                      // Lock icon in gradient circle
                      AnimatedBuilder(
                        animation: _lockController,
                        builder: (context, _) {
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: _showSuccess
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF43A047),
                                        Color(0xFF66BB6A),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : _gradient,
                              boxShadow: [
                                BoxShadow(
                                  color: (_showSuccess
                                          ? const Color(0xFF43A047)
                                          : const Color(0xFFf5576c))
                                      .withValues(alpha: 0.45),
                                  blurRadius: 24,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 350),
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                              child: Icon(
                                _showSuccess
                                    ? Icons.lock_open_rounded
                                    : Icons.lock_rounded,
                                key: ValueKey(_showSuccess),
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // Title
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          _showSuccess ? 'Unlocked!' : 'Enter PIN',
                          key: ValueKey(_showSuccess),
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: _showSuccess
                                        ? const Color(0xFF43A047)
                                        : null,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          _showSuccess
                              ? 'Access granted'
                              : 'Enter your $_pinLength-digit PIN',
                          key: ValueKey<String>(
                            _showSuccess ? 'granted' : 'enter',
                          ),
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.45,
                            ),
                            fontSize: 13,
                          ),
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
                            final isActive =
                                index == enteredLength && !_showSuccess;
                            return _PinDot(
                              isFilled: isFilled,
                              isActive: isActive,
                              isSuccess: _showSuccess,
                              pulseAnimation: _pulseAnimation,
                              outlineColor: colorScheme.outline.withValues(
                                alpha: 0.35,
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

class _PinDot extends StatelessWidget {
  const _PinDot({
    required this.isFilled,
    required this.isActive,
    required this.isSuccess,
    required this.pulseAnimation,
    required this.outlineColor,
  });

  final bool isFilled;
  final bool isActive;
  final bool isSuccess;
  final Animation<double> pulseAnimation;
  final Color outlineColor;

  static const _dotGradient = LinearGradient(
    colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return AnimatedBuilder(
        animation: pulseAnimation,
        builder: (context, child) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFf5576c), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFFf093fb,
                  ).withValues(alpha: pulseAnimation.value),
                  blurRadius: 14,
                  spreadRadius: 2,
                ),
              ],
            ),
          );
        },
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(horizontal: 14),
      width: isFilled ? 22 : 18,
      height: isFilled ? 22 : 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isSuccess
            ? const LinearGradient(
                colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
              )
            : isFilled
                ? _dotGradient
                : null,
        border: isFilled || isSuccess
            ? null
            : Border.all(color: outlineColor, width: 2),
        boxShadow: isFilled && !isSuccess
            ? [
                BoxShadow(
                  color: const Color(0xFFf5576c).withValues(alpha: 0.4),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : isSuccess
                ? [
                    BoxShadow(
                      color: const Color(0xFF43A047).withValues(alpha: 0.4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
      ),
    );
  }
}
