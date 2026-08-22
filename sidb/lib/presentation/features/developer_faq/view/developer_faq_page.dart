import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:sidb/presentation/components/checkbox.dart';
import 'package:sidb/presentation/components/date_picker.dart';
import 'package:sidb/presentation/components/discrete_slider.dart';
import 'package:sidb/presentation/components/dropdown_edit_field.dart';
import 'package:sidb/presentation/components/icon.dart';
import 'package:sidb/presentation/components/neo_badge.dart';
import 'package:sidb/presentation/components/neo_button.dart';
import 'package:sidb/presentation/components/neo_card.dart';
import 'package:sidb/presentation/components/neo_input.dart';
import 'package:sidb/presentation/components/neo_nav_link.dart';
import 'package:sidb/presentation/components/neo_surface.dart';
import 'package:sidb/presentation/theme/app_theme.dart';
import 'package:sidb/presentation/theme/neo_tokens.dart';

class DeveloperFaqPage extends StatelessComponent {
  const DeveloperFaqPage({super.key});

  @css
  static List<StyleRule> get styles => [
    css('.dev-faq').styles(
      display: Display.flex,
      padding: NeoTokens.pagePadding(top: 3, bottom: 3),
      flexDirection: FlexDirection.column,
      gap: Gap.all(2.rem),
    ),
    css('.dev-faq-header').styles(
      display: Display.flex,
      maxWidth: 920.px,
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.75.rem),
    ),
    css('.dev-faq-section').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(1.rem),
    ),
    css('.dev-faq-grid').styles(
      display: Display.grid,
      gridTemplate: GridTemplate(
        columns: GridTracks([
          GridTrack.repeat(
            TrackRepeat.autoFit,
            [GridTrack(TrackSize.minmax(TrackSize(240.px), .fr(1)))],
          ),
        ]),
      ),
      gap: Gap.all(1.rem),
    ),
    css('.dev-faq-row').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      alignItems: AlignItems.center,
      gap: Gap.all(0.75.rem),
    ),
    css('.dev-faq-stack').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.all(0.75.rem),
    ),
    css('.dev-faq-note').styles(
      color: AppTheme.textSecondary,
      fontFamily: const FontFamily(NeoTokens.fontBody),
      fontSize: 0.95.rem,
      fontWeight: FontWeight.w700,
      lineHeight: 1.45.em,
    ),
    css('.dev-faq-code').styles(
      display: Display.block,
      padding: Padding.all(0.75.rem),
      border: NeoTokens.border(),
      radius: NeoTokens.radius(NeoTokens.radiusSm),
      color: AppTheme.textColor,
      fontFamily: const FontFamily('monospace'),
      fontSize: 0.85.rem,
      fontWeight: FontWeight.w700,
      backgroundColor: AppTheme.inputBackground,
      raw: {'white-space': 'pre-wrap'},
    ),
  ];

  @override
  Component build(BuildContext context) {
    return main_(classes: 'dev-faq', [
      div(classes: 'dev-faq-header', [
        h1(
          styles: NeoStyles.text(
            family: NeoTokens.fontDisplay,
            size: 2.4,
            weight: FontWeight.w900,
          ),
          [.text('Developer FAQ')],
        ),
        p(
          classes: 'dev-faq-note',
          [
            .text(
              'This page is a living UI reference for SIDB. Prefer composing app UI from these primitives instead of rebuilding borders, shadows, focus states, and colors inside feature widgets.',
            ),
          ],
        ),
      ]),
      _Section(
        title: 'Core rule',
        description:
            'New components should compose foundation primitives and override only local layout, not the neobrutalism mechanics.',
        children: [
          _CodeBlock(
            '''
NeoCard(
  children: [
    NeoBadge(label: 'Школьный', tone: NeoBadgeTone.student),
    NeoButton(variant: NeoButtonVariant.primary, children: [.text('Open')]),
  ],
)
''',
          ),
        ],
      ),
      _Section(
        title: 'Surfaces and Cards',
        description:
            '`NeoSurface` owns border/radius/shadow. `NeoCard` adds card layout and should be the default content container.',
        children: [
          div(classes: 'dev-faq-grid', [
            _ExampleTile(
              label: 'NeoSurface / static',
              note: 'Use for neutral panels, callouts, and wrappers.',
              child: NeoSurface(
                styles: Styles(padding: Padding.all(1.rem), margin: Margin.all(1.rem)),
                children: [
                  _sampleTitle('Static surface'),
                  _sampleNote('No hover transform. Good for layout containers.'),
                ],
              ),
            ),
            _ExampleTile(
              label: 'NeoSurface / interactive',
              note: 'Use when the whole surface behaves like a pressable item.',
              child: NeoSurface(
                interactive: true,
                styles: Styles(padding: Padding.all(1.rem), margin: Margin.all(1.rem)),
                children: [
                  _sampleTitle('Interactive surface'),
                  _sampleNote('Hover reduces shadow and nudges the element.'),
                ],
              ),
            ),
            _ExampleTile(
              label: 'NeoCard',
              note: 'Default building block for feature cards.',
              child: NeoCard(
                styles: Styles(margin: Margin.all(1.rem)),
                children: [
                  _sampleTitle('Card title'),
                  _sampleNote('Use local styles only for content-specific layout.'),
                ],
              ),
            ),
          ]),
        ],
      ),
      _Section(
        title: 'Buttons',
        description: '`NeoButton` centralizes variants, sizes, disabled state, shadows, and press behavior.',
        children: [
          _Label('Variants'),
          div(classes: 'dev-faq-row', _buttonVariants()),
          _Label('Sizes and disabled'),
          div(classes: 'dev-faq-row', [
            const NeoButton(size: NeoButtonSize.sm, children: [.text('Small')]),
            const NeoButton(size: NeoButtonSize.md, children: [.text('Medium')]),
            const NeoButton(size: NeoButtonSize.lg, children: [.text('Large')]),
            const NeoButton(disabled: true, children: [.text('Disabled')]),
          ]),
          _CodeBlock(
            '''
NeoButton(
  variant: NeoButtonVariant.primary,
  size: NeoButtonSize.md,
  children: [.text('Save')],
)
''',
          ),
        ],
      ),
      _Section(
        title: 'Icon Buttons and Icons',
        description:
            '`NeoIconButton` is icon-only button chrome. `AppIcon` owns SVG size, stroke, fill, and avoids utility CSS classes.',
        children: [
          div(classes: 'dev-faq-row', [
            const NeoIconButton(
              child: AppIcon(IconPaths.users, strokeWidth: '2.5'),
            ),
            const NeoIconButton(
              variant: NeoButtonVariant.user,
              child: AppIcon(IconPaths.bookmark, filled: true),
            ),
            const NeoIconButton(
              shape: NeoIconButtonShape.square,
              size: 36,
              child: AppIcon(IconPaths.search, width: 18, height: 18),
            ),
            const NeoIconButton(
              disabled: true,
              child: AppIcon(IconPaths.download),
            ),
          ]),
          _CodeBlock(
            '''
NeoIconButton(
  shape: NeoIconButtonShape.pill,
  variant: NeoButtonVariant.user,
  child: AppIcon(IconPaths.users, strokeWidth: '2.5'),
)
''',
          ),
        ],
      ),
      _Section(
        title: 'Inputs',
        description:
            '`NeoInput` is generic. `SearchField` is composition over `NeoInput` with a leading icon. Do not bake search behavior into edit fields.',
        children: [
          div(classes: 'dev-faq-grid', [
            _ExampleTile(
              label: 'Edit field',
              note: 'Plain text input for forms.',
              child: const NeoInput(placeholder: 'Название пакета'),
            ),
            _ExampleTile(
              label: 'Search field',
              note: 'Search-specific composition with icon and aria label.',
              child: const SearchField(placeholder: 'Поиск пакетов...'),
            ),
            _ExampleTile(
              label: 'Validation states',
              note: 'Use semantic error/success tokens.',
              child: div(classes: 'dev-faq-stack', [
                const NeoInput(placeholder: 'Ошибка', state: NeoInputState.error),
                const NeoInput(placeholder: 'Успешно', state: NeoInputState.success),
              ]),
            ),
            _ExampleTile(
              label: 'Disabled',
              note: 'Disabled state is part of the primitive.',
              child: const NeoInput(placeholder: 'Недоступно', disabled: true),
            ),
          ]),
        ],
      ),
      _Section(
        title: 'Advanced Form Controls',
        description:
            'Use these controlled components when a feature needs typed choice, boolean state, or stepped numeric input while keeping native accessibility and neo motion.',
        children: [
          const _AdvancedControlsDemo(),
          _CodeBlock(
            '''
DiscreteSlider(
  value: sliderValue,
  min: 0,
  max: 10,
  step: 0.5,
  onChange: (value) => setState(() => sliderValue = value),
)

Checkbox(
  checked: isEnabled,
  label: .text('Enable beta mode'),
  onChange: (checked) => setState(() => isEnabled = checked),
)

DropdownEditField<MyItem>(
  id: 'item-dropdown',
  items: items,
  value: selectedItem,
  placeholder: 'Pick an item',
  itemAsString: (item) => item.title,
  onChange: (item) => setState(() => selectedItem = item),
)

DatePicker(
  value: selectedDate,
  onChange: (date) => setState(() => selectedDate = date),
)
''',
          ),
        ],
      ),
      _Section(
        title: 'Badges',
        description:
            '`NeoBadge` maps semantic tones to theme variables. Feature cards should not define local badge hex colors.',
        children: [
          div(classes: 'dev-faq-row', [
            const NeoBadge(label: 'student', tone: NeoBadgeTone.student),
            const NeoBadge(label: 'hardcore', tone: NeoBadgeTone.hardcore),
            const NeoBadge(label: 'thematic', tone: NeoBadgeTone.thematic),
            const NeoBadge(label: 'general', tone: NeoBadgeTone.general),
            const NeoBadge(label: 'neutral', tone: NeoBadgeTone.neutral),
          ]),
          _CodeBlock("NeoBadge(label: pack.difficultyType, tone: NeoBadgeTone.student)"),
        ],
      ),
      _Section(
        title: 'Navigation Links',
        description:
            '`NeoNavLink` is for route-aware nav buttons. It handles active, inactive, pill/square shapes, hover border, and active hover contrast.',
        children: [
          div(classes: 'dev-faq-row', [
            const NeoNavLink(label: 'Inactive pill', to: '/developer-faq'),
            const NeoNavLink(label: 'Active pill', to: '/developer-faq', isActive: true),
            const NeoNavLink(label: 'Inactive square', to: '/developer-faq', square: true),
            const NeoNavLink(label: 'Active square', to: '/developer-faq', isActive: true, square: true),
          ]),
        ],
      ),
      _Section(
        title: 'Token Overrides',
        description:
            'When a variant needs custom layout, override only the local value with `NeoTokens` or semantic `AppTheme` colors.',
        children: [
          NeoCard(
            interactive: true,
            shadowColorCss: 'var(--theme-primary)',
            styles: Styles(
              border: NeoTokens.border(width: NeoTokens.borderStrong, color: AppTheme.primaryColor),
              backgroundColor: AppTheme.surfaceColor,
            ),
            children: [
              _sampleTitle('Tokenized override'),
              _sampleNote('This keeps the component aligned with theme switching and shared motion.'),
            ],
          ),
          _CodeBlock(
            '''
NeoCard(
  shadowColorCss: 'var(--theme-primary)',
  styles: Styles(
    border: NeoTokens.border(width: NeoTokens.borderStrong, color: AppTheme.primaryColor),
  ),
)
''',
          ),
          _SampleExplanation(
            title: 'Why not override shadow with NeoTokens.shadow?',
            text:
                'Do not pass `Styles(shadow: NeoTokens.shadow(...))` when you only need a custom shadow color. Jaspr renders that as an inline `box-shadow`, and inline styles win over the `NeoSurface` hover CSS. The card will still move, but the hover rule cannot shrink the shadow correctly. Use `shadowColorCss` instead: it changes only the CSS variable for the color, while `NeoSurface` keeps ownership of the normal and hover shadow offsets.',
          ),
        ],
      ),
    ]);
  }

  List<Component> _buttonVariants() {
    return NeoButtonVariant.values
        .map(
          (variant) => NeoButton(
            variant: variant,
            children: [.text(_variantLabel(variant))],
          ),
        )
        .toList();
  }

  String _variantLabel(NeoButtonVariant variant) {
    return switch (variant) {
      NeoButtonVariant.surface => 'surface',
      NeoButtonVariant.primary => 'primary',
      NeoButtonVariant.accent => 'accent',
      NeoButtonVariant.ghost => 'ghost',
      NeoButtonVariant.danger => 'danger',
      NeoButtonVariant.success => 'success',
      NeoButtonVariant.user => 'user',
    };
  }
}

