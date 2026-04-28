import 'package:flutter/material.dart';

class ExampleScrollableContent extends StatelessWidget {
  const ExampleScrollableContent({
    super.key,
    required this.child,
    this.maxWidth = 760,
    this.padding,
    this.topPadding = 20,
    this.bottomPadding = 20,
    this.compactHorizontalPadding = 16,
    this.regularHorizontalPadding = 24,
    this.onTap,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final double topPadding;
  final double bottomPadding;
  final double compactHorizontalPadding;
  final double regularHorizontalPadding;
  final VoidCallback? onTap;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    Widget scrollView = LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth < 600
            ? compactHorizontalPadding
            : regularHorizontalPadding;

        return SingleChildScrollView(
          padding:
              padding ??
              EdgeInsets.fromLTRB(
                horizontalPadding,
                topPadding,
                horizontalPadding,
                bottomPadding,
              ),
          child: Align(
            alignment: alignment,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: child,
            ),
          ),
        );
      },
    );

    if (onTap != null) {
      scrollView = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: scrollView,
      );
    }

    return scrollView;
  }
}

class ExampleConstrainedContent extends StatelessWidget {
  const ExampleConstrainedContent({
    super.key,
    required this.child,
    this.maxWidth = 760,
    this.padding,
    this.compactHorizontalPadding = 16,
    this.regularHorizontalPadding = 24,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final double compactHorizontalPadding;
  final double regularHorizontalPadding;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth < 600
            ? compactHorizontalPadding
            : regularHorizontalPadding;

        return Align(
          alignment: alignment,
          child: Padding(
            padding:
                padding ?? EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
