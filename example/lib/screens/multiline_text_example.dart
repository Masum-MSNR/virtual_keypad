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

  @override
  Widget build(BuildContext context) {
    return VirtualKeypadScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Multiline Text'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _controller.clear(),
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
                    const Text(
                      'Text auto-scrolls as you type',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: VirtualKeypadTextField(
                        controller: _controller,
                        maxLines: null,
                        minLines: 5,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          hintText: 'Start typing...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListenableBuilder(
                      listenable: _controller,
                      builder: (context, _) {
                        return Text(
                          '${_controller.text.length} characters',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                          textAlign: TextAlign.end,
                        );
                      },
                    ),
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
