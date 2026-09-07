import 'package:jaspr/jaspr.dart' show immutable;
import 'package:sidb/config/localization/l10n/l10n.g.dart';
import 'package:sidb/presentation/features/pack/model/author/author.dart';
import 'package:sidb/presentation/features/pack/model/game_type/game_type.dart';
import 'package:sidb/presentation/features/pack/model/pack/pack.dart';
import 'package:sidb/presentation/features/pack/model/target_audience/target_audience.dart';

/// The section of the search screen the user is currently in.
enum SearchEntity { questions, tournaments, authors }

extension SearchEntityMeta on SearchEntity {
  String label(Translations t) => switch (this) {
    SearchEntity.questions => t.searchEntityQuestions,
    SearchEntity.tournaments => t.searchEntityTournaments,
    SearchEntity.authors => t.searchEntityAuthors,
  };

  String placeholder(Translations t) => switch (this) {
    SearchEntity.questions => t.searchPlaceholderQuestions,
    SearchEntity.tournaments => t.searchPlaceholderTournaments,
    SearchEntity.authors => t.searchPlaceholderAuthors,
  };

  String get slug => switch (this) {
    SearchEntity.questions => 'questions',
    SearchEntity.tournaments => 'tournaments',
    SearchEntity.authors => 'authors',
  };

  static SearchEntity fromSlug(String? slug) => switch (slug) {
    'tournaments' => SearchEntity.tournaments,
    'authors' => SearchEntity.authors,
    _ => SearchEntity.questions,
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
    this.entity = SearchEntity.questions,
    this.query = '',
    this.audiences = const <TargetAudience>{},
    this.gameTypes = const <GameType>{},
    this.playFrom,
    this.playTo,
    this.topicsMin,
    this.topicsMax,
    this.venue = SearchVenue.any,
    this.sort = SearchSort.relevance,
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
    return map;
  }

  String toUrl() {
    final params = toParams();
    if (params.length == 1 && params['type'] == SearchEntity.questions.slug) {
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
      venue: next == SearchEntity.authors ? SearchVenue.any : venue,
      sort: SearchSortMeta.optionsFor(next).first,
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
    required this.totalLikes,
    required this.latestPlayDate,
  });

  final Author author;
  final int packsCount;
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
  int likes = 0;
  DateTime? latest;

  void add(Pack pack) {
    packs += 1;
    likes += pack.likesCount;
    final latestSoFar = latest;
    if (latestSoFar == null || pack.playDate.isAfter(latestSoFar)) {
      latest = pack.playDate;
    }
  }

  AuthorSummary build() => AuthorSummary(
    author: author,
    packsCount: packs,
    totalLikes: likes,
    latestPlayDate: latest,
  );
}
