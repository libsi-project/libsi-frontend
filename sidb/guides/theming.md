# Руководство по системе тем в Jaspr

В проекте реализована "премиальная" система темизации, основанная на **CSS-переменных** и синхронизации состояния между сервером (SSR) и клиентом.

## Основные принципы

1. **Единый источник цветов**: Все реальные значения цветов хранятся в `web/styles.css`.
2. **Типизация в Dart**: Класс `AppTheme` предоставляет типизированный доступ к этим цветам через `var(--theme-...)`.
3. **SSR Friendly**: Тема считывается из Cookie на сервере, что предотвращает "белую вспышку" (FASH) при загрузке страницы.
4. **Мгновенное переключение**: Благодаря CSS-переменным, браузер обновляет цвета всех компонентов мгновенно без перерисовки дерева Jaspr.

---

## Как добавить новый цвет

### Шаг 1: Объявление в CSS
Откройте файл `web/styles.css` и добавьте переменную в обе секции:

```css
/* web/styles.css */

:root {
  /* Светлая тема (Default) */
  --theme-my-new-color: #ABCDEF;
}

[data-theme='dark'] {
  /* Темная тема */
  --theme-my-new-color: #123456;
}
```

### Шаг 2: Регистрация в Dart
Откройте файл `lib/presentation/theme/app_theme.dart` и добавьте свойство:

```dart
// lib/presentation/theme/app_theme.dart

class AppTheme {
  // ... существующие поля
  final Color myNewColor;

  const AppTheme({
    // ...
    required this.myNewColor,
  });

  static const theme = AppTheme(
    // ...
    myNewColor: Color('var(--theme-my-new-color)'),
  );
  
  // light и dark просто ссылаются на theme
  static final light = theme;
  static final dark = theme;
}
```

### Шаг 3: Использование в компоненте
Используйте цвет через статическую константу `AppTheme.theme`:

```dart
final myStyle = Styles(
  backgroundColor: AppTheme.theme.myNewColor,
);

return div(styles: myStyle, [ ... ]);
```

---

## Технические детали

### Синхронизация (ThemeProvider)
Компонент `ThemeProvider` (в `lib/presentation/theme/theme_provider.dart`) управляет жизненным циклом темы:
- **didChangeDependencies**: Считывает Cookie `theme` на сервере.
- **SyncStateMixin**: Передает состояние с сервера на клиент в HTML-коде.
- **updateState**: Гидрирует тему на клиенте до начала отрисовки.

### ThemeCubit
Управляет состоянием (`light`/`dark`) и при каждом изменении:
1. Обновляет атрибут `data-theme` на теге `<body>`.
2. Сохраняет значение в `localStorage`.
3. Устанавливает Cookie для будущих SSR-запросов.
