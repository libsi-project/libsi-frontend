import 'package:jaspr/jaspr.dart';

/// A [Component] that takes a single descendant.
///
/// See also:
/// - [SingleChildStatelessComponent]
/// - [SingleChildStatefulComponent]
abstract class SingleChildComponent implements Component {
  @override
  _SingleChildComponentElementMixin createElement();
}

mixin _SingleChildComponentElementMixin on Element {
  _NestedHookElement? _parent;

  @override
  void mount(Element? parent, ElementSlot slot) {
    if (parent is _NestedHookElement?) {
      _parent = parent;
    }
    super.mount(parent, slot);
  }

  @override
  void activate() {
    super.activate();
    visitAncestorElements((parent) {
      if (parent is _NestedHookElement) {
        _parent = parent;
      }
      return false;
    });
  }
}

class _NestedHook extends StatelessComponent {
  _NestedHook({
    this.injectedChild,
    required this.wrappedComponent,
    required this.owner,
  });

  final SingleChildComponent wrappedComponent;
  final Component? injectedChild;
  final _NestedElement owner;

  @override
  _NestedHookElement createElement() => _NestedHookElement(this);

  @override
  Component build(BuildContext context) =>
      throw StateError('handled internally');
}

/// A component that simplify the writing of deeply nested component trees.
///
/// It relies on the new kind of component [SingleChildComponent], which has two
/// concrete implementations:
/// - [SingleChildStatelessComponent]
///
/// They are both respectively a [SingleChildComponent] variant of [StatelessComponent]
/// and [StatefulComponent].
///
/// The difference between a component and its single-child variant is that they have
/// a custom `build` method that takes an extra parameter.
///
/// As such, a `StatelessComponent` would be:
///
/// ```dart
/// class MyComponent extends StatelessComponent {
///   MyComponent({Key key, this.child}): super(key: key);
///
///   final Component child;
///
///   @override
///   Component build(BuildContext context) sync* {
///     yield SomethingComponent(child: child);
///   }
/// }
/// ```
///
/// Whereas a [SingleChildStatelessComponent] would be:
///
/// ```dart
/// class MyComponent extends SingleChildStatelessComponent {
///   MyComponent({Key key, Component child}): super(key: key, child: child);
///
///   @override
///   Component buildWithChild(BuildContext context, Component child) sync* {
///     yield SomethingComponent(child: child);
///   }
/// }
/// ```
///
/// This allows our new `MyComponent` to be used both with:
///
/// ```dart
/// MyComponent(
///   child: AnotherComponent(),
/// )
/// ```
///
/// and to be placed inside `children` of [Nested] like so:
///
/// ```dart
/// Nested(
///   children: [
///     MyComponent(),
///     ...
///   ],
///   child: AnotherComponent(),
/// )
/// ```
class Nested extends StatelessComponent implements SingleChildComponent {
  /// Allows configuring key, children and child
  Nested({
    Key? key,
    required List<SingleChildComponent> children,
    Component? child,
  })  : assert(children.isNotEmpty),
        _children = children,
        _child = child,
        super(key: key);

  final List<SingleChildComponent> _children;
  final Component? _child;

  @override
  Component build(BuildContext context) {
    return throw StateError('implemented internally');
  }

  @override
  _NestedElement createElement() => _NestedElement(this);
}

class _NestedElement extends StatelessElement
    with _SingleChildComponentElementMixin {
  _NestedElement(Nested component) : super(component);

  @override
  Nested get component => super.component as Nested;

  final nodes = <_NestedHookElement>{};

  @override
  Component build() {
    _NestedHook? nestedHook;
    var nextNode = _parent?.injectedChild ?? component._child;

    for (final child in component._children.reversed) {
      nextNode = nestedHook = _NestedHook(
        owner: this,
        wrappedComponent: child,
        injectedChild: nextNode,
      );
    }

    if (nestedHook != null) {
      // We manually update _NestedHookElement instead of letter components do their thing
      // because an item N may be constant but N+1 not. So, if we used components
      // then N+1 wouldn't rebuild because N didn't change
      for (final node in nodes) {
        node
          ..wrappedChild = nestedHook!.wrappedComponent
          ..injectedChild = nestedHook.injectedChild;

        final next = nestedHook.injectedChild;
        if (next is _NestedHook) {
          nestedHook = next;
        } else {
          break;
        }
      }
    }

    return nextNode!;
  }
}

class _NestedHookElement extends StatelessElement {
  _NestedHookElement(_NestedHook component) : super(component);

  @override
  _NestedHook get component => super.component as _NestedHook;

