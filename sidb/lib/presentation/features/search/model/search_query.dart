import 'package:jaspr/jaspr.dart' show immutable;
import 'package:sidb/config/localization/l10n/l10n.g.dart';
import 'package:sidb/presentation/features/pack/model/author/author.dart';
import 'package:sidb/presentation/features/pack/model/game_type/game_type.dart';
import 'package:sidb/presentation/features/pack/model/pack/pack.dart';
import 'package:sidb/presentation/features/pack/model/target_audience/target_audience.dart';

/// The section of the search screen the user is currently in.
enum SearchEntity { tournaments, topics, questions, authors }

extension SearchEntityMeta on SearchEntity {
  String label(Translations t) => switch (this) {
    SearchEntity.questions => t.searchEntityQuestions,
    SearchEntity.topics => t.searchEntityTopics,
    SearchEntity.tournaments => t.searchEntityTournaments,
    SearchEntity.authors => t.searchEntityAuthors,
  };

  String placeholder(Translations t) => switch (this) {
    SearchEntity.questions => t.searchPlaceholderQuestions,
    SearchEntity.topics => t.searchPlaceholderTopics,
    SearchEntity.tournaments => t.searchPlaceholderTournaments,
    SearchEntity.authors => t.searchPlaceholderAuthors,
  };

  String get slug => switch (this) {
    SearchEntity.questions => 'questions',
    SearchEntity.topics => 'topics',
    SearchEntity.tournaments => 'tournaments',
    SearchEntity.authors => 'authors',
  };

  static SearchEntity fromSlug(String? slug) => switch (slug) {
    'questions' => SearchEntity.questions,
    'authors' => SearchEntity.authors,
    'topics' => SearchEntity.topics,
    _ => SearchEntity.tournaments,
  };
}

/// Which fields inside a topic/question the free-text query should
/// match against. Persisted in the URL so shared links restore the
/// exact scope selection.
enum SearchScope { title, question, answer, comment, source }

extension SearchScopeMeta on SearchScope {
  String label(Translations t) => switch (this) {
    SearchScope.title => t.searchScopeTitle,
    SearchScope.question => t.searchScopeQuestion,
    SearchScope.answer => t.searchScopeAnswer,
    SearchScope.comment => t.searchScopeComment,
    SearchScope.source => t.searchScopeSource,
  };

  String get slug => name;

  static Set<SearchScope> parse(String? raw) {
    if (raw == null || raw.isEmpty) return const <SearchScope>{};
    final byName = {for (final v in SearchScope.values) v.name: v};
    final out = <SearchScope>{};
    for (final part in raw.split(',')) {
      final value = byName[part.trim()];
      if (value != null) out.add(value);
    }
    return out;
  }

  /// Topic and question searches expose the scope picker in the UI:
  /// their results aggregate over a topic/question body, so it's
  /// meaningful to choose which parts to match against. Other
  /// sections search a single field (pack title, author name).
  static bool appliesTo(SearchEntity entity) => entity == SearchEntity.topics || entity == SearchEntity.questions;

  /// Default scope set when the user hasn't picked any — matches the
  /// most obvious field for the section so the search still returns
  /// results before the user touches the checkboxes.
  static Set<SearchScope> defaultsFor(SearchEntity entity) => switch (entity) {
    SearchEntity.topics => const {SearchScope.title},
    SearchEntity.questions => const {SearchScope.question},
    _ => const {SearchScope.title},
  };
}

/// Where a tournament was held. Not yet backed by the pack model — the
/// filter is surfaced to the user but only narrows results once packs
/// carry a venue field.
enum SearchVenue { any, online, offline }

extension SearchVenueSerde on SearchVenue {
  String? get param => switch (this) {
    SearchVenue.any => null,
    SearchVenue.online => 'online',
    SearchVenue.offline => 'offline',
  };

  static SearchVenue fromParam(String? value) => switch (value) {
    'online' => SearchVenue.online,
    'offline' => SearchVenue.offline,
    _ => SearchVenue.any,
  };
}

/// Sort orders available across sections. Each entity exposes its own
/// subset via [SearchSort.optionsFor].
enum SearchSort {
  relevance,
  newest,
  oldest,
  mostLiked,
  titleAsc,
  titleDesc,
  authorAsc,
  authorDesc,
  authorPacks,
}

extension SearchSortMeta on SearchSort {
  String label(Translations t) => switch (this) {
    SearchSort.relevance => t.searchSortRelevance,
    SearchSort.newest => t.searchSortNewest,
    SearchSort.oldest => t.searchSortOldest,
    SearchSort.mostLiked => t.searchSortLikes,
    SearchSort.titleAsc => t.searchSortTitleAsc,
    SearchSort.titleDesc => t.searchSortTitleDesc,
    SearchSort.authorAsc => t.searchSortAuthorAsc,
    SearchSort.authorDesc => t.searchSortAuthorDesc,
    SearchSort.authorPacks => t.searchSortAuthorPacks,
  };

