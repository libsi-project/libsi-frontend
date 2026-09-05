import 'package:json_annotation/json_annotation.dart';
import 'package:sidb/config/localization/l10n/l10n.g.dart';

/// Target audience for a pack (Целевая аудитория).
///
/// Packs support a multi-select of audiences (a set may include any
/// combination — e.g. a pack aimed at both students and adults).
enum TargetAudience {
  @JsonValue('schooler')
  schooler,
  @JsonValue('student')
  student,
  @JsonValue('adult')
  adult,
}

extension TargetAudienceLabel on TargetAudience {
  String label(Translations t) => switch (this) {
    TargetAudience.schooler => t.audienceSchooler,
    TargetAudience.student => t.audienceStudent,
    TargetAudience.adult => t.audienceAdult,
  };
}
