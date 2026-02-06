import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

class NumericInputExample extends StatefulWidget {
  const NumericInputExample({super.key});

  @override
  State<NumericInputExample> createState() => _NumericInputExampleState();
}

class _NumericInputExampleState extends State<NumericInputExample> {
  final _controller = VirtualKeypadController();

  static const _quickAmounts = ['10', '25', '50', '100', '500'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setAmount(String amount) {
    _controller.clear();
    _controller.insertText(amount);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return VirtualKeypadScope(
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: const Text('Numeric Input'),
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon badge
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF667eea).withValues(alpha: 0.2),
                              const Color(0xFF764ba2).withValues(alpha: 0.12),
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 36,
                          color: Color(0xFF667eea),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Enter Amount',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'How much would you like to add?',
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Amount display field
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: colorScheme.surfaceContainerLowest,
                          border: Border.all(
                            color:
                                colorScheme.outlineVariant.withValues(alpha: 0.4),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadow.withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: VirtualKeypadTextField(
                          controller: _controller,
                          keyboardType: KeyboardType.number,
                          decoration: InputDecoration(
                            prefixText: '\$ ',
                            prefixStyle: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: colorScheme.primary,
                            ),
                            hintText: '0.00',
                            hintStyle: TextStyle(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.2),
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Quick amount chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: _quickAmounts.map((amount) {
                          return ActionChip(
                            label: Text(
                              '\$$amount',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                            backgroundColor: colorScheme.primaryContainer
                                .withValues(alpha: 0.3),
                            side: BorderSide(
                              color: colorScheme.primary.withValues(alpha: 0.15),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onPressed: () => _setAmount(amount),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),

                      // Clear button
                      TextButton.icon(
                        onPressed: () => _controller.clear(),
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: const Text('Clear'),
                        style: TextButton.styleFrom(
                          foregroundColor:
                              colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            VirtualKeypad(
              type: KeyboardType.number,
              height: 260,
            ),
          ],
        ),
      ),
    );
  }
}
