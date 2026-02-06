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
                      // Feature explanation card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primaryContainer
                                  .withValues(alpha: 0.25),
                              colorScheme.tertiaryContainer
                                  .withValues(alpha: 0.15),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.outlineVariant
                                .withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colorScheme.primary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.keyboard_hide_rounded,
                                size: 20,
                                color: colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'hideWhenUnfocused: true',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'monospace',
                                      fontSize: 13,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Keyboard auto-hides when no field is focused',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colorScheme.onSurface
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Live status indicator
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: _isAnyFocused
                              ? const Color(0xFF43A047)
                                  .withValues(alpha: 0.1)
                              : colorScheme.surfaceContainerHigh
                                  .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _isAnyFocused
                                ? const Color(0xFF43A047)
                                    .withValues(alpha: 0.3)
                                : colorScheme.outlineVariant
                                    .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isAnyFocused
                                    ? const Color(0xFF43A047)
                                    : colorScheme.outline
                                        .withValues(alpha: 0.4),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _isAnyFocused
                                  ? 'Keyboard visible — tap outside to dismiss'
                                  : 'Keyboard hidden — tap a field to show',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: _isAnyFocused
                                    ? const Color(0xFF43A047)
                                    : colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Editable fields section
                      _SectionLabel(
                        icon: Icons.edit_rounded,
                        label: 'Editable Fields',
                        colorScheme: colorScheme,
                      ),
                      const SizedBox(height: 12),
                      VirtualKeypadTextField(
                        controller: _field1,
                        onTap: _onFieldTapped,
                        decoration: InputDecoration(
                          labelText: 'Text Field',
                          hintText: 'Tap to show keyboard',
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
                              const Icon(Icons.text_fields_rounded),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerLowest,
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
                            borderRadius: BorderRadius.circular(14),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          prefixIcon: const Icon(Icons.numbers_rounded),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerLowest,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Read-only section
                      _SectionLabel(
                        icon: Icons.lock_outline_rounded,
                        label: 'Read-Only Field',
                        colorScheme: colorScheme,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tapping this field does not show the keyboard',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              colorScheme.onSurface.withValues(alpha: 0.45),
                        ),
                      ),
                      const SizedBox(height: 12),
                      VirtualKeypadTextField(
                        controller: _readOnlyField,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Read-Only',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          prefixIcon:
                              const Icon(Icons.lock_outline_rounded),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
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
    return Row(
      children: [
        Icon(icon, size: 16,
            color: colorScheme.onSurface.withValues(alpha: 0.6)),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
