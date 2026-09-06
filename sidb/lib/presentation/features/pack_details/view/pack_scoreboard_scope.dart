import 'dart:async';

import 'package:jaspr/jaspr.dart';

/// State for the pack-details scoreboard.
///
/// Shared between the panel and the mobile trigger button through
/// [ScoreboardScope] so neither has to lift its `_isOpen` bool into
/// a common parent.
class ScoreboardController {
  bool _isOpen = false;
  final List<VoidCallback> _listeners = [];

  bool get isOpen => _isOpen;

  void open() {
    if (_isOpen) return;
    _isOpen = true;
    _notify();
  }

  void close() {
    if (!_isOpen) return;
    _isOpen = false;
    _notify();
  }

  void toggle() {
    _isOpen = !_isOpen;
    _notify();
  }

  void addListener(VoidCallback listener) => _listeners.add(listener);
  void removeListener(VoidCallback listener) => _listeners.remove(listener);

  void _notify() {
    scheduleMicrotask(() {
      for (final listener in List<VoidCallback>.of(_listeners)) {
        listener();
      }
    });
  }
}

class ScoreboardScope extends InheritedComponent {
  const ScoreboardScope({required this.controller, required super.child, super.key});

  final ScoreboardController controller;

  static ScoreboardController of(BuildContext context) {
    final element = context.getElementForInheritedComponentOfExactType<ScoreboardScope>();
    final scope = element?.component as ScoreboardScope?;
    if (scope == null) {
      throw StateError('No ScoreboardScope found. Wrap the pack details layout with ScoreboardHost.');
    }
    return scope.controller;
  }

  @override
  bool updateShouldNotify(covariant ScoreboardScope oldComponent) => false;
}

class ScoreboardHost extends StatefulComponent {
  const ScoreboardHost({required this.child, super.key});

  final Component child;

  @override
  State<ScoreboardHost> createState() => _ScoreboardHostState();
}

class _ScoreboardHostState extends State<ScoreboardHost> {
  final ScoreboardController _controller = ScoreboardController();

  @override
  Component build(BuildContext context) {
    return ScoreboardScope(controller: _controller, child: component.child);
  }
}
