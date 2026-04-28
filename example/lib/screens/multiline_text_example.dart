import 'package:flutter/material.dart';
import 'package:virtual_keypad_example/example_page_layout.dart';
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
    final isEmpty = _controller.text.isEmpty;

    return VirtualKeypadScope(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F7FC),
        appBar: AppBar(
          title: const Text(
            'Note Editor',
            style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.3),
          ),
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: Colors.white,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFa18cd1), Color(0xFFfbc2eb)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
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
              child: ExampleConstrainedContent(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Text area
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDFCFF),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.25,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFa18cd1,
                              ).withValues(alpha: 0.06),
                              blurRadius: 24,
                              offset: const Offset(0, 6),
                            ),
                            BoxShadow(
                              color: colorScheme.shadow.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Empty-state illustration
                            if (isEmpty)
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.edit_note_rounded,
                                      size: 48,
                                      color: const Color(
                                        0xFFa18cd1,
                                      ).withValues(alpha: 0.25),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Start writing...',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: colorScheme.onSurface.withValues(
                                          alpha: 0.2,
                                        ),
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // Input field
                            VirtualKeypadTextField(
                              controller: _controller,
                              maxLines: null,
                              minLines: 5,
                              onChanged: (_) => setState(() {}),
                              textAlignVertical: TextAlignVertical.top,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.6,
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.85,
                                ),
                              ),
                              decoration: InputDecoration(
                                hintText: '',
                                contentPadding: const EdgeInsets.all(20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFa18cd1),
                                    width: 1.8,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Stats pills
                    Row(
                      children: [
                        _StatChip(
                          icon: Icons.text_fields_rounded,
                          value: '${_controller.text.length}',
                          label: 'chars',
                          backgroundColor: const Color(
                            0xFFa18cd1,
                          ).withValues(alpha: 0.10),
                          iconColor: const Color(0xFFa18cd1),
                        ),
                        const SizedBox(width: 10),
                        _StatChip(
                          icon: Icons.short_text_rounded,
                          value: '${_wordCount(_controller.text)}',
                          label: 'words',
                          backgroundColor: const Color(
                            0xFFfbc2eb,
                          ).withValues(alpha: 0.18),
                          iconColor: const Color(0xFFc97db8),
                        ),
                        const SizedBox(width: 10),
                        _StatChip(
                          icon: Icons.format_line_spacing_rounded,
                          value: '${_lineCount(_controller.text)}',
                          label: 'lines',
                          backgroundColor: const Color(
                            0xFF90CAF9,
                          ).withValues(alpha: 0.18),
                          iconColor: const Color(0xFF5C9CE6),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
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
    required this.value,
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: iconColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