  String get slug => name;

  static SearchSort fromSlug(String? slug, SearchEntity entity) {
    final options = optionsFor(entity);
    for (final option in options) {
      if (option.name == slug) return option;
    }
    return options.first;
  }

  static List<SearchSort> optionsFor(SearchEntity entity) => switch (entity) {
    SearchEntity.questions => const [
      SearchSort.relevance,
      SearchSort.newest,
      SearchSort.oldest,
      SearchSort.mostLiked,
      SearchSort.titleAsc,
      SearchSort.titleDesc,
    ],
    SearchEntity.topics => const [
      SearchSort.relevance,
      SearchSort.titleAsc,
      SearchSort.titleDesc,
    ],
    SearchEntity.tournaments => const [
      SearchSort.relevance,
      SearchSort.newest,
      SearchSort.oldest,
      SearchSort.mostLiked,
      SearchSort.titleAsc,
      SearchSort.titleDesc,
    ],
    SearchEntity.authors => const [
      SearchSort.authorAsc,
      SearchSort.authorDesc,
      SearchSort.authorPacks,
    ],
  };
}

/// Immutable snapshot of the search state, mirrored to and from the URL
/// query string. Rebuilding the page from URL params keeps the URL as
/// the single source of truth so shared links restore the exact view.
@immutable
class SearchQuery {
  const SearchQuery({
    this.entity = SearchEntity.tournaments,
    this.query = '',
    this.audiences = const <TargetAudience>{},
    this.gameTypes = const <GameType>{},
    this.playFrom,
    this.playTo,
    this.topicsMin,
    this.topicsMax,
    this.venue = SearchVenue.any,
    this.sort = SearchSort.relevance,
    this.scopes = const <SearchScope>{},
  });

  final SearchEntity entity;
  final String query;
  final Set<TargetAudience> audiences;
  final Set<GameType> gameTypes;
  final DateTime? playFrom;
  final DateTime? playTo;
  final int? topicsMin;
  final int? topicsMax;
  final SearchVenue venue;
  final SearchSort sort;

  /// Selected search scopes. Empty means "use the section defaults"
  /// (see [SearchScopeMeta.defaultsFor]); resolved lookups should go
  /// through [effectiveScopes].
  final Set<SearchScope> scopes;

  Set<SearchScope> get effectiveScopes => scopes.isEmpty ? SearchScopeMeta.defaultsFor(entity) : scopes;

  factory SearchQuery.fromParams(Map<String, String> params) {
    final entity = SearchEntityMeta.fromSlug(params['type']);
    return SearchQuery(
      entity: entity,
      query: params['q']?.trim() ?? '',
      audiences: _parseEnums(params['audiences'], TargetAudience.values),
      gameTypes: _parseEnums(params['gameTypes'], GameType.values),
      playFrom: _parseDate(params['playFrom']),
      playTo: _parseDate(params['playTo']),
      topicsMin: int.tryParse(params['topicsMin'] ?? ''),
      topicsMax: int.tryParse(params['topicsMax'] ?? ''),
      venue: SearchVenueSerde.fromParam(params['venue']),
      sort: SearchSortMeta.fromSlug(params['sort'], entity),
      scopes: SearchScopeMeta.parse(params['scopes']),
    );
  }

  Map<String, String> toParams() {
    final map = <String, String>{'type': entity.slug};
    if (query.isNotEmpty) map['q'] = query;
    if (audiences.isNotEmpty) {
      map['audiences'] = audiences.map((a) => a.name).join(',');
    }
    if (gameTypes.isNotEmpty) {
      map['gameTypes'] = gameTypes.map((g) => g.name).join(',');
    }
    if (playFrom != null) map['playFrom'] = _formatDate(playFrom!);
    if (playTo != null) map['playTo'] = _formatDate(playTo!);
    if (topicsMin != null) map['topicsMin'] = '${topicsMin!}';
    if (topicsMax != null) map['topicsMax'] = '${topicsMax!}';
    final venueParam = venue.param;
    if (venueParam != null) map['venue'] = venueParam;
    if (sort != SearchSortMeta.optionsFor(entity).first) {
      map['sort'] = sort.slug;
    }
    if (scopes.isNotEmpty) {
      map['scopes'] = scopes.map((s) => s.name).join(',');
    }
    return map;
  }

