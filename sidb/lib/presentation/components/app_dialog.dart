import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/presentation/components/neo_button.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

/// Closes a dialog opened through [AppDialogController.show].
class AppDialogHandle<T> {
  AppDialogHandle._(this._close);

  final void Function([T? result]) _close;

  void close([T? result]) => _close(result);
}

/// App-wide dialog stack. Owned by [AppDialogHost] and provided through
/// [AppDialogScope] so UI can call [BuildContext.showDialog].
class AppDialogController {
  final List<VoidCallback> _listeners = [];
  final List<_AppDialogEntry> _entries = [];
  int _nextId = 0;

  void addListener(VoidCallback listener) => _listeners.add(listener);

  void removeListener(VoidCallback listener) => _listeners.remove(listener);

  void _notify() {
    scheduleMicrotask(() {
      for (final listener in List<VoidCallback>.of(_listeners)) {
        listener();
      }
    });
  }

  Future<T?> show<T>({
    required Component Function(AppDialogHandle<T> handle) builder,
    bool barrierDismissible = true,
    VoidCallback? onBarrierDismiss,
  }) {
    final completer = Completer<T?>();
    final id = _nextId++;
    final handle = AppDialogHandle<T>._(([result]) => _pop<T>(id, result));
    _entries.add(
      _AppDialogEntry(
        id: id,
        barrierDismissible: barrierDismissible,
        onBarrierDismiss: onBarrierDismiss,
        builder: () => builder(handle),
        complete: (result) {
          if (!completer.isCompleted) completer.complete(result as T?);
        },
      ),
    );
    _notify();
    return completer.future;
  }

  void closeLatest([Object? result]) {
    if (_entries.isEmpty) return;
    _pop(_entries.last.id, result);
  }

  void closeAll() {
    while (_entries.isNotEmpty) {
      _pop(_entries.last.id, null);
    }
  }

  void _pop<T>(int id, Object? result) {
    final index = _entries.indexWhere((entry) => entry.id == id);
    if (index == -1) return;
    final entry = _entries.removeAt(index);
    entry.complete(result);
    _notify();
  }
}

class _AppDialogEntry {
  _AppDialogEntry({
    required this.id,
    required this.barrierDismissible,
    required this.builder,
    required this.complete,
    this.onBarrierDismiss,
  });

  final int id;
  final bool barrierDismissible;
  final VoidCallback? onBarrierDismiss;
  final Component Function() builder;
  final void Function(Object? result) complete;
}

/// Lookup without subscribing, so opening a dialog does not rebuild callers.
class AppDialogScope extends InheritedComponent {
  const AppDialogScope({
    required this.controller,
    required super.child,
    super.key,
  });

  final AppDialogController controller;

  static AppDialogController of(BuildContext context) {
    final element = context.getElementForInheritedComponentOfExactType<AppDialogScope>();
    final scope = element?.component as AppDialogScope?;
    if (scope == null) {
      throw StateError('No AppDialogScope found in BuildContext. Wrap the app with AppDialogHost.');
    }
    return scope.controller;
  }

  @override
  bool updateShouldNotify(covariant AppDialogScope oldComponent) => false;
}

/// Mount once at the app root. Renders dialogs in a high z-index overlay.
class AppDialogHost extends StatefulComponent {
  const AppDialogHost({required this.child, super.key});

  final Component child;

  @override
  State<AppDialogHost> createState() => _AppDialogHostState();
}

class _AppDialogHostState extends State<AppDialogHost> {
  final AppDialogController _controller = AppDialogController();

  @override
  Component build(BuildContext context) {
    return AppDialogScope(
      controller: _controller,
      child: div(
        classes: 'app-dialog-host',
        [
          component.child,
          _AppDialogOverlay(controller: _controller),
        ],
      ),
    );
  }
}

class _AppDialogOverlay extends StatefulComponent {
  const _AppDialogOverlay({required this.controller});

  final AppDialogController controller;

  @override
  State<_AppDialogOverlay> createState() => _AppDialogOverlayState();
}

class _AppDialogOverlayState extends State<_AppDialogOverlay> {
  @override
  void initState() {
    super.initState();
    component.controller.addListener(_onDialogsChanged);
  }

  @override
  void dispose() {
    component.controller.removeListener(_onDialogsChanged);
    super.dispose();
  }

  void _onDialogsChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      for (final entry in component.controller._entries) _barrier(entry),
    ]);
  }

  Component _barrier(_AppDialogEntry entry) {
    return div(
      key: ValueKey(entry.id),
      classes: 'app-dialog-layer',
      events: {
        if (entry.barrierDismissible)
          'click': (_) {
            if (entry.onBarrierDismiss != null) {
              entry.onBarrierDismiss!();
            } else {
              component.controller._pop(entry.id, null);
            }
          },
      },
      [
        div(
          classes: 'app-dialog-layer-content',
          events: {
            'click': (event) => event.stopPropagation(),
          },
          [entry.builder()],
        ),
      ],
    );
  }
}

