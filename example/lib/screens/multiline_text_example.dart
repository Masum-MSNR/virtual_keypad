import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

/// Example: Multiline Text
/// 
/// Demonstrates multi-line text area with auto-scroll.
class MultilineTextExample extends StatefulWidget {
  const MultilineTextExample({super.key});

  @override
  State<MultilineTextExample> createState() => _MultilineTextExampleState();
}

class _MultilineTextExampleState extends State<MultilineTextExample> {
  final _notesController = VirtualKeypadController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VirtualKeypadScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Multiline Text'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _notesController.clear(),
              tooltip: 'Clear',
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Write Your Notes',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Text will auto-scroll as you type',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: VirtualKeypadTextField(
                        controller: _notesController,
                        maxLines: null, // Unlimited lines
                        minLines: 5,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          hintText: 'Start typing here...',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListenableBuilder(
                      listenable: _notesController,
                      builder: (context, _) {
                        final charCount = _notesController.text.length;
                        final lineCount =
                            '\n'.allMatches(_notesController.text).length + 1;
                        return Text(
                          '$charCount characters • $lineCount lines',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.end,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            VirtualKeypad(theme: VirtualKeypadTheme.light),
          ],
        ),
      ),
    );
  }
}
