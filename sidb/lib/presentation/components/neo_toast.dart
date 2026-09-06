import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

/// Transient bottom-corner notification (toast / snackbar).
///
/// Mount [ToastHost] once at the app root, then call
/// `ToastScope.of(context).show('message')` from anywhere in the
/// subtree. Toasts auto-dismiss after [defaultDuration] and stack
/// vertically when several are queued at once.
class ToastController {
  ToastController();

  final List<_ToastEntry> _entries = [];
  final List<VoidCallback> _listeners = [];
  int _nextId = 0;

  static const Duration defaultDuration = Duration(seconds: 3);

  void addListener(VoidCallback listener) => _listeners.add(listener);
  void removeListener(VoidCallback listener) => _listeners.remove(listener);

  void show(String message, {Duration duration = defaultDuration}) {
    final id = _nextId++;
    _entries.add(_ToastEntry(id: id, message: message));
    _notify();
    Timer(duration, () => _dismiss(id));
  }

  void _dismiss(int id) {
    final before = _entries.length;
    _entries.removeWhere((entry) => entry.id == id);
    if (_entries.length == before) return;
    _notify();
  }

  void _notify() {
    scheduleMicrotask(() {
      for (final listener in List<VoidCallback>.of(_listeners)) {
        listener();
      }
    });
  }
}

class _ToastEntry {
  _ToastEntry({required this.id, required this.message});
  final int id;
  final String message;
}

class ToastScope extends InheritedComponent {
  const ToastScope({required this.controller, required super.child, super.key});

  final ToastController controller;

  static ToastController of(BuildContext context) {
    final element = context.getElementForInheritedComponentOfExactType<ToastScope>();
    final scope = element?.component as ToastScope?;
    if (scope == null) {
      throw StateError('No ToastScope found. Wrap the app with ToastHost.');
    }
    return scope.controller;
  }

  @override
  bool updateShouldNotify(covariant ToastScope oldComponent) => false;
}

class ToastHost extends StatefulComponent {
  const ToastHost({required this.child, super.key});
  final Component child;

  @css
  static List<StyleRule> get styles => [
    css('.toast-host').styles(display: Display.contents),
    css('.toast-overlay').styles(
      display: Display.flex,
      position: Position.fixed(bottom: 1.5.rem, right: 1.5.rem),
      zIndex: ZIndex(1500),
      pointerEvents: PointerEvents.none,
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.5.rem),
    ),
    css('.toast').styles(
      display: Display.block,
      maxWidth: 20.rem,
      padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.75.rem),
      border: NeoTokens.border(width: NeoTokens.borderThick),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.9.rem,
      fontWeight: FontWeight.w700,
      backgroundColor: AppTheme.accentColor,
      raw: {'box-shadow': '4px 4px 0 0 var(--theme-border)'},
    ),
  ];

  @override
  State<ToastHost> createState() => _ToastHostState();
}

class _ToastHostState extends State<ToastHost> {
  final ToastController _controller = ToastController();

  @override
  Component build(BuildContext context) {
    return ToastScope(
      controller: _controller,
      child: div(classes: 'toast-host', [
        component.child,
        _ToastOverlay(controller: _controller),
      ]),
    );
  }
}

class _ToastOverlay extends StatefulComponent {
  const _ToastOverlay({required this.controller});
  final ToastController controller;

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay> {
  @override
  void initState() {
    super.initState();
    component.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    component.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'toast-overlay',
      attributes: const {'role': 'status', 'aria-live': 'polite'},
      [
        for (final entry in component.controller._entries)
          div(
            key: ValueKey(entry.id),
            classes: 'toast',
            [.text(entry.message)],
          ),
      ],
    );
  }
}
