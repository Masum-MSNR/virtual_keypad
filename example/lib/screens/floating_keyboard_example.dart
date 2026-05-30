import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:virtual_keypad/virtual_keypad.dart';

class FloatingKeyboardExample extends StatefulWidget {
  const FloatingKeyboardExample({super.key});

  @override
  State<FloatingKeyboardExample> createState() =>
      _FloatingKeyboardExampleState();
}

enum _FloatingDemoMode { standalone, scoped }

enum _FloatingVisibilityMode { onDemand, persistent }

enum _FloatingSizePreset { compact, regular, landscape }

enum _FloatingThemePreset { light, dark, ocean }

enum _FloatingCornerPreset { nonRound, lessRound, round }

class _FloatingKeyboardExampleState extends State<FloatingKeyboardExample> {
  final _persistentController = VirtualKeypadFloatingController();

  final _standaloneSearchController = TextEditingController();
  final _standalonePhoneController = TextEditingController();
  final _standaloneNotesController = TextEditingController();

  final _scopedLookupController = VirtualKeypadController();
  final _scopedAmountController = VirtualKeypadController(text: '1250');
  final _scopedApprovalController = VirtualKeypadController();

  _FloatingDemoMode _mode = _FloatingDemoMode.standalone;
  _FloatingVisibilityMode _visibilityMode = _FloatingVisibilityMode.onDemand;
  _FloatingSizePreset _sizePreset = _FloatingSizePreset.regular;
  _FloatingThemePreset _themePreset = _FloatingThemePreset.light;
  _FloatingCornerPreset _cornerPreset = _FloatingCornerPreset.round;
  String _lastEvent =
      'Focus a field, then tap the emoji key to open the full picker';

  @override
  void dispose() {
    _persistentController.dispose();
    _standaloneSearchController.dispose();
    _standalonePhoneController.dispose();
    _standaloneNotesController.dispose();
    _scopedLookupController.dispose();
    _scopedAmountController.dispose();
    _scopedApprovalController.dispose();
    super.dispose();
  }

