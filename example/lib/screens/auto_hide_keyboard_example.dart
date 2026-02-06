import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

class AutoHideKeyboardExample extends StatefulWidget {
  const AutoHideKeyboardExample({super.key});

  @override
  State<AutoHideKeyboardExample> createState() =>
      _AutoHideKeyboardExampleState();
}

class _AutoHideKeyboardExampleState extends State<AutoHideKeyboardExample> {
  final _field1 = VirtualKeypadController();
  final _field2 = VirtualKeypadController();
  final _readOnlyField = VirtualKeypadController(text: 'Read-only content');
  bool _isAnyFocused = false;

  @override
  void dispose() {
    _field1.dispose();
    _field2.dispose();
    _readOnlyField.dispose();
    super.dispose();
  }

  void _onFieldTapped() {
    setState(() => _isAnyFocused = true);
  }

  void _onTapOutside() {
    FocusScope.of(context).unfocus();
    setState(() => _isAnyFocused = false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return VirtualKeypadScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Auto-Hide Keyboard'),
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: Colors.white,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF30cfd0), Color(0xFF330867)],
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
                onTap: _onTapOutside,
                behavior: HitTestBehavior.opaque,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Live status indicator — card with gradient left border
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: (_isAnyFocused
                                      ? const Color(0xFF30cfd0)
                                      : colorScheme.shadow)
                                  .withValues(alpha: 0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          border: Border.all(
                            color: colorScheme.outlineVariant
                                .withValues(alpha: 0.1),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: _isAnyFocused
                                      ? const Color(0xFF30cfd0)
                                      : colorScheme.outlineVariant
                                          .withValues(alpha: 0.4),
                                  width: 4,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 300),
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _isAnyFocused
                                        ? const Color(0xFF30cfd0)
                                        : colorScheme.outline
                                            .withValues(alpha: 0.35),
                                    boxShadow: _isAnyFocused
                                        ? [
                                            BoxShadow(
                                              color: const Color(0xFF30cfd0)
                                                  .withValues(alpha: 0.5),
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                            ),
                                          ]
                                        : [],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _isAnyFocused
                                            ? 'Keyboard Visible'
                                            : 'Keyboard Hidden',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: _isAnyFocused
                                              ? const Color(0xFF30cfd0)
                                              : colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _isAnyFocused
                                            ? 'Tap outside to dismiss'
                                            : 'Tap a field to show',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: colorScheme.onSurface
                                              .withValues(alpha: 0.45),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                AnimatedSwitcher(
                                  duration:
                                      const Duration(milliseconds: 300),
                                  child: Icon(
                                    _isAnyFocused
                                        ? Icons.keyboard_rounded
                                        : Icons.keyboard_hide_rounded,
                                    key: ValueKey(_isAnyFocused),
                                    color: _isAnyFocused
                                        ? const Color(0xFF30cfd0)
                                        : colorScheme.outline
                                            .withValues(alpha: 0.35),
                                    size: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Editable fields section
                      _SectionLabel(
                        icon: Icons.edit_rounded,
                        label: 'Editable Fields',
                        colorScheme: colorScheme,
                      ),
                      const SizedBox(height: 14),
                      VirtualKeypadTextField(
                        controller: _field1,
                        onTap: _onFieldTapped,
                        decoration: InputDecoration(
                          labelText: 'Text Field',
                          hintText: 'Tap to show keyboard',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF30cfd0),
                              width: 2,
                            ),
                          ),
                          prefixIcon:
                              const Icon(Icons.text_fields_rounded),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerLowest,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      VirtualKeypadTextField(
                        controller: _field2,
                        onTap: _onFieldTapped,
                        keyboardType: KeyboardType.number,
                        decoration: InputDecoration(
                          labelText: 'Number Field',
                          hintText: 'Shows number pad',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF30cfd0),
                              width: 2,
                            ),
                          ),
                          prefixIcon: const Icon(Icons.numbers_rounded),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerLowest,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Read-only section
                      _SectionLabel(
                        icon: Icons.lock_outline_rounded,
                        label: 'Read-Only Field',
                        colorScheme: colorScheme,
                      ),
                      const SizedBox(height: 14),
                      VirtualKeypadTextField(
                        controller: _readOnlyField,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Read-Only',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon:
                              const Icon(Icons.lock_outline_rounded),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.icon,
    required this.label,
    required this.colorScheme,
  });

  final IconData icon;
  final String label;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(icon, size: 18,
                color: colorScheme.onSurface.withValues(alpha: 0.7)),
            const SizedBox(width: 8),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                letterSpacing: 0.8,
                color: colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          width: 32,
          height: 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: const LinearGradient(
              colors: [Color(0xFF30cfd0), Color(0xFF330867)],
            ),
          ),
        ),
      ],
    );
  }
}