class _AdvancedControlsDemo extends StatefulComponent {
  const _AdvancedControlsDemo();

  @override
  State<_AdvancedControlsDemo> createState() => _AdvancedControlsDemoState();
}

class _AdvancedControlsDemoState extends State<_AdvancedControlsDemo> {
  double _sliderValue = 4;
  bool _checked = true;
  _FaqAudience? _selectedAudience = _audiences.first;
  DateTime _selectedDate = DateTime(2026, 8, 6);

  @override
  Component build(BuildContext context) {
    return div(classes: 'dev-faq-grid', [
      _ExampleTile(
        label: 'Discrete slider',
        note: 'Native range input with discrete steps, a neo thumb, progress fill, and keyboard support.',
        child: DiscreteSlider(
          label: 'Difficulty',
          value: _sliderValue,
          min: 0,
          max: 10,
          step: 0.5,
          onChange: (value) {
            setState(() {
              _sliderValue = value;
            });
          },
        ),
      ),
      _ExampleTile(
        label: 'Checkbox',
        note:
            'Controlled boolean input. The square is custom, and the whole control is a button with checkbox semantics.',
        child: Checkbox(
          checked: _checked,
          label: .text('Show experimental packs'),
          onChange: (checked) {
            setState(() {
              _checked = checked;
            });
          },
        ),
      ),
      _ExampleTile(
        label: 'DropdownEditField<T>',
        note: 'Searchable generic combobox. Class-backed items use itemAsString for display and filtering.',
        child: DropdownEditField<_FaqAudience>(
          id: 'faq-audience-dropdown',
          items: _audiences,
          value: _selectedAudience,
          placeholder: 'Choose audience',
          itemAsString: (item) => item.title,
          onChange: (item) {
            setState(() {
              _selectedAudience = item;
            });
          },
        ),
      ),
      _ExampleTile(
        label: 'DatePicker',
        note: 'Month arrows move the day grid. Click the month/year pill to switch into month and year selection.',
        child: DatePicker(
          value: _selectedDate,
          firstDate: DateTime(2000, 1, 1),
          lastDate: DateTime(2026, 12, 31),
          onChange: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
        ),
      ),
      _ExampleTile(
        label: 'Disabled controls',
        note: 'Disabled styling is dimmed but keeps the same border, shadow, and typography language.',
        child: div(classes: 'dev-faq-stack', [
          DiscreteSlider(
            label: 'Locked',
            value: 6,
            min: 0,
            max: 10,
            step: 1,
            disabled: true,
            onChange: (_) {},
          ),
          Checkbox(
            checked: false,
            disabled: true,
            label: .text('Unavailable toggle'),
            onChange: (_) {},
          ),
          DropdownEditField<String>(
            id: 'faq-disabled-dropdown',
            items: const ['Alpha', 'Beta', 'Gamma'],
            value: 'Beta',
            disabled: true,
            onChange: (_) {},
          ),
        ]),
      ),
    ]);
  }
}

