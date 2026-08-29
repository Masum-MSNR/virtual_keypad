# Security Policy

## Supported versions

Fixes land on the latest published version. Please reproduce on the newest
release before reporting.

| Version | Supported |
| ------- | --------- |
| Latest release | Yes |
| Anything older | No, please upgrade first |

## Reporting a vulnerability

Do not open a public issue for a security problem.

Use GitHub's private reporting on the
[Security tab](https://github.com/almasumdev/virtual_keypad/security/advisories/new),
or email dev.almasum@gmail.com. Include the package version, the platform, and
steps to reproduce it if you have them.

You can expect an acknowledgement within a few days. If the report is confirmed,
a fix will be published and the advisory credited to you unless you would rather
stay anonymous.

## Scope

This package draws a keyboard and delivers key presses to a text field. It is
often used for PIN and payment entry on kiosk and point of sale hardware, so
what it does with typed characters matters:

- Key presses go to the focused field through Flutter's text input pipeline.
  The package does not log them, persist them, or send them anywhere.
- In standalone mode the platform text input control is replaced, so keystrokes
  do not reach the system IME. That is a real property worth relying on, and a
  regression in it is a security issue rather than a cosmetic one.
- `obscureText` fields are the caller's own widgets; this package does not
  change how they render. On-screen key previews are configurable, and a preview
  that shows a character the field is obscuring is worth reporting.

Out of scope:

- Shoulder surfing and camera capture. A fixed layout is predictable by design;
  use the shuffled layouts if that is part of your threat model.
- Hardware keyloggers and a compromised operating system, which sit below
  anything a widget can defend.
- What your application does with the text after it is entered.
