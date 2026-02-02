// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'caregiver_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CaregiverLink _$CaregiverLinkFromJson(Map<String, dynamic> json) =>
    _CaregiverLink(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      caregiverId: json['caregiverId'] as String,
      caregiverName: json['caregiverName'] as String,
      status: json['status'] as String? ?? 'connected',
      linkedAt: DateTime.parse(json['linkedAt'] as String),
    );

Map<String, dynamic> _$CaregiverLinkToJson(_CaregiverLink instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientId': instance.patientId,
      'caregiverId': instance.caregiverId,
      'caregiverName': instance.caregiverName,
      'status': instance.status,
      'linkedAt': instance.linkedAt.toIso8601String(),
    };
