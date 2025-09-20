// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'steam_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SteamApiResponseImpl _$$SteamApiResponseImplFromJson(
  Map<String, dynamic> json,
) => _$SteamApiResponseImpl(
  success: json['success'] as bool,
  error: json['error'] as String?,
);

Map<String, dynamic> _$$SteamApiResponseImplToJson(
  _$SteamApiResponseImpl instance,
) => <String, dynamic>{'success': instance.success, 'error': instance.error};
