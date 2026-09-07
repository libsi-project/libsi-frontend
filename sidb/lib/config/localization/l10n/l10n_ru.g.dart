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

	/// ru: 'Очистить'
	String get datePickerClear => 'Очистить';

	/// ru: 'Сегодня'
	String get datePickerToday => 'Сегодня';

	/// ru: 'Убрать дату'
	String get datePickerClearField => 'Убрать дату';

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

	/// ru: 'Вопросы'
	String get searchEntityQuestions => 'Вопросы';

	/// ru: 'Темы'
	String get searchEntityTopics => 'Темы';

	/// ru: 'Турниры'
	String get searchEntityTournaments => 'Турниры';

	/// ru: 'Авторы'
	String get searchEntityAuthors => 'Авторы';

	/// ru: 'Поиск по вопросам…'
	String get searchPlaceholderQuestions => 'Поиск по вопросам…';

	/// ru: 'Поиск по темам…'
	String get searchPlaceholderTopics => 'Поиск по темам…';

	/// ru: 'Поиск по турнирам…'
	String get searchPlaceholderTournaments => 'Поиск по турнирам…';

	/// ru: 'Поиск по авторам…'
	String get searchPlaceholderAuthors => 'Поиск по авторам…';

	/// ru: 'Фильтры'
	String get searchOpenFilters => 'Фильтры';

	/// ru: 'Скрыть фильтры'
	String get searchCloseFilters => 'Скрыть фильтры';

	/// ru: 'Фильтры поиска'
	String get searchFiltersTitle => 'Фильтры поиска';

	/// ru: 'Свернуть фильтры'
	String get searchCollapseFiltersColumn => 'Свернуть фильтры';

	/// ru: 'Развернуть фильтры'
	String get searchExpandFiltersColumn => 'Развернуть фильтры';

	/// ru: 'Целевая аудитория'
	String get searchFilterAudience => 'Целевая аудитория';

	/// ru: 'Тип игры'
	String get searchFilterGameType => 'Тип игры';

	/// ru: 'Дата отыгрыша турнира'
	String get searchFilterPlayDateRange => 'Дата отыгрыша турнира';

	/// ru: 'От'
	String get searchFilterPlayDateFrom => 'От';

	/// ru: 'До'
	String get searchFilterPlayDateTo => 'До';

	/// ru: 'Количество тем в пакете'
	String get searchFilterTopicsRange => 'Количество тем в пакете';

	/// ru: 'От'
	String get searchFilterTopicsMin => 'От';

	/// ru: 'До'
	String get searchFilterTopicsMax => 'До';

	/// ru: 'Только онлайн-турниры'
	String get searchFilterOnlineOnly => 'Только онлайн-турниры';

	/// ru: 'Только очные турниры'
	String get searchFilterOfflineOnly => 'Только очные турниры';

	/// ru: 'Площадка'
	String get searchFilterVenue => 'Площадка';

	/// ru: '«От» не может быть позже «до»'
	String get searchFilterPlayDateFromAfterTo => '«От» не может быть позже «до»';

	/// ru: '«До» не может быть раньше «от»'
	String get searchFilterPlayDateToBeforeFrom => '«До» не может быть раньше «от»';

	/// ru: 'Любые'
	String get searchFilterVenueAny => 'Любые';

	/// ru: 'Онлайн'
	String get searchFilterVenueOnline => 'Онлайн';

	/// ru: 'Очно'
	String get searchFilterVenueOffline => 'Очно';

	/// ru: 'Сортировка'
	String get searchFilterSortLabel => 'Сортировка';

	/// ru: 'По релевантности'
	String get searchSortRelevance => 'По релевантности';

	/// ru: 'Сначала новые'
	String get searchSortNewest => 'Сначала новые';

	/// ru: 'Сначала старые'
	String get searchSortOldest => 'Сначала старые';

	/// ru: 'По количеству лайков'
	String get searchSortLikes => 'По количеству лайков';

	/// ru: 'По названию (А→Я)'
	String get searchSortTitleAsc => 'По названию (А→Я)';

	/// ru: 'По названию (Я→А)'
	String get searchSortTitleDesc => 'По названию (Я→А)';

	/// ru: 'По имени (А→Я)'
	String get searchSortAuthorAsc => 'По имени (А→Я)';

	/// ru: 'По имени (Я→А)'
	String get searchSortAuthorDesc => 'По имени (Я→А)';

	/// ru: 'По количеству пакетов'
	String get searchSortAuthorPacks => 'По количеству пакетов';

	/// ru: 'Применить'
	String get searchApplyFilters => 'Применить';

	/// ru: 'Сбросить'
	String get searchResetFilters => 'Сбросить';

	/// ru: '(one) {$n пакет} (few) {$n пакета} (many) {$n пакетов} (other) {$n пакетов}'
	String searchAuthorPacksCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: '${n} пакет',
		few: '${n} пакета',
		many: '${n} пакетов',
		other: '${n} пакетов',
	);

	/// ru: '(one) {$n тема} (few) {$n темы} (many) {$n тем} (other) {$n тем}'
	String searchAuthorTopicsCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: '${n} тема',
		few: '${n} темы',
		many: '${n} тем',
		other: '${n} тем',
	);

	/// ru: '$year г.'
	String searchYearOnly({required Object year}) => '${year} г.';

	/// ru: ' – '
	String get searchDateRangeSeparator => ' – ';

	/// ru: 'Турнир'
	String get searchQuestionFromTournament => 'Турнир';

	/// ru: 'Тема'
	String get searchQuestionFromTopic => 'Тема';

	/// ru: '(one) {$n вопрос} (few) {$n вопроса} (many) {$n вопросов} (other) {$n вопросов}'
	String searchTopicQuestionsCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		one: '${n} вопрос',
		few: '${n} вопроса',
		many: '${n} вопросов',
		other: '${n} вопросов',
	);

	/// ru: 'Искать в'
	String get searchFilterScopeLabel => 'Искать в';

	/// ru: 'Название'
	String get searchScopeTitle => 'Название';

	/// ru: 'Текст вопроса'
	String get searchScopeQuestion => 'Текст вопроса';

	/// ru: 'Ответ | Зачёт'
	String get searchScopeAnswer => 'Ответ | Зачёт';

	/// ru: 'Комментарии'
	String get searchScopeComment => 'Комментарии';

	/// ru: 'Источники'
	String get searchScopeSource => 'Источники';

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

	/// ru: 'Эрудит-Секстет'
	String get gameTypeEruditeSextet => 'Эрудит-Секстет';

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
			'datePickerClear' => 'Очистить',
			'datePickerToday' => 'Сегодня',
			'datePickerClearField' => 'Убрать дату',
			'menu' => 'Меню',
			'openMenu' => 'Открыть меню',
			'closeMenu' => 'Закрыть меню',
			'searchPrompt' => 'Введите запрос и нажмите Enter, чтобы найти пакет',
			'searchNoResults' => 'По запросу ничего не найдено',
			'searchResultsFor' => ({required Object query}) => 'Результаты поиска: «${query}»',
			'searchEntityQuestions' => 'Вопросы',
			'searchEntityTopics' => 'Темы',
			'searchEntityTournaments' => 'Турниры',
			'searchEntityAuthors' => 'Авторы',
			'searchPlaceholderQuestions' => 'Поиск по вопросам…',
			'searchPlaceholderTopics' => 'Поиск по темам…',
			'searchPlaceholderTournaments' => 'Поиск по турнирам…',
			'searchPlaceholderAuthors' => 'Поиск по авторам…',
			'searchOpenFilters' => 'Фильтры',
			'searchCloseFilters' => 'Скрыть фильтры',
			'searchFiltersTitle' => 'Фильтры поиска',
			'searchCollapseFiltersColumn' => 'Свернуть фильтры',
			'searchExpandFiltersColumn' => 'Развернуть фильтры',
			'searchFilterAudience' => 'Целевая аудитория',
			'searchFilterGameType' => 'Тип игры',
			'searchFilterPlayDateRange' => 'Дата отыгрыша турнира',
			'searchFilterPlayDateFrom' => 'От',
			'searchFilterPlayDateTo' => 'До',
			'searchFilterTopicsRange' => 'Количество тем в пакете',
			'searchFilterTopicsMin' => 'От',
			'searchFilterTopicsMax' => 'До',
			'searchFilterOnlineOnly' => 'Только онлайн-турниры',
			'searchFilterOfflineOnly' => 'Только очные турниры',
			'searchFilterVenue' => 'Площадка',
			'searchFilterPlayDateFromAfterTo' => '«От» не может быть позже «до»',
			'searchFilterPlayDateToBeforeFrom' => '«До» не может быть раньше «от»',
			'searchFilterVenueAny' => 'Любые',
			'searchFilterVenueOnline' => 'Онлайн',
			'searchFilterVenueOffline' => 'Очно',
			'searchFilterSortLabel' => 'Сортировка',
			'searchSortRelevance' => 'По релевантности',
			'searchSortNewest' => 'Сначала новые',
			'searchSortOldest' => 'Сначала старые',
			'searchSortLikes' => 'По количеству лайков',
			'searchSortTitleAsc' => 'По названию (А→Я)',
			'searchSortTitleDesc' => 'По названию (Я→А)',
			'searchSortAuthorAsc' => 'По имени (А→Я)',
			'searchSortAuthorDesc' => 'По имени (Я→А)',
			'searchSortAuthorPacks' => 'По количеству пакетов',
			'searchApplyFilters' => 'Применить',
			'searchResetFilters' => 'Сбросить',
			'searchAuthorPacksCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: '${n} пакет', few: '${n} пакета', many: '${n} пакетов', other: '${n} пакетов', ), 
			'searchAuthorTopicsCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: '${n} тема', few: '${n} темы', many: '${n} тем', other: '${n} тем', ), 
			'searchYearOnly' => ({required Object year}) => '${year} г.',
			'searchDateRangeSeparator' => ' – ',
			'searchQuestionFromTournament' => 'Турнир',
			'searchQuestionFromTopic' => 'Тема',
			'searchTopicQuestionsCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n, one: '${n} вопрос', few: '${n} вопроса', many: '${n} вопросов', other: '${n} вопросов', ), 
			'searchFilterScopeLabel' => 'Искать в',
			'searchScopeTitle' => 'Название',
			'searchScopeQuestion' => 'Текст вопроса',
			'searchScopeAnswer' => 'Ответ | Зачёт',
			'searchScopeComment' => 'Комментарии',
			'searchScopeSource' => 'Источники',
			'notFoundBadge' => 'НЕ НАЙДЕНО',
			'notFoundHeading' => 'Страница потерялась',
			'notFoundMessage' => 'Ссылка могла устареть, или путь написан с ошибкой.',
			'notFoundGoHome' => 'На главную',
			'notFoundGoSearch' => 'Искать пакеты',
			'audienceSchooler' => 'Школьники',
			'audienceStudent' => 'Студенты',
			'audienceAdult' => 'Взрослые',
			'gameTypeEruditeQuartet' => 'Эрудит-Квартет',
			'gameTypeEruditeSextet' => 'Эрудит-Секстет',
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
