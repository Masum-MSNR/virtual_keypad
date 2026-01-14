import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

void main() {
  runApp(const VirtualKeypadExampleApp());
}

class VirtualKeypadExampleApp extends StatelessWidget {
  const VirtualKeypadExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Keypad Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Virtual Keypad Examples'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ExampleCard(
            title: 'Password Entry',
            subtitle: 'Secure PIN/password input with virtual keyboard',
            icon: Icons.lock_outline,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PasswordEntryExample()),
            ),
          ),
          _ExampleCard(
            title: 'Numeric Input',
            subtitle: 'Number pad for numeric input only',
            icon: Icons.dialpad,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NumericInputExample()),
            ),
          ),
          _ExampleCard(
            title: 'Multi-Field Form',
            subtitle: 'Multiple text fields with shared keyboard',
            icon: Icons.article_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MultiFieldExample()),
            ),
          ),
          _ExampleCard(
            title: 'Custom Theme',
            subtitle: 'Customized keyboard appearance',
            icon: Icons.palette_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CustomThemeExample()),
            ),
          ),
          _ExampleCard(
            title: 'Multiline Text',
            subtitle: 'Multi-line text area with auto-scroll',
            icon: Icons.notes_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MultilineTextExample()),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

// =============================================================================
// Example 1: Password Entry
// =============================================================================
class PasswordEntryExample extends StatefulWidget {
  const PasswordEntryExample({super.key});

  @override
  State<PasswordEntryExample> createState() => _PasswordEntryExampleState();
}

class _PasswordEntryExampleState extends State<PasswordEntryExample> {
  final _controller = VirtualKeypadController();
  bool _obscureText = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VirtualKeypadScope(
      child: Scaffold(
        appBar: AppBar(title: const Text('Password Entry')),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock, size: 64, color: Colors.grey),
                    const SizedBox(height: 24),
                    Text(
                      'Enter Your Password',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Use the virtual keyboard below',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    VirtualKeypadTextField(
                      controller: _controller,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() => _obscureText = !_obscureText);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Password entered: ${_controller.text}',
                              ),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('Submit'),
                        ),
                      ),
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

// =============================================================================
// Example 2: Numeric Input
// =============================================================================
class NumericInputExample extends StatefulWidget {
  const NumericInputExample({super.key});

  @override
  State<NumericInputExample> createState() => _NumericInputExampleState();
}

class _NumericInputExampleState extends State<NumericInputExample> {
  final _amountController = VirtualKeypadController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VirtualKeypadScope(
      child: Scaffold(
        appBar: AppBar(title: const Text('Numeric Input')),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.attach_money,
                      size: 64,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Enter Amount',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 32),
                    VirtualKeypadTextField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                        prefixText: '\$ ',
                      ),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      allowPhysicalKeyboard: true,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () => _amountController.clear(),
                          child: const Text('Clear'),
                        ),
                        FilledButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Amount: \$${_amountController.text}',
                                ),
                              ),
                            );
                          },
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            VirtualKeypad(
              type: KeyboardType.number,
              theme: VirtualKeypadTheme.light,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Example 3: Multi-Field Form
// =============================================================================
class MultiFieldExample extends StatefulWidget {
  const MultiFieldExample({super.key});

  @override
  State<MultiFieldExample> createState() => _MultiFieldExampleState();
}

class _MultiFieldExampleState extends State<MultiFieldExample> {
  final _usernameController = VirtualKeypadController();
  final _emailController = VirtualKeypadController();
  final _passwordController = VirtualKeypadController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VirtualKeypadScope(
      child: Scaffold(
        appBar: AppBar(title: const Text('Multi-Field Form')),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Create Account',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap a field to activate it, then use the virtual keyboard',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    VirtualKeypadTextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 16),
                    VirtualKeypadTextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    VirtualKeypadTextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Username: ${_usernameController.text}, '
                              'Email: ${_emailController.text}',
                            ),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('Create Account'),
                      ),
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

// =============================================================================
// Example 4: Custom Theme
// =============================================================================
class CustomThemeExample extends StatefulWidget {
  const CustomThemeExample({super.key});

  @override
  State<CustomThemeExample> createState() => _CustomThemeExampleState();
}

class _CustomThemeExampleState extends State<CustomThemeExample> {
  final _controller = VirtualKeypadController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Custom purple theme
    const customTheme = VirtualKeypadTheme(
      backgroundColor: Color(0xFF2D1B69),
      keyColor: Color(0xFF4A3580),
      keyTextColor: Colors.white,
      actionKeyColor: Color(0xFF6B4EAE),
      keyBorderRadius: 16,
      horizontalGap: 8,
      verticalGap: 10,
    );

    return VirtualKeypadScope(
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1035),
        appBar: AppBar(
          title: const Text('Custom Theme'),
          backgroundColor: const Color(0xFF2D1B69),
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.palette, size: 64, color: Colors.purple),
                    const SizedBox(height: 24),
                    Text(
                      'Custom Styled Keyboard',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'VirtualKeypadTheme allows full customization',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 32),
                    VirtualKeypadTextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Type something',
                        labelStyle: const TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.purple),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.purpleAccent,
                            width: 2,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.edit,
                          color: Colors.purple,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF2D1B69),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            VirtualKeypad(theme: customTheme),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Example 5: Multiline Text
// =============================================================================
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
