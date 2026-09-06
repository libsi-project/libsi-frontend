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

	/// ru: 'Меню'
	String get menu => 'Меню';

	/// ru: 'Открыть меню'
	String get openMenu => 'Открыть меню';

	/// ru: 'Закрыть меню'
	String get closeMenu => 'Закрыть меню';

	/// ru: 'Введите запрос и нажмите Enter, чтобы найти пакет'
	String get searchPrompt => 'Введите запрос и нажмите Enter, чтобы найти пакет';

	/// ru: 'По запросу ничего не найдено'
	String get searchNoResults => 'По запросу ничего не найдено';

	/// ru: 'Результаты поиска: «${query}»'
	String searchResultsFor({required Object query}) => 'Результаты поиска: «${query}»';

	/// ru: 'НЕ НАЙДЕНО'
	String get notFoundBadge => 'НЕ НАЙДЕНО';

	/// ru: 'Страница потерялась'
	String get notFoundHeading => 'Страница потерялась';

	/// ru: 'Ссылка могла устареть, или путь написан с ошибкой.'
	String get notFoundMessage => 'Ссылка могла устареть, или путь написан с ошибкой.';

	/// ru: 'На главную'
	String get notFoundGoHome => 'На главную';

	/// ru: 'Искать пакеты'
	String get notFoundGoSearch => 'Искать пакеты';

	/// ru: 'Школьники'
	String get audienceSchooler => 'Школьники';

	/// ru: 'Студенты'
	String get audienceStudent => 'Студенты';

	/// ru: 'Взрослые'
	String get audienceAdult => 'Взрослые';

	/// ru: 'Эрудит-Квартет'
	String get gameTypeEruditeQuartet => 'Эрудит-Квартет';

	/// ru: 'Эрудит-Сикстет'
	String get gameTypeEruditeSextet => 'Эрудит-Сикстет';

	/// ru: 'ИСИ'
	String get gameTypeIsi => 'ИСИ';

	/// ru: 'КСИ'
	String get gameTypeKsi => 'КСИ';

	/// ru: 'Иное'
	String get gameTypeOther => 'Иное';

	/// ru: 'Показать ответ'
	String get showAnswer => 'Показать ответ';

	/// ru: 'Скрыть ответ'
	String get hideAnswer => 'Скрыть ответ';

	/// ru: 'Нравится'
	String get packLike => 'Нравится';

	/// ru: 'Не нравится'
	String get packDislike => 'Не нравится';

	/// ru: 'В избранное'
	String get packBookmark => 'В избранное';

	/// ru: 'Информация'
	String get packInfo => 'Информация';

	/// ru: 'Открыть табло'
	String get packOpenScoreboard => 'Открыть табло';

	/// ru: 'Закрыть табло'
	String get packCloseScoreboard => 'Закрыть табло';

	/// ru: 'Нужен вход'
	String get loginRequiredTitle => 'Нужен вход';

	/// ru: 'Чтобы поставить оценку или добавить в избранное, войдите в аккаунт.'
	String get loginRequiredMessage => 'Чтобы поставить оценку или добавить в избранное, войдите в аккаунт.';

	/// ru: 'Войти'
	String get loginNow => 'Войти';

	/// ru: 'Позже'
	String get loginLater => 'Позже';

	/// ru: 'Темы'
	String get topicsHeading => 'Темы';

	/// ru: 'Оглавление'
	String get openContents => 'Оглавление';

	/// ru: 'Закрыть оглавление'
	String get closeContents => 'Закрыть оглавление';

	/// ru: 'Табло счёта'
	String get scoreboardTitle => 'Табло счёта';

	/// ru: 'Добавить игрока'
	String get scoreboardAddPlayer => 'Добавить игрока';

	/// ru: 'Удалить игрока'
	String get scoreboardRemovePlayer => 'Удалить игрока';

	/// ru: 'Игрок'
	String get scoreboardPlayerNamePlaceholder => 'Игрок';

	/// ru: 'Прибавить'
	String get scoreboardIncrease => 'Прибавить';

	/// ru: 'Отнять'
	String get scoreboardDecrease => 'Отнять';

	/// ru: 'Номинал'
	String get scoreboardNominal => 'Номинал';

	/// ru: 'Ответ'
	String get questionAnswer => 'Ответ';

	/// ru: 'Зачёт'
	String get questionAdditionalAnswers => 'Зачёт';

	/// ru: 'Незачёт'
	String get questionWrongAnswers => 'Незачёт';

	/// ru: 'Комментарий'
	String get questionComment => 'Комментарий';

	/// ru: 'Источник'
	String get questionSource => 'Источник';

	/// ru: 'Скопировать ссылку на тему'
	String get topicShare => 'Скопировать ссылку на тему';

	/// ru: 'Добавить тему в избранное'
	String get topicBookmark => 'Добавить тему в избранное';

	/// ru: 'Ссылка на тему скопирована'
	String get topicLinkCopied => 'Ссылка на тему скопирована';

	/// ru: 'Не получилось скопировать ссылку'
	String get topicLinkCopyFailed => 'Не получилось скопировать ссылку';
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
			'menu' => 'Меню',
			'openMenu' => 'Открыть меню',
			'closeMenu' => 'Закрыть меню',
			'searchPrompt' => 'Введите запрос и нажмите Enter, чтобы найти пакет',
			'searchNoResults' => 'По запросу ничего не найдено',
			'searchResultsFor' => ({required Object query}) => 'Результаты поиска: «${query}»',
			'notFoundBadge' => 'НЕ НАЙДЕНО',
			'notFoundHeading' => 'Страница потерялась',
			'notFoundMessage' => 'Ссылка могла устареть, или путь написан с ошибкой.',
			'notFoundGoHome' => 'На главную',
			'notFoundGoSearch' => 'Искать пакеты',
			'audienceSchooler' => 'Школьники',
			'audienceStudent' => 'Студенты',
			'audienceAdult' => 'Взрослые',
			'gameTypeEruditeQuartet' => 'Эрудит-Квартет',
			'gameTypeEruditeSextet' => 'Эрудит-Сикстет',
			'gameTypeIsi' => 'ИСИ',
			'gameTypeKsi' => 'КСИ',
			'gameTypeOther' => 'Иное',
			'showAnswer' => 'Показать ответ',
			'hideAnswer' => 'Скрыть ответ',
			'packLike' => 'Нравится',
			'packDislike' => 'Не нравится',
			'packBookmark' => 'В избранное',
			'packInfo' => 'Информация',
			'packOpenScoreboard' => 'Открыть табло',
			'packCloseScoreboard' => 'Закрыть табло',
			'loginRequiredTitle' => 'Нужен вход',
			'loginRequiredMessage' => 'Чтобы поставить оценку или добавить в избранное, войдите в аккаунт.',
			'loginNow' => 'Войти',
			'loginLater' => 'Позже',
			'topicsHeading' => 'Темы',
			'openContents' => 'Оглавление',
			'closeContents' => 'Закрыть оглавление',
			'scoreboardTitle' => 'Табло счёта',
			'scoreboardAddPlayer' => 'Добавить игрока',
			'scoreboardRemovePlayer' => 'Удалить игрока',
			'scoreboardPlayerNamePlaceholder' => 'Игрок',
			'scoreboardIncrease' => 'Прибавить',
			'scoreboardDecrease' => 'Отнять',
			'scoreboardNominal' => 'Номинал',
			'questionAnswer' => 'Ответ',
			'questionAdditionalAnswers' => 'Зачёт',
			'questionWrongAnswers' => 'Незачёт',
			'questionComment' => 'Комментарий',
			'questionSource' => 'Источник',
			'topicShare' => 'Скопировать ссылку на тему',
			'topicBookmark' => 'Добавить тему в избранное',
			'topicLinkCopied' => 'Ссылка на тему скопирована',
			'topicLinkCopyFailed' => 'Не получилось скопировать ссылку',
			_ => null,
		};
	}
}