/// Centered neo panel used by [AppDialogContext.showDialog] and [AppDialogContext.showComponent].
class AppDialog extends StatelessComponent {
  const AppDialog({
    this.title,
    this.child,
    this.onCancel,
    this.onOk,
    this.cancelLabel = 'Cancel',
    this.okLabel = 'Ok',
    super.key,
  });

  final String? title;
  final Component? child;
  final VoidCallback? onCancel;
  final VoidCallback? onOk;
  final String cancelLabel;
  final String okLabel;

  @css
  static List<StyleRule> get stylesheets => [
    css('.app-dialog-host').styles(
      width: 100.percent,
      height: 100.percent,
    ),
    css('.app-dialog-layer').styles(
      display: Display.flex,
      position: Position.fixed(top: 0.px, right: 0.px, bottom: 0.px, left: 0.px),
      zIndex: ZIndex(1000),
      padding: Padding.all(1.25.rem),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      backgroundColor: const Color('rgba(0, 0, 0, 0.45)'),
    ),
    css('.app-dialog-layer-content').styles(
      width: 100.percent,
      maxWidth: 28.rem,
    ),
    css('.app-dialog').styles(
      display: Display.flex,
      width: 100.percent,
      padding: Padding.all(1.5.rem),
      border: NeoTokens.border(width: NeoTokens.borderThick),
      radius: NeoTokens.radius(0),
      shadow: BoxShadow(
        offsetX: 6.px,
        offsetY: 6.px,
        blur: 0.px,
        spread: 0.px,
        color: AppTheme.borderColor,
      ),
      flexDirection: FlexDirection.column,
      gap: Gap.all(1.rem),
      color: AppTheme.textColor,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      backgroundColor: AppTheme.surfaceColor,
    ),
    css('.app-dialog-message').styles(
      margin: Margin.zero,
      color: AppTheme.textColor,
      fontSize: 1.rem,
      fontWeight: FontWeight.w600,
    ),
    css('.app-dialog-actions').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      justifyContent: JustifyContent.end,
      alignItems: AlignItems.center,
      gap: Gap.all(0.75.rem),
    ),
  ];

  @override
  Component build(BuildContext context) {
    final hasActions = onCancel != null || onOk != null;

    return div(
      classes: 'app-dialog',
      [
        if (title != null) h2([.text(title!)]),
        ?child,
        if (hasActions)
          div(classes: 'app-dialog-actions', [
            if (onCancel != null)
              NeoButton(
                onClick: onCancel,
                children: [.text(cancelLabel)],
              ),
            if (onOk != null)
              NeoButton(
                variant: NeoButtonVariant.primary,
                onClick: onOk,
                children: [.text(okLabel)],
              ),
          ]),
      ],
    );
  }
}

extension AppDialogContext on BuildContext {
  Future<void> showDialog({
    String? title,
    String? message,
    VoidCallback? onOk,
    required VoidCallback onCancel,
    String? cancelLabel,
    String? okLabel,
    bool barrierDismissible = true,
  }) {
    return _present(
      title: title,
      child: message == null ? null : p(classes: 'app-dialog-message', [.text(message)]),
      onOk: onOk,
      onCancel: onCancel,
      cancelLabel: cancelLabel,
      okLabel: okLabel,
      barrierDismissible: barrierDismissible,
    );
  }

  Future<void> showComponent({
    String? title,
    required Component child,
    VoidCallback? onOk,
    VoidCallback? onCancel,
    String? cancelLabel,
    String? okLabel,
    bool barrierDismissible = true,
  }) {
    return _present(
      title: title,
      child: child,
      onOk: onOk,
      onCancel: onCancel,
      cancelLabel: cancelLabel,
      okLabel: okLabel,
      barrierDismissible: barrierDismissible,
    );
  }

  Future<void> _present({
    String? title,
    Component? child,
    VoidCallback? onOk,
    VoidCallback? onCancel,
    String? cancelLabel,
    String? okLabel,
    bool barrierDismissible = true,
  }) {
    final controller = AppDialogScope.of(this);
    late final AppDialogHandle<void> handle;

    void closeAfter(VoidCallback? action) {
      action?.call();
      handle.close();
    }

    return controller.show<void>(
      barrierDismissible: barrierDismissible,
      onBarrierDismiss: barrierDismissible ? () => closeAfter(onCancel) : null,
      builder: (dialogHandle) {
        handle = dialogHandle;
        return AppDialog(
          title: title,
          child: child,
          cancelLabel: cancelLabel ?? 'Cancel',
          okLabel: okLabel ?? 'Ok',
          onCancel: onCancel == null ? null : () => closeAfter(onCancel),
          onOk: onOk == null ? null : () => closeAfter(onOk),
        );
      },
    );
  }
}
