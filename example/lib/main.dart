import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Keypad Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Virtual Keypad Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Password Entry'),
            subtitle: const Text('Text keyboard with obscured input'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PasswordEntryExample()),
            ),
          ),
          ListTile(
            title: const Text('Numeric Input'),
            subtitle: const Text('Number keypad for PIN or amounts'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NumericInputExample()),
            ),
          ),
          ListTile(
            title: const Text('Multiple Fields'),
            subtitle: const Text('Auto-focus between fields'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MultiFieldExample()),
            ),
          ),
          ListTile(
            title: const Text('Custom Theme'),
            subtitle: const Text('Dark themed keyboard'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CustomThemeExample()),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Password Entry Example
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
    return Scaffold(
      appBar: AppBar(title: const Text('Password Entry')),
      body: VirtualKeypadScope(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_outline, size: 64),
                    const SizedBox(height: 24),
                    const Text(
                      'Enter your password',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    VirtualKeypadTextField(
                      controller: _controller,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
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
                              content: Text('Password: ${_controller.text}'),
                            ),
                          );
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            VirtualKeypad(
              type: KeyboardType.text,
              height: 260,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Numeric Input Example
// =============================================================================

class NumericInputExample extends StatefulWidget {
  const NumericInputExample({super.key});

  @override
  State<NumericInputExample> createState() => _NumericInputExampleState();
}

class _NumericInputExampleState extends State<NumericInputExample> {
  final _controller = VirtualKeypadController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Numeric Input')),
      body: VirtualKeypadScope(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.pin_outlined, size: 64),
                    const SizedBox(height: 24),
                    const Text(
                      'Enter PIN',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    VirtualKeypadTextField(
                      controller: _controller,
                      obscureText: true,
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        letterSpacing: 16,
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            VirtualKeypad(
              type: KeyboardType.number,
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Multiple Fields Example
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
    return Scaffold(
      appBar: AppBar(title: const Text('Multiple Fields')),
      body: VirtualKeypadScope(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    VirtualKeypadTextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    VirtualKeypadTextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    VirtualKeypadTextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () {},
                      child: const Text('Create Account'),
                    ),
                  ],
                ),
              ),
            ),
            VirtualKeypad(height: 240),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Custom Theme Example
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
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        title: const Text('Custom Theme'),
        backgroundColor: const Color(0xFF2C2C2E),
        foregroundColor: Colors.white,
      ),
      body: VirtualKeypadScope(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.keyboard, size: 64, color: Colors.white54),
                    const SizedBox(height: 24),
                    const Text(
                      'Dark Theme Keyboard',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32),
                    VirtualKeypadTextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Type something...',
                        labelStyle: const TextStyle(color: Colors.white54),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[700]!),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            VirtualKeypad(
              type: KeyboardType.text,
              height: 260,
              theme: VirtualKeypadTheme.dark,
            ),
          ],
        ),
      ),
    );
  }
}
