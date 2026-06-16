<!-- Add codecov tag later -->
<p align="center">
  <a href="https://pub.dev/packages/jaspr_provider"><img src="https://img.shields.io/pub/v/jaspr_provider.svg" alt="Pub"></a>
</p>

A port of Flutter's [Provider](https://pub.dev/packages/provider) package to [jaspr](https://pub.dev/packages/jaspr).

A wrapper around [InheritedComponent]
to make them easier to use and more reusable.

By using `jaspr_provider` instead of manually writing [InheritedComponent], you get:

- simplified allocation/disposal of resources
- lazy-loading
- a vastly reduced boilerplate over making a new class every time
- a common way to consume these [InheritedComponent]s (See [Provider.of]/[Consumer]/[Selector])
- increased scalability for classes with a listening mechanism that grows exponentially
  in complexity (such as [ChangeNotifier], which is O(N) for dispatching notifications).

To read more about a `provider`, see its [documentation](https://pub.dev/documentation/jaspr_provider/latest/jaspr_provider/jaspr_provider-library.html).

See also:

- [Original provider documentation](https://pub.dev/packages/provider)

## Usage

### Exposing a value

#### Exposing a new object instance

Providers allow you to not only expose a value, but also create, listen, and dispose of it.

To expose a newly created object, use the default constructor of a provider.
Do _not_ use the `.value` constructor if you want to **create** an object, or you
may otherwise have undesired side effects.

See [this StackOverflow answer](https://stackoverflow.com/questions/52249578/how-to-deal-with-unwanted-widget-build)
which explains why using the `.value` constructor to create values is undesired.

- **DO** create a new object inside `create`.

```dart
Provider(
  create: (_) => MyModel(),
  child: ...
)
```

- **DON'T** use `Provider.value` to create your object.

```dart
ChangeNotifierProvider.value(
  value: MyModel(),
  child: ...
)
```

- **DON'T** create your object from variables that can change over time.

  In such a situation, your object would never update when the
  value changes.

```dart
int count;

Provider(
  create: (_) => MyModel(count),
  child: ...
)
```

If you want to pass variables that can change over time to your object,
consider using `ProxyProvider`:

```dart
int count;

ProxyProvider0(
  update: (_, __) => MyModel(count),
  child: ...
)
```

**NOTE**:

When using the `create`/`update` callback of a provider, it is worth noting that this callback
is called lazily by default.

This means that until the value is requested at least once, the `create`/`update` callbacks won't be called.

This behavior can be disabled if you want to pre-compute some logic, using the `lazy` parameter:

```dart
MyProvider(
  create: (_) => Something(),
  lazy: false,
)
```

#### Reusing an existing object instance:

If you already have an object instance and want to expose it, it would be best to use the `.value` constructor of a provider.

Failing to do so may call your object `dispose` method when it is still in use.

- **DO** use `ChangeNotifierProvider.value` to provide an existing
  [ChangeNotifier].

```dart
MyChangeNotifier variable;

ChangeNotifierProvider.value(
  value: variable,
  child: ...
)
```

- **DON'T** reuse an existing [ChangeNotifier] using the default constructor

```dart
MyChangeNotifier variable;

ChangeNotifierProvider(
  create: (_) => variable,
  child: ...
)
```

### Reading a value

The easiest way to read a value is by using the extension methods on [BuildContext]:

- `context.watch<T>()`, which makes the component listen to changes on `T`
- `context.read<T>()`, which returns `T` without listening to it
- `context.select<T, R>(R cb(T value))`, which allows a component to listen to only a small part of `T`.

One can also use the static method `Provider.of<T>(context)`, which will behave similarly
to `watch`. When the `listen` parameter is set to `false` (as in `Provider.of<T>(context, listen: false)`), then
it will behave similarly to `read`.

It's worth noting that `context.read<T>()` won't make a component rebuild when the value
changes and it cannot be called inside `StatelessComponent.build`/`State.build`.
On the other hand, it can be freely called outside of these methods.

These methods will look up in the component tree starting from the component associated
with the `BuildContext` passed and will return the nearest variable of type `T`
found (or throw if nothing is found).

This operation is O(1). It doesn't involve walking in the component tree.

Combined with the first example of [exposing a value](#exposing-a-value), this
the component will read the exposed `String` and render "Hello World."

```dart
class Home extends StatelessComponent {
  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield Text(
      // Don't forget to pass the type of the object you want to obtain to `watch`!
      context.watch<String>(),
    );
  }
}
```

Alternatively, instead of using these methods, we can use [Consumer] and [Selector].

These can be useful for performance optimizations or when it is difficult to
obtain a `BuildContext` descendant of the provider.

See the [FAQ](https://github.com/Maksimka101/jaspr_provider#my-component-rebuilds-too-often-what-can-i-do)
or the documentation of [Consumer](https://pub.dev/documentation/jaspr_provider/latest/jaspr_provider/Consumer-class.html)
and [Selector](https://pub.dev/documentation/jaspr_provider/latest/jaspr_provider/Selector-class.html)
for more information.

### Optionally depending on a provider

Sometimes, we may want to support cases where a provider does not exist. An
example would be for reusable components that could be used in various locations,
including outside of a provider.

To do so, when calling `context.watch`/`context.read`, make the generic type
nullable. Such that instead of:

```dart
context.watch<Model>()
```

which will throw a `ProviderNotFoundException` if no matching providers
are found, do:

```dart
context.watch<Model?>()
```

which will try to obtain a matching provider. But if none are found,
`null` will be returned instead of throwing.

### MultiProvider

When injecting many values in big applications, `Provider` can rapidly become
pretty nested:

```dart
Provider<Something>(
  create: (_) => Something(),
  child: Provider<SomethingElse>(
    create: (_) => SomethingElse(),
    child: Provider<AnotherThing>(
      create: (_) => AnotherThing(),
      child: someComponent,
    ),
  ),
),
```

To:

```dart
MultiProvider(
  providers: [
    Provider<Something>(create: (_) => Something()),
    Provider<SomethingElse>(create: (_) => SomethingElse()),
    Provider<AnotherThing>(create: (_) => AnotherThing()),
  ],
  child: someComponent,
)
```

The behavior of both examples is strictly the same. `MultiProvider` only changes
the appearance of the code.

### ProxyProvider

`ProxyProvider` is a provider that combines multiple values from other providers into a new object and sends the result to `Provider`.

That new object will then be updated whenever one of the provider we depend on gets updated.

The following example uses `ProxyProvider` to build translations based on a counter coming from another provider.

```dart
Iterable<Component> build(BuildContext context) sync* {
  yield MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Counter()),
      ProxyProvider<Counter, Translations>(
        update: (_, counter, __) => Translations(counter.value),
      ),
    ],
    child: Foo(),
  );
}

class Translations {
  const Translations(this._value);

  final int _value;

  String get title => 'You clicked $_value times';
}
```

It comes under multiple variations, such as:

- `ProxyProvider` vs `ProxyProvider2` vs `ProxyProvider3`, ...

  That digit after the class name is the number of other providers that
  `ProxyProvider` depends on.

- `ProxyProvider` vs `ChangeNotifierProxyProvider` vs `ListenableProxyProvider`, ...

  They all work similarly, but instead of sending the result into a `Provider`,
  a `ChangeNotifierProxyProvider` will send its value to a `ChangeNotifierProvider`.

### FAQ

#### I have an exception when obtaining Providers inside `initState`. What can I do?

This exception happens because you're trying to listen to a provider from a
life-cycle that will never ever be called again.

It means that you either should use another life-cycle (`build`), or explicitly
specify that you do not care about updates.

As such, instead of:

```dart
void initState() {
  super.initState();
  print(context.watch<Foo>().value);
}
```

you can do:

```dart
Value value;

Iterable<Component> build(BuildContext context) sync* {
  final value = context.watch<Foo>.value;
  if (value != this.value) {
    this.value = value;
    print(value);
  }
}
```

which will print `value` whenever it changes (and only when it changes).

Alternatively, you can do:

```dart
void initState() {
  super.initState();
  print(context.read<Foo>().value);
}
```

Which will print `value` once _and ignore updates._

#### How to handle hot-reload on my objects?

You can make your provided object implement `ReassembleHandler`:

```dart
class Example extends ChangeNotifier implements ReassembleHandler {
  @override
  void reassemble() {
    print('Did hot-reload');
  }
}
```

Then used typically with `provider`:

```dart
ChangeNotifierProvider(create: (_) => Example()),
```

#### I use [ChangeNotifier], and I have an exception when I update it. What happens?

This likely happens because you are modifying the [ChangeNotifier] from one of its descendants _while the component tree is building_.

A typical situation where this happens is when starting an http request, where the future is stored inside the notifier:

```dart
void initState() {
  super.initState();
  context.read<MyNotifier>().fetchSomething();
}
```

This is not allowed because the state update is synchronous.

This means that some components may build _before_ the mutation happens (getting an old value), while other components will build _after_ the mutation is complete (getting a new value). This could cause inconsistencies in your UI and is therefore not allowed.

Instead, you should perform that mutation in a place that would affect the
entire tree equally:

- directly inside the `create` of your provider/constructor of your model:

  ```dart
  class MyNotifier with ChangeNotifier {
    MyNotifier() {
      _fetchSomething();
    }

    Future<void> _fetchSomething() async {}
  }
  ```

  This is useful when there's no "external parameter".

- asynchronously at the end of the frame:
  ```dart
  void initState() {
    super.initState();
    Future.microtask(() =>
      context.read<MyNotifier>().fetchSomething(someValue);
    );
  }
  ```
  It is slightly less ideal, but allows passing parameters to the mutation.

#### Do I have to use [ChangeNotifier] for complex states?

No.

You can use any object to represent your state. For example, an alternate
architecture is to use `Provider.value()` combined with a `StatefulComponent`.

Here's a counter example using such architecture:

```dart
class Example extends StatefulComponent {
  const Example({Key key, this.child}) : super(key: key);

  final Component child;

  @override
  ExampleState createState() => ExampleState();
}

class ExampleState extends State<Example> {
  int _count;

  void increment() {
    setState(() {
      _count++;
    });
  }

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield Provider.value(
      value: _count,
      child: Provider.value(
        value: this,
        child: component.child,
      ),
    );
  }
}
```

where we can read the state by doing:

```dart
yield Text(context.watch<int>().toString());
```

and modify the state with:

```dart
yield Button(
  onPressed: () => context.read<ExampleState>().increment(),
  child: Icon(Icons.plus_one),
);
```

Alternatively, you can create your own provider.

#### Can I make my Provider?

Yes. `provider` exposes all the small components that make a fully-fledged provider.

This includes:

- `SingleChildStatelessComponent`, to make any component works with `MultiProvider`.
  This interface is exposed as part of `package:provider/single_child_component`

- [InheritedProvider], the generic `InheritedComponent` obtained when doing `context.watch`.

Here's an example of a custom provider to use `ValueNotifier` as the state:
https://gist.github.com/rrousselGit/4910f3125e41600df3c2577e26967c91

#### My component rebuilds too often. What can I do?

Instead of `context.watch`, you can use `context.select` to listen only to the specific set of properties on the obtained object.

For example, while you can write:

```dart
Iterable<Component> build(BuildContext context) sync* {
  final person = context.watch<Person>();
  yield Text(person.name);
}
```

It may cause the component to rebuild if something other than `name` changes.

Instead, you can use `context.select` to listen only to the `name` property:

```dart
Iterable<Component> build(BuildContext context) sync* {
  final name = context.select((Person p) => p.name);
  yield Text(name);
}
```

This way, the component won't unnecessarily rebuild if something other than `name` changes.

Similarly, you can use [Consumer]/[Selector]. Their optional `child` argument allows rebuilding only a particular part of the component tree:

```dart
Foo(
  child: Consumer<A>(
    builder: (_, a, child) sync* {
      yield Bar(a: a, child: child);
    },
    child: Baz(),
  ),
)
```

In this example, only `Bar` will rebuild when `A` updates. `Foo` and `Baz` won't
unnecessarily rebuild.

#### Can I obtain two different providers using the same type?

No. While you can have multiple providers sharing the same type, a component will be able to obtain only one of them: the closest ancestor.

Instead, it would help if you explicitly gave both providers a different type.

Instead of:

```dart
Provider<String>(
  create: (_) => 'England',
  child: Provider<String>(
    create: (_) => 'London',
    child: ...,
  ),
),
```

Prefer:

```dart
Provider<Country>(
  create: (_) => Country('England'),
  child: Provider<City>(
    create: (_) => City('London'),
    child: ...,
  ),
),
```

#### Can I consume an interface and provide an implementation?

Yes, a type hint must be given to the compiler to indicate the interface will be consumed, with the implementation provided in create.

```dart
abstract class ProviderInterface with ChangeNotifier {
  ...
}

class ProviderImplementation with ChangeNotifier implements ProviderInterface {
  ...
}

class Foo extends StatelessComponent {
  @override
  build(context) {
    final provider = Provider.of<ProviderInterface>(context);
    yield ...
  }
}

ChangeNotifierProvider<ProviderInterface>(
  create: (_) => ProviderImplementation(),
  child: Foo(),
),
```

### Existing providers

`provider` exposes a few different kinds of "provider" for different types of objects.

The complete list of all the objects available is [here](https://pub.dev/documentation/jaspr_provider/latest/jaspr_provider/jaspr_provider-library.html)

| name                                                                                                                          | description                                                                                                                                                            |
| ----------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Provider](https://pub.dartlang.org/documentation/jaspr_provider/latest/jaspr_provider/Provider-class.html)                               | The most basic form of provider. It takes a value and exposes it, whatever the value is.                                                                               |
| [ListenableProvider](https://pub.dartlang.org/documentation/jaspr_provider/latest/jaspr_provider/ListenableProvider-class.html)           | A specific provider for Listenable object. ListenableProvider will listen to the object and ask components which depend on it to rebuild whenever the listener is called. |
| [ChangeNotifierProvider](https://pub.dartlang.org/documentation/jaspr_provider/latest/jaspr_provider/ChangeNotifierProvider-class.html)   | A specification of ListenableProvider for ChangeNotifier. It will automatically call `ChangeNotifier.dispose` when needed.                                             |
| [ValueListenableProvider](https://pub.dartlang.org/documentation/jaspr_provider/latest/jaspr_provider/ValueListenableProvider-class.html) | Listen to a ValueListenable and only expose `ValueListenable.value`.                                                                                                   |
| [StreamProvider](https://pub.dartlang.org/documentation/jaspr_provider/latest/jaspr_provider/StreamProvider-class.html)                   | Listen to a Stream and expose the latest value emitted.                                                                                                                |
| [FutureProvider](https://pub.dartlang.org/documentation/jaspr_provider/latest/jaspr_provider/FutureProvider-class.html)                   | Takes a `Future` and updates dependents when the future completes.                                                                                                     |

### My application throws a StackOverflowError because I have too many providers, what can I do?

If you have a very large number of providers (150+), it is possible that some devices will throw a `StackOverflowError` because you end-up building too many components at once.

In this situation, you have a few solutions:

- If your application has a splash-screen, try mounting your providers over time instead of all at once.

  You could do:

  ```dart
  MultiProvider(
    providers: [
      if (step1) ...[
        <lots of providers>,
      ],
      if (step2) ...[
        <some more providers>
      ]
    ],
  )
  ```

  where during your splash screen animation, you would do:

  ```dart
  bool step1 = false;
  bool step2 = false;
  @override
  void initState() {
    super.initState();
    Future(() {
      setState(() => step1 = true);
      Future(() {
        setState(() => step2 = true);
      });
    });
  }
  ```

- Consider opting out of using `MultiProvider`.
  `MultiProvider` works by adding a component between every providers. Not using `MultiProvider` can
  increase the limit before a `StackOverflowError` is reached.
  
## Port road map:
- [x] Port Flutter code to the Jaspr
- [x] Port documentation
- [ ] Port tests
  - Tests are ported and major part of them are working. 
    However some of them are not working because of problems in
    `jaspr_test` package

[provider.of]: https://pub.dev/documentation/jaspr_provider/latest/jaspr_provider/Provider/of.html
[selector]: https://pub.dev/documentation/jaspr_provider/latest/jaspr_provider/Selector-class.html
[consumer]: https://pub.dev/documentation/jaspr_provider/latest/jaspr_provider/Consumer-class.html
[changenotifier]: https://pub.dev/documentation/jaspr/latest/jaspr_server/ChangeNotifier-class.html
[inheritedcomponent]: https://pub.dev/documentation/jaspr/latest/jaspr_server/InheritedComponent-class.html
[inheritedprovider]: https://pub.dev/documentation/jaspr_provider/latest/jaspr_provider/InheritedProvider-class.html
[buildcontext]: https://pub.dev/documentation/jaspr/latest/jaspr_server/BuildContext-class.html