class _FaqAudience {
  const _FaqAudience(this.title);

  final String title;
}

const _audiences = [
  _FaqAudience('Students'),
  _FaqAudience('Teachers'),
  _FaqAudience('Package authors'),
  _FaqAudience('Moderators'),
];

class _Section extends StatelessComponent {
  const _Section({
    required this.title,
    required this.description,
    required this.children,
  });

  final String title;
  final String description;
  final List<Component> children;

  @override
  Component build(BuildContext context) {
    return section(classes: 'dev-faq-section', [
      div(classes: 'dev-faq-stack', [
        h2(
          styles: NeoStyles.text(
            family: NeoTokens.fontDisplay,
            size: 1.6,
            weight: FontWeight.w900,
          ),
          [.text(title)],
        ),
        p(classes: 'dev-faq-note', [.text(description)]),
      ]),
      ...children,
    ]);
  }
}

class _ExampleTile extends StatelessComponent {
  const _ExampleTile({
    required this.label,
    required this.note,
    required this.child,
  });

  final String label;
  final String note;
  final Component child;

  @override
  Component build(BuildContext context) {
    return NeoCard(
      interactive: false,
      children: [
        _Label(label),
        child,
        _sampleNote(note),
      ],
    );
  }
}

class _Label extends StatelessComponent {
  const _Label(this.text);

  final String text;

  @override
  Component build(BuildContext context) {
    return span(
      styles: Styles(display: Display.inlineFlex),
      [
        NeoBadge(label: text, tone: NeoBadgeTone.neutral),
      ],
    );
  }
}

class _CodeBlock extends StatelessComponent {
  const _CodeBlock(this.text);

  final String text;

  @override
  Component build(BuildContext context) {
    return code(classes: 'dev-faq-code', [.text(text.trim())]);
  }
}

class _SampleExplanation extends StatelessComponent {
  const _SampleExplanation({
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Component build(BuildContext context) {
    return NeoCard(
      interactive: false,
      styles: Styles(backgroundColor: AppTheme.inputBackground),
      children: [
        _sampleTitle(title),
        _sampleNote(text),
      ],
    );
  }
}

Component _sampleTitle(String text) {
  return h3(
    styles: NeoStyles.text(
      family: NeoTokens.fontDisplay,
      size: 1.1,
      weight: FontWeight.w800,
    ),
    [.text(text)],
  );
}

Component _sampleNote(String text) {
  return p(classes: 'dev-faq-note', [.text(text)]);
}
