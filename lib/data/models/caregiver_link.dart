import 'package:freezed_annotation/freezed_annotation.dart';

part 'caregiver_link.freezed.dart';
part 'caregiver_link.g.dart';

@freezed
abstract class CaregiverLink with _$CaregiverLink {
  const factory CaregiverLink({
    required String id,
    required String patientId,
    required String caregiverId,
    required String caregiverName,
    @Default('connected') String status,
    required DateTime linkedAt,
  }) = _CaregiverLink;

  factory CaregiverLink.fromJson(Map<String, dynamic> json) =>
      _$CaregiverLinkFromJson(json);
}
