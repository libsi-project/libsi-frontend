import 'package:json_annotation/json_annotation.dart';
import 'package:sidb/config/localization/l10n/l10n.g.dart';

/// Game type (тип игры) for a pack — the format of the tournament
/// the questions were written for.
enum GameType {
  @JsonValue('erudite_quartet')
  eruditeQuartet,
  @JsonValue('erudite_sextet')
  eruditeSextet,
  @JsonValue('isi')
  isi,
  @JsonValue('ksi')
  ksi,
  @JsonValue('other')
  other,
}

extension GameTypeLabel on GameType {
  String label(Translations t) => switch (this) {
    GameType.eruditeQuartet => t.gameTypeEruditeQuartet,
    GameType.eruditeSextet => t.gameTypeEruditeSextet,
    GameType.isi => t.gameTypeIsi,
    GameType.ksi => t.gameTypeKsi,
    GameType.other => t.gameTypeOther,
  };
}
