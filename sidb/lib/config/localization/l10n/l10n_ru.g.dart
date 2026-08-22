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

	/// ru: 'Developer FAQ'
	String get developerFaq => 'Developer FAQ';

	/// ru: 'Dev FAQ'
	String get developerFaqNav => 'Dev FAQ';

	/// ru: 'Поиск пакетов...'
	String get searchPackages => 'Поиск пакетов...';

	/// ru: 'Добавлен'
	String get added => 'Добавлен';

	/// ru: '(one) {$n ТЕМА} (few) {$n ТЕМЫ} (many) {$n ТЕМ} (other) {$n ТЕМ}'
	String topicsCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: '${n} ТЕМА',
		few: '${n} ТЕМЫ',
		many: '${n} ТЕМ',
		other: '${n} ТЕМ',
	);

	/// ru: 'О сайте'
	String get aboutSite => 'О сайте';

	/// ru: 'FAQ'
	String get faq => 'FAQ';

	/// ru: 'Обратная связь'
	String get contact => 'Обратная связь';

	/// ru: 'Лицензирование'
	String get licensing => 'Лицензирование';

	/// ru: 'Политика конфиденциальности'
	String get privacy => 'Политика конфиденциальности';

	/// ru: 'Copyright © 2026 - All right reserved by Kekers))))'
	String get copyright => 'Copyright © 2026 - All right reserved by Kekers))))';

	/// ru: 'добавлен вчера'
	String get addedYesterday => 'добавлен вчера';

	/// ru: 'Загружаем пакеты...'
	String get loadingPacks => 'Загружаем пакеты...';

	/// ru: 'Не удалось загрузить пакеты'
	String get packsLoadError => 'Не удалось загрузить пакеты';

	/// ru: 'Пакеты пока не найдены'
	String get emptyPacks => 'Пакеты пока не найдены';

	/// ru: 'SIDB собирает пакеты для интеллектуальных игр и помогает быстро находить материалы по теме, сложности и авторам.'
	String get aboutDescription => 'SIDB собирает пакеты для интеллектуальных игр и помогает быстро находить материалы по теме, сложности и авторам.';

	/// ru: 'Раздел скоро появится'
	String get comingSoon => 'Раздел скоро появится';

	/// ru: 'г.'
	String get datePickerYearSuffix => 'г.';

	/// ru: 'Предыдущий месяц'
	String get datePickerPreviousMonth => 'Предыдущий месяц';

	/// ru: 'Предыдущий год'
	String get datePickerPreviousYear => 'Предыдущий год';

	/// ru: 'Следующий месяц'
	String get datePickerNextMonth => 'Следующий месяц';

	/// ru: 'Следующий год'
	String get datePickerNextYear => 'Следующий год';
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
			'developerFaq' => 'Developer FAQ',
			'developerFaqNav' => 'Dev FAQ',
			'searchPackages' => 'Поиск пакетов...',
			'added' => 'Добавлен',
			'topicsCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: '${n} ТЕМА', few: '${n} ТЕМЫ', many: '${n} ТЕМ', other: '${n} ТЕМ', ), 
			'aboutSite' => 'О сайте',
			'faq' => 'FAQ',
			'contact' => 'Обратная связь',
			'licensing' => 'Лицензирование',
			'privacy' => 'Политика конфиденциальности',
			'copyright' => 'Copyright © 2026 - All right reserved by Kekers))))',
			'addedYesterday' => 'добавлен вчера',
			'loadingPacks' => 'Загружаем пакеты...',
			'packsLoadError' => 'Не удалось загрузить пакеты',
			'emptyPacks' => 'Пакеты пока не найдены',
			'aboutDescription' => 'SIDB собирает пакеты для интеллектуальных игр и помогает быстро находить материалы по теме, сложности и авторам.',
			'comingSoon' => 'Раздел скоро появится',
			'datePickerYearSuffix' => 'г.',
			'datePickerPreviousMonth' => 'Предыдущий месяц',
			'datePickerPreviousYear' => 'Предыдущий год',
			'datePickerNextMonth' => 'Следующий месяц',
			'datePickerNextYear' => 'Следующий год',
			_ => null,
		};
	}
}
