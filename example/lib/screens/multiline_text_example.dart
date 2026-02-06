import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

class MultilineTextExample extends StatefulWidget {
  const MultilineTextExample({super.key});

  @override
  State<MultilineTextExample> createState() => _MultilineTextExampleState();
}

class _MultilineTextExampleState extends State<MultilineTextExample> {
  final _controller = VirtualKeypadController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _wordCount(String text) {
    if (text.trim().isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }

  int _lineCount(String text) {
    if (text.isEmpty) return 0;
    return text.split('\n').length;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return VirtualKeypadScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Multiline Text'),
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.content_copy_rounded, size: 20),
              tooltip: 'Copy all',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Text copied!'),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, size: 20),
              tooltip: 'Clear all',
              onPressed: () => _controller.clear(),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Hint banner
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.tertiaryContainer
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            size: 16,
                            color: colorScheme.tertiary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Supports multiline input with auto-scroll as you type',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.55),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Text area
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadow.withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: VirtualKeypadTextField(
                          controller: _controller,
                          maxLines: null,
                          minLines: 5,
                          onChanged: (_) => setState(() {}),
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            hintText: 'Start writing your thoughts...',
                            hintStyle: TextStyle(
                              color: colorScheme.onSurface
                                  .withValues(alpha: 0.25),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: colorScheme.outlineVariant
                                    .withValues(alpha: 0.4),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: colorScheme.outlineVariant
                                    .withValues(alpha: 0.4),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: colorScheme.surfaceContainerLowest,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Stats bar
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            colorScheme.surfaceContainerHigh.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          _StatChip(
                            icon: Icons.text_fields_rounded,
                            label: '${_controller.text.length} chars',
                            color: colorScheme,
                          ),
                          const SizedBox(width: 16),
                          _StatChip(
                            icon: Icons.short_text_rounded,
                            label: '${_wordCount(_controller.text)} words',
                            color: colorScheme,
                          ),
                          const SizedBox(width: 16),
                          _StatChip(
                            icon: Icons.format_line_spacing_rounded,
                            label: '${_lineCount(_controller.text)} lines',
                            color: colorScheme,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
            VirtualKeypad(),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final ColorScheme color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color.onSurface.withValues(alpha: 0.4)),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: color.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}