  String toUrl() {
    final params = toParams();
    if (params.length == 1 && params['type'] == SearchEntity.tournaments.slug) {
      return '/search';
    }
    return Uri(path: '/search', queryParameters: params).toString();
  }

  /// Returns a copy with the given fields replaced. Passing `null` for
  /// a field clears it (the nullable-tracking booleans keep semantics
  /// explicit when the caller wants to unset dates/counts).
  SearchQuery copyWith({
    SearchEntity? entity,
    String? query,
    Set<TargetAudience>? audiences,
    Set<GameType>? gameTypes,
    DateTime? playFrom,
    bool clearPlayFrom = false,
    DateTime? playTo,
    bool clearPlayTo = false,
    int? topicsMin,
    bool clearTopicsMin = false,
    int? topicsMax,
    bool clearTopicsMax = false,
    SearchVenue? venue,
    SearchSort? sort,
    Set<SearchScope>? scopes,
  }) {
    return SearchQuery(
      entity: entity ?? this.entity,
      query: query ?? this.query,
      audiences: audiences ?? this.audiences,
      gameTypes: gameTypes ?? this.gameTypes,
      playFrom: clearPlayFrom ? null : (playFrom ?? this.playFrom),
      playTo: clearPlayTo ? null : (playTo ?? this.playTo),
      topicsMin: clearTopicsMin ? null : (topicsMin ?? this.topicsMin),
      topicsMax: clearTopicsMax ? null : (topicsMax ?? this.topicsMax),
      venue: venue ?? this.venue,
      sort: sort ?? this.sort,
      scopes: scopes ?? this.scopes,
    );
  }

  /// Switches to a different entity, keeping the free-text query and
  /// venue but dropping filters that don't apply to the new section and
  /// resetting sort to that section's default.
  SearchQuery withEntity(SearchEntity next) {
    if (next == entity) return this;
    return SearchQuery(
      entity: next,
      query: query,
      // Venue only applies to tournaments; drop it elsewhere so it
      // doesn't silently linger in the URL.
      venue: next == SearchEntity.tournaments ? venue : SearchVenue.any,
      sort: SearchSortMeta.optionsFor(next).first,
      // Drop the scope selection when moving to a section that doesn't
      // expose the picker — otherwise it would silently linger in the
      // URL and re-apply if the user came back.
      scopes: SearchScopeMeta.appliesTo(next) ? scopes : const <SearchScope>{},
    );
  }

  bool get hasFilters =>
      audiences.isNotEmpty ||
      gameTypes.isNotEmpty ||
      playFrom != null ||
      playTo != null ||
      topicsMin != null ||
      topicsMax != null ||
      venue != SearchVenue.any ||
      scopes.isNotEmpty ||
      sort != SearchSortMeta.optionsFor(entity).first;

  static Set<T> _parseEnums<T extends Enum>(String? raw, List<T> values) {
    if (raw == null || raw.isEmpty) return <T>{};
    final byName = {for (final v in values) v.name: v};
    final out = <T>{};
    for (final part in raw.split(',')) {
      final value = byName[part.trim()];
      if (value != null) out.add(value);
    }
    return out;
  }

  static DateTime? _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  static String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}

/// A grouped view of packs authored by the same person, built on the
/// fly from the packs list so the /authors search section can render
/// author cards without a dedicated author endpoint.
@immutable
class AuthorSummary {
  const AuthorSummary({
    required this.author,
    required this.packsCount,
    required this.totalTopics,
    required this.totalLikes,
    required this.latestPlayDate,
  });

  final Author author;
  final int packsCount;
  final int totalTopics;
  final int totalLikes;
  final DateTime? latestPlayDate;

  static List<AuthorSummary> fromPacks(List<Pack> packs) {
    final byId = <String, _AuthorAccumulator>{};
    for (final pack in packs) {
      for (final author in pack.authors) {
        final acc = byId.putIfAbsent(author.id, () => _AuthorAccumulator(author));
        acc.add(pack);
      }
    }
    return byId.values.map((a) => a.build()).toList();
  }
}

class _AuthorAccumulator {
  _AuthorAccumulator(this.author);

  final Author author;
  int packs = 0;
  int topics = 0;
  int likes = 0;
  DateTime? latest;

  void add(Pack pack) {
    packs += 1;
    topics += pack.topicsCount;
    likes += pack.likesCount;
    final latestSoFar = latest;
    if (latestSoFar == null || pack.playDate.isAfter(latestSoFar)) {
      latest = pack.playDate;
    }
  }

  AuthorSummary build() => AuthorSummary(
    author: author,
    packsCount: packs,
    totalTopics: topics,
    totalLikes: likes,
    latestPlayDate: latest,
  );
}
