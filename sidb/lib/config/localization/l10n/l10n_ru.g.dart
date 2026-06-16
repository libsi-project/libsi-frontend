///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'l10n.g.dart';

// Path: <root>
typedef TranslationsRu = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ru,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ru>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// ru: 'Пакеты'
	String get packages => 'Пакеты';

	/// ru: 'Поиск'
	String get search => 'Поиск';

	/// ru: 'Авторы'
	String get authors => 'Авторы';

	/// ru: 'Избранное'
	String get favorites => 'Избранное';

	/// ru: 'О сайте'
	String get about => 'О сайте';

	/// ru: 'Поиск пакетов...'
	String get search_packages => 'Поиск пакетов...';

	/// ru: 'Добавлен'
	String get added => 'Добавлен';

	/// ru: '(one) {$n ТЕМА} (few) {$n ТЕМЫ} (many) {$n ТЕМ} (other) {$n ТЕМ}'
	String topics_count({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: '${n} ТЕМА',
		few: '${n} ТЕМЫ',
		many: '${n} ТЕМ',
		other: '${n} ТЕМ',
	);
}

/// The flat map containing all translations for locale <ru>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'packages' => 'Пакеты',
			'search' => 'Поиск',
			'authors' => 'Авторы',
			'favorites' => 'Избранное',
			'about' => 'О сайте',
			'search_packages' => 'Поиск пакетов...',
			'added' => 'Добавлен',
			'topics_count' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: '${n} ТЕМА', few: '${n} ТЕМЫ', many: '${n} ТЕМ', other: '${n} ТЕМ', ), 
			_ => null,
		};
	}
}