  void _updateEvent(String message) {
    if (!mounted) return;
    setState(() => _lastEvent = message);
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF0ba360);
    const accentEnd = Color(0xFF3cba92);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Floating Keyboard'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [accent, accentEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: _mode == _FloatingDemoMode.standalone
              ? _buildStandaloneDemo(context)
              : _buildScopedDemo(context),
        ),
      ),
    );
  }

  Widget _buildStandaloneDemo(BuildContext context) {
    final keyboardWidth = _keyboardWidth(context);
    final keyboardHeight = _keyboardHeight(context);

    return VirtualKeypadFloating(
      key: const ValueKey('floating-standalone-demo'),
      standalone: true,
      enableEmojiKey: true,
      controller: _isPersistent ? _persistentController : null,
      visibilityMode: _floatingVisibilityMode,
      width: keyboardWidth,
      height: keyboardHeight,
      borderRadius: _panelRadius,
      initialAlignment: Alignment.bottomCenter,
      theme: _floatingTheme,
      availableLanguages: const ['en', 'bn', 'fr'],
      initialLanguage: 'en',
      onStandaloneInputAction: (action, text) {
        _updateEvent('Standalone action: ${action.name} -> "$text"');
      },
      onLanguageChanged: (code) {
        _updateEvent('Language switched to $code');
      },
      child: _buildDemoScrollBody(
        context,
        title: 'Standalone Demo',
        description:
            'Regular Flutter TextFields with text, phone, and notes input. Tap the emoji key for the full scrollable picker, and long-press the space bar to change language.',
        keyboardHeight: keyboardHeight,
        formTitle: 'Try It',
        formSubtitle:
            'Use the same floating keyboard with standard Flutter fields, including the upgraded emoji browser.',
        fields: [
          TextField(
            controller: _standaloneSearchController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            decoration: _fieldDecoration(
              Theme.of(context).colorScheme,
              label: 'Search',
              hint: 'Search products or SKUs',
              icon: Icons.search_rounded,
            ),
            onTap: () => _updateEvent('Search field focused'),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _standalonePhoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            decoration: _fieldDecoration(
              Theme.of(context).colorScheme,
              label: 'Phone',
              hint: 'Enter a support number',
              icon: Icons.phone_in_talk_outlined,
            ),
            onTap: () => _updateEvent('Phone field focused'),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _standaloneNotesController,
            keyboardType: TextInputType.multiline,
            minLines: 4,
            maxLines: 6,
            textInputAction: TextInputAction.newline,
            decoration: _fieldDecoration(
              Theme.of(context).colorScheme,
              label: 'Notes',
              hint: 'Write notes or try multilingual input',
              icon: Icons.edit_note_rounded,
              alignLabelWithHint: true,
            ),
            onTap: () => _updateEvent('Notes field focused'),
          ),
        ],
      ),
    );
  }

  Widget _buildScopedDemo(BuildContext context) {
    final keyboardWidth = _keyboardWidth(context);
    final keyboardHeight = _keyboardHeight(context);

    return VirtualKeypadScope(
      key: const ValueKey('floating-scoped-demo'),
      child: VirtualKeypadFloating(
        enableEmojiKey: true,
        controller: _isPersistent ? _persistentController : null,
        visibilityMode: _floatingVisibilityMode,
        width: keyboardWidth,
        height: keyboardHeight,
        borderRadius: _panelRadius,
        initialAlignment: Alignment.bottomCenter,
        theme: _floatingTheme,
        child: _buildDemoScrollBody(
          context,
          title: 'Scoped Demo',
          description:
              'VirtualKeypadScope and VirtualKeypadTextField stay unchanged. This mode also exposes emoji search, categories, and the flat scrollable picker.',
          keyboardHeight: keyboardHeight,
          formTitle: 'Try It',
          formSubtitle:
              'Use lookup, amount, and approval fields with the scoped API and the searchable emoji picker.',
          fields: [
            VirtualKeypadTextField(
              controller: _scopedLookupController,
              keyboardType: KeyboardType.text,
              textInputAction: TextInputAction.search,
              onTap: () => _updateEvent('Order lookup field focused'),
              onInputAction: (action, text) {
                _updateEvent('Scoped action: ${action.name} -> "$text"');
              },
              decoration: _fieldDecoration(
                Theme.of(context).colorScheme,
                label: 'Order Lookup',
                hint: 'Search by order number or customer',
                icon: Icons.manage_search_rounded,
              ),
            ),
            const SizedBox(height: 14),
            VirtualKeypadTextField(
              controller: _scopedAmountController,
              keyboardType: KeyboardType.numberDecimal,
              textInputAction: TextInputAction.done,
              onTap: () => _updateEvent('Amount field focused'),
              decoration: _fieldDecoration(
                Theme.of(context).colorScheme,
                label: 'Adjustment Amount',
                hint: 'Enter a numeric adjustment',
                icon: Icons.payments_outlined,
              ),
            ),
            const SizedBox(height: 14),
            VirtualKeypadTextField(
              controller: _scopedApprovalController,
              keyboardType: KeyboardType.number,
              textInputAction: TextInputAction.done,
              maxLength: 6,
              obscureText: true,
              onTap: () => _updateEvent('Approval code field focused'),
              decoration: _fieldDecoration(
                Theme.of(context).colorScheme,
                label: 'Approval Code',
                hint: 'Enter a six-digit manager code',
                icon: Icons.admin_panel_settings_outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoScrollBody(
    BuildContext context, {
    required String title,
    required String description,
    required double keyboardHeight,
    required String formTitle,
    required String formSubtitle,
    required List<Widget> fields,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 600;
        final horizontalPadding = isCompact ? 16.0 : 24.0;
        final topPadding = isCompact ? 16.0 : 20.0;
        final bottomPadding = keyboardHeight + (isCompact ? 88.0 : 110.0);

        return SingleChildScrollView(
          key: ValueKey('demo-scroll-$title'),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            topPadding,
            horizontalPadding,
            bottomPadding,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PanelCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF0ba360),
                                    Color(0xFF3cba92),
                                  ],
                                ),
                              ),
                              child: const Icon(
                                Icons.open_with_rounded,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      height: 1.4,
                                      color: colorScheme.onSurface.withValues(
                                        alpha: 0.76,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Current: ${_modeLabel(_mode)} · ${_visibilityLabel(_visibilityMode)} · ${_sizeLabel(_sizePreset)} · ${_themeLabel(_themePreset)} · ${_cornerLabel(_cornerPreset)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.72,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Last event: $_lastEvent',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _PanelCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Settings',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Kept minimal for small screens: mode, behavior, size, and theme.',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.72,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildSettingsLayout(context),
                        if (_isPersistent) ...[
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              FilledButton.icon(
                                onPressed: () {
                                  _persistentController.show();
                                  _updateEvent('Persistent keyboard shown');
                                },
                                icon: const Icon(Icons.visibility_rounded),
                                label: const Text('Show'),
                              ),
                              OutlinedButton.icon(
                                onPressed: () {
                                  _persistentController.hide();
                                  _updateEvent('Persistent keyboard hidden');
                                },
                                icon: const Icon(Icons.visibility_off_rounded),
                                label: const Text('Hide'),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _PanelCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          formTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          formSubtitle,
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.72,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        ...fields,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsLayout(BuildContext context) {
    final sections = [
      _ChoiceSection<_FloatingDemoMode>(
        title: 'Mode',
        selected: _mode,
        options: const [
          _ChoiceOption(
            value: _FloatingDemoMode.standalone,
            label: 'Standalone',
            icon: Icons.bolt_rounded,
          ),
          _ChoiceOption(
            value: _FloatingDemoMode.scoped,
            label: 'Scoped',
            icon: Icons.account_tree_outlined,
          ),
        ],
        onSelected: (value) {
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() {
            _mode = value;
            _lastEvent = '${_modeLabel(value)} mode selected';
          });
        },
      ),
      _ChoiceSection<_FloatingVisibilityMode>(
        title: 'Visibility',
        selected: _visibilityMode,
        options: const [
          _ChoiceOption(
            value: _FloatingVisibilityMode.onDemand,
            label: 'On Demand',
            icon: Icons.auto_mode_rounded,
          ),
          _ChoiceOption(
            value: _FloatingVisibilityMode.persistent,
            label: 'Persistent',
            icon: Icons.push_pin_rounded,
          ),
        ],
        onSelected: (value) {
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() {
            _visibilityMode = value;
            if (value == _FloatingVisibilityMode.onDemand) {
              _persistentController.hide();
            }
            _lastEvent = '${_visibilityLabel(value)} visibility selected';
          });
        },
      ),
      _ChoiceSection<_FloatingSizePreset>(
        title: 'Size',
        selected: _sizePreset,
        options: const [
          _ChoiceOption(
            value: _FloatingSizePreset.compact,
            label: 'Compact',
            icon: Icons.fit_screen_outlined,
          ),
          _ChoiceOption(
            value: _FloatingSizePreset.regular,
            label: 'Regular',
            icon: Icons.crop_16_9_rounded,
          ),
          _ChoiceOption(
            value: _FloatingSizePreset.landscape,
            label: 'Landscape',
            icon: Icons.view_week_rounded,
          ),
        ],
        onSelected: (value) {
          setState(() {
            _sizePreset = value;
            _lastEvent = '${_sizeLabel(value)} size selected';
          });
        },
      ),
      _ChoiceSection<_FloatingThemePreset>(
        title: 'Theme',
        selected: _themePreset,
        options: const [
          _ChoiceOption(
            value: _FloatingThemePreset.light,
            label: 'Light',
            icon: Icons.light_mode_rounded,
          ),
          _ChoiceOption(
            value: _FloatingThemePreset.dark,
            label: 'Dark',
            icon: Icons.dark_mode_rounded,
          ),
          _ChoiceOption(
            value: _FloatingThemePreset.ocean,
            label: 'Ocean',
            icon: Icons.water_drop_rounded,
          ),
        ],
        onSelected: (value) {
          setState(() {
            _themePreset = value;
            _lastEvent = '${_themeLabel(value)} theme selected';
          });
        },
      ),
      _ChoiceSection<_FloatingCornerPreset>(
        title: 'Corners',
        selected: _cornerPreset,
        options: const [
          _ChoiceOption(
            value: _FloatingCornerPreset.nonRound,
            label: 'Non Round',
            icon: Icons.crop_square_rounded,
          ),
          _ChoiceOption(
            value: _FloatingCornerPreset.lessRound,
            label: 'Less Round',
            icon: Icons.rounded_corner_rounded,
          ),
          _ChoiceOption(
            value: _FloatingCornerPreset.round,
            label: 'Round',
            icon: Icons.radio_button_unchecked_rounded,
          ),
        ],
        onSelected: (value) {
          setState(() {
            _cornerPreset = value;
            _lastEvent = '${_cornerLabel(value)} corners selected';
          });
        },
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSingleColumn = constraints.maxWidth < 620;

        if (isSingleColumn) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var index = 0; index < sections.length; index++) ...[
                if (index > 0) const SizedBox(height: 12),
                sections[index],
              ],
            ],
          );
        }

        final itemWidth = (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final section in sections)
              SizedBox(width: itemWidth, child: section),
          ],
        );
      },
    );
  }

  bool get _isPersistent =>
      _visibilityMode == _FloatingVisibilityMode.persistent;

  VirtualKeypadFloatingVisibilityMode get _floatingVisibilityMode =>
      _isPersistent
      ? VirtualKeypadFloatingVisibilityMode.persistent
      : VirtualKeypadFloatingVisibilityMode.onDemand;

  double _keyboardWidth(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final availableWidth = math.max(260.0, screenWidth - 16);
    final preferredWidth = switch (_sizePreset) {
      _FloatingSizePreset.compact => 320.0,
      _FloatingSizePreset.regular => 390.0,
      _FloatingSizePreset.landscape => 560.0,
    };

    return math.min(preferredWidth, availableWidth);
  }

  double _keyboardHeight(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final maxHeight = math.max(210.0, screenHeight * 0.42);

    switch (_sizePreset) {
      case _FloatingSizePreset.compact:
        return math.min(220.0, maxHeight);
      case _FloatingSizePreset.regular:
        return math.min(280.0, maxHeight);
      case _FloatingSizePreset.landscape:
        return math.min(220.0, maxHeight);
    }
  }

  double get _panelRadius {
    switch (_cornerPreset) {
      case _FloatingCornerPreset.nonRound:
        return 0;
      case _FloatingCornerPreset.lessRound:
        return 12;
      case _FloatingCornerPreset.round:
        return 20;
    }
  }

  VirtualKeypadTheme get _floatingTheme {
    switch (_themePreset) {
      case _FloatingThemePreset.light:
        return VirtualKeypadTheme.light;
      case _FloatingThemePreset.dark:
        return VirtualKeypadTheme.dark;
      case _FloatingThemePreset.ocean:
        return const VirtualKeypadTheme(
          backgroundColor: Color(0xFF0E2C40),
          keyColor: Color(0xFF184B69),
          actionKeyColor: Color(0xFF0B6E99),
          keyTextColor: Colors.white,
          keyBorderRadius: 10,
          splashColor: Color(0xFF2C8BC5),
        );
    }
  }

  static String _modeLabel(_FloatingDemoMode value) {
    switch (value) {
      case _FloatingDemoMode.standalone:
        return 'Standalone';
      case _FloatingDemoMode.scoped:
        return 'Scoped';
    }
  }

  static String _visibilityLabel(_FloatingVisibilityMode value) {
    switch (value) {
      case _FloatingVisibilityMode.onDemand:
        return 'On Demand';
      case _FloatingVisibilityMode.persistent:
        return 'Persistent';
    }
  }

  static String _sizeLabel(_FloatingSizePreset value) {
    switch (value) {
      case _FloatingSizePreset.compact:
        return 'Compact';
      case _FloatingSizePreset.regular:
        return 'Regular';
      case _FloatingSizePreset.landscape:
        return 'Landscape';
    }
  }

  static String _themeLabel(_FloatingThemePreset value) {
    switch (value) {
      case _FloatingThemePreset.light:
        return 'Light';
      case _FloatingThemePreset.dark:
        return 'Dark';
      case _FloatingThemePreset.ocean:
        return 'Ocean';
    }
  }

  static String _cornerLabel(_FloatingCornerPreset value) {
    switch (value) {
      case _FloatingCornerPreset.nonRound:
        return 'Non Round';
      case _FloatingCornerPreset.lessRound:
        return 'Less Round';
      case _FloatingCornerPreset.round:
        return 'Round';
    }
  }

  InputDecoration _fieldDecoration(
    ColorScheme colorScheme, {
    required String label,
    required String hint,
    required IconData icon,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      alignLabelWithHint: alignLabelWithHint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: colorScheme.surfaceContainerLowest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF0ba360), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}

class _ChoiceOption<T> {
  const _ChoiceOption({
    required this.value,
    required this.label,
    required this.icon,
  });

  final T value;
  final String label;
  final IconData icon;
}

class _ChoiceSection<T> extends StatelessWidget {
  const _ChoiceSection({
    required this.title,
    required this.selected,
    required this.options,
    required this.onSelected,
  });

  final String title;
  final T selected;
  final List<_ChoiceOption<T>> options;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in options)
              ChoiceChip(
                avatar: Icon(
                  option.icon,
                  size: 16,
                  color: option.value == selected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.primary,
                ),
                label: Text(option.label),
                selected: option.value == selected,
                onSelected: (_) => onSelected(option.value),
              ),
          ],
        ),
      ],
    );
  }
}

class _PanelCard extends StatelessWidget {
  const _PanelCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: child,
    );
  }
}