  Component? _injectedChild;
  Component? get injectedChild => _injectedChild;
  set injectedChild(Component? value) {
    final previous = _injectedChild;
    if (value is _NestedHook &&
        previous is _NestedHook &&
        Component.canUpdate(
            value.wrappedComponent, previous.wrappedComponent)) {
      // no need to rebuild the wrapped component just for a _NestedHook.
      // The component doesn't matter here, only its Element.
      return;
    }
    if (previous != value) {
      _injectedChild = value;
      visitChildren((e) => e.markNeedsBuild());
    }
  }

  SingleChildComponent? _wrappedChild;
  SingleChildComponent? get wrappedChild => _wrappedChild;
  set wrappedChild(SingleChildComponent? value) {
    if (_wrappedChild != value) {
      _wrappedChild = value;
      markNeedsBuild();
    }
  }

  @override
  void mount(Element? parent, ElementSlot slot) {
    component.owner.nodes.add(this);
    _wrappedChild = component.wrappedComponent;
    _injectedChild = component.injectedChild;
    super.mount(parent, slot);
  }

  @override
  void unmount() {
    component.owner.nodes.remove(this);
    super.unmount();
  }

  @override
  Component build() {
    return wrappedChild!;
  }
}

/// A [StatefulComponent] that is compatible with [Nested].
abstract class SingleChildStatefulComponent extends StatefulComponent
    implements SingleChildComponent {
  /// Creates a component that has exactly one child component.
  const SingleChildStatefulComponent({Key? key, Component? child})
      : _child = child,
        super(key: key);

  final Component? _child;

  @override
  SingleChildStatefulElement createElement() {
    return SingleChildStatefulElement(this);
  }
}

/// A [State] for [SingleChildStatefulComponent].
///
/// Do not override [build] and instead override [buildWithChild].
abstract class SingleChildState<T extends SingleChildStatefulComponent>
    extends State<T> {
  /// A [build] method that receives an extra `child` parameter.
  ///
  /// This method may be called with a `child` different from the parameter
  /// passed to the constructor of [SingleChildStatelessComponent].
  /// It may also be called again with a different `child`, without this component
  /// being recreated.
  Component buildWithChild(BuildContext context, Component? child);

  @override
  Component build(BuildContext context) =>
      buildWithChild(context, component._child);
}

/// An [Element] that uses a [SingleChildStatefulComponent] as its configuration.
class SingleChildStatefulElement extends StatefulElement
    with _SingleChildComponentElementMixin {
  /// Creates an element that uses the given component as its configuration.
  SingleChildStatefulElement(SingleChildStatefulComponent component)
      : super(component);

  @override
  SingleChildStatefulComponent get component =>
      super.component as SingleChildStatefulComponent;

  @override
  SingleChildState<SingleChildStatefulComponent> get state =>
      super.state as SingleChildState<SingleChildStatefulComponent>;

  @override
  Component build() {
    if (_parent != null) {
      return state.buildWithChild(this, _parent!.injectedChild);
    }
    return super.build();
  }
}

/// A [StatelessComponent] that implements [SingleChildComponent] and is therefore
/// compatible with [Nested].
///
/// Its [build] method must **not** be overriden. Instead use [buildWithChild].
abstract class SingleChildStatelessComponent extends StatelessComponent
    implements SingleChildComponent {
  /// Creates a component that has exactly one child component.
  const SingleChildStatelessComponent({Key? key, Component? child})
      : _child = child,
        super(key: key);

  final Component? _child;

  /// A [build] method that receives an extra `child` parameter.
  ///
  /// This method may be called with a `child` different from the parameter
  /// passed to the constructor of [SingleChildStatelessComponent].
  /// It may also be called again with a different `child`, without this component
  /// being recreated.
  Component buildWithChild(BuildContext context, Component? child);

  @override
  Component build(BuildContext context) => buildWithChild(context, _child);

  @override
  SingleChildStatelessElement createElement() {
    return SingleChildStatelessElement(this);
  }
}

/// An [Element] that uses a [SingleChildStatelessComponent] as its configuration.
class SingleChildStatelessElement extends StatelessElement
    with _SingleChildComponentElementMixin {
  /// Creates an element that uses the given component as its configuration.
  SingleChildStatelessElement(SingleChildStatelessComponent component)
      : super(component);

  @override
  Component build() {
    if (_parent != null) {
      return component.buildWithChild(this, _parent!.injectedChild);
    }
    return super.build();
  }

  @override
  SingleChildStatelessComponent get component =>
      super.component as SingleChildStatelessComponent;
}
