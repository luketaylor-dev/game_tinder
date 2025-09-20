// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'steam_game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SteamGame {
  int get appId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get headerImageUrl => throw _privateConstructorUsedError;
  List<String> get genres => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  bool get isMultiplayer => throw _privateConstructorUsedError;
  int? get maxPlayers => throw _privateConstructorUsedError;
  List<String> get platforms => throw _privateConstructorUsedError;
  DateTime? get releaseDate => throw _privateConstructorUsedError;
  int? get playtimeMinutes => throw _privateConstructorUsedError;
  DateTime? get lastPlayedAt => throw _privateConstructorUsedError;

  /// Create a copy of SteamGame
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SteamGameCopyWith<SteamGame> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SteamGameCopyWith<$Res> {
  factory $SteamGameCopyWith(SteamGame value, $Res Function(SteamGame) then) =
      _$SteamGameCopyWithImpl<$Res, SteamGame>;
  @useResult
  $Res call({
    int appId,
    String name,
    String? description,
    String? imageUrl,
    String? headerImageUrl,
    List<String> genres,
    List<String> tags,
    bool isMultiplayer,
    int? maxPlayers,
    List<String> platforms,
    DateTime? releaseDate,
    int? playtimeMinutes,
    DateTime? lastPlayedAt,
  });
}

/// @nodoc
class _$SteamGameCopyWithImpl<$Res, $Val extends SteamGame>
    implements $SteamGameCopyWith<$Res> {
  _$SteamGameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SteamGame
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appId = null,
    Object? name = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? headerImageUrl = freezed,
    Object? genres = null,
    Object? tags = null,
    Object? isMultiplayer = null,
    Object? maxPlayers = freezed,
    Object? platforms = null,
    Object? releaseDate = freezed,
    Object? playtimeMinutes = freezed,
    Object? lastPlayedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            appId: null == appId
                ? _value.appId
                : appId // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            headerImageUrl: freezed == headerImageUrl
                ? _value.headerImageUrl
                : headerImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            genres: null == genres
                ? _value.genres
                : genres // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isMultiplayer: null == isMultiplayer
                ? _value.isMultiplayer
                : isMultiplayer // ignore: cast_nullable_to_non_nullable
                      as bool,
            maxPlayers: freezed == maxPlayers
                ? _value.maxPlayers
                : maxPlayers // ignore: cast_nullable_to_non_nullable
                      as int?,
            platforms: null == platforms
                ? _value.platforms
                : platforms // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            releaseDate: freezed == releaseDate
                ? _value.releaseDate
                : releaseDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            playtimeMinutes: freezed == playtimeMinutes
                ? _value.playtimeMinutes
                : playtimeMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            lastPlayedAt: freezed == lastPlayedAt
                ? _value.lastPlayedAt
                : lastPlayedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SteamGameImplCopyWith<$Res>
    implements $SteamGameCopyWith<$Res> {
  factory _$$SteamGameImplCopyWith(
    _$SteamGameImpl value,
    $Res Function(_$SteamGameImpl) then,
  ) = __$$SteamGameImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int appId,
    String name,
    String? description,
    String? imageUrl,
    String? headerImageUrl,
    List<String> genres,
    List<String> tags,
    bool isMultiplayer,
    int? maxPlayers,
    List<String> platforms,
    DateTime? releaseDate,
    int? playtimeMinutes,
    DateTime? lastPlayedAt,
  });
}

/// @nodoc
class __$$SteamGameImplCopyWithImpl<$Res>
    extends _$SteamGameCopyWithImpl<$Res, _$SteamGameImpl>
    implements _$$SteamGameImplCopyWith<$Res> {
  __$$SteamGameImplCopyWithImpl(
    _$SteamGameImpl _value,
    $Res Function(_$SteamGameImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SteamGame
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appId = null,
    Object? name = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? headerImageUrl = freezed,
    Object? genres = null,
    Object? tags = null,
    Object? isMultiplayer = null,
    Object? maxPlayers = freezed,
    Object? platforms = null,
    Object? releaseDate = freezed,
    Object? playtimeMinutes = freezed,
    Object? lastPlayedAt = freezed,
  }) {
    return _then(
      _$SteamGameImpl(
        appId: null == appId
            ? _value.appId
            : appId // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        headerImageUrl: freezed == headerImageUrl
            ? _value.headerImageUrl
            : headerImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        genres: null == genres
            ? _value._genres
            : genres // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isMultiplayer: null == isMultiplayer
            ? _value.isMultiplayer
            : isMultiplayer // ignore: cast_nullable_to_non_nullable
                  as bool,
        maxPlayers: freezed == maxPlayers
            ? _value.maxPlayers
            : maxPlayers // ignore: cast_nullable_to_non_nullable
                  as int?,
        platforms: null == platforms
            ? _value._platforms
            : platforms // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        releaseDate: freezed == releaseDate
            ? _value.releaseDate
            : releaseDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        playtimeMinutes: freezed == playtimeMinutes
            ? _value.playtimeMinutes
            : playtimeMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        lastPlayedAt: freezed == lastPlayedAt
            ? _value.lastPlayedAt
            : lastPlayedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$SteamGameImpl implements _SteamGame {
  const _$SteamGameImpl({
    required this.appId,
    required this.name,
    this.description,
    this.imageUrl,
    this.headerImageUrl,
    final List<String> genres = const [],
    final List<String> tags = const [],
    this.isMultiplayer = false,
    this.maxPlayers,
    final List<String> platforms = const [],
    this.releaseDate,
    this.playtimeMinutes,
    this.lastPlayedAt,
  }) : _genres = genres,
       _tags = tags,
       _platforms = platforms;

  @override
  final int appId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? imageUrl;
  @override
  final String? headerImageUrl;
  final List<String> _genres;
  @override
  @JsonKey()
  List<String> get genres {
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_genres);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final bool isMultiplayer;
  @override
  final int? maxPlayers;
  final List<String> _platforms;
  @override
  @JsonKey()
  List<String> get platforms {
    if (_platforms is EqualUnmodifiableListView) return _platforms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_platforms);
  }

  @override
  final DateTime? releaseDate;
  @override
  final int? playtimeMinutes;
  @override
  final DateTime? lastPlayedAt;

  @override
  String toString() {
    return 'SteamGame(appId: $appId, name: $name, description: $description, imageUrl: $imageUrl, headerImageUrl: $headerImageUrl, genres: $genres, tags: $tags, isMultiplayer: $isMultiplayer, maxPlayers: $maxPlayers, platforms: $platforms, releaseDate: $releaseDate, playtimeMinutes: $playtimeMinutes, lastPlayedAt: $lastPlayedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SteamGameImpl &&
            (identical(other.appId, appId) || other.appId == appId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.headerImageUrl, headerImageUrl) ||
                other.headerImageUrl == headerImageUrl) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isMultiplayer, isMultiplayer) ||
                other.isMultiplayer == isMultiplayer) &&
            (identical(other.maxPlayers, maxPlayers) ||
                other.maxPlayers == maxPlayers) &&
            const DeepCollectionEquality().equals(
              other._platforms,
              _platforms,
            ) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.playtimeMinutes, playtimeMinutes) ||
                other.playtimeMinutes == playtimeMinutes) &&
            (identical(other.lastPlayedAt, lastPlayedAt) ||
                other.lastPlayedAt == lastPlayedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    appId,
    name,
    description,
    imageUrl,
    headerImageUrl,
    const DeepCollectionEquality().hash(_genres),
    const DeepCollectionEquality().hash(_tags),
    isMultiplayer,
    maxPlayers,
    const DeepCollectionEquality().hash(_platforms),
    releaseDate,
    playtimeMinutes,
    lastPlayedAt,
  );

  /// Create a copy of SteamGame
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SteamGameImplCopyWith<_$SteamGameImpl> get copyWith =>
      __$$SteamGameImplCopyWithImpl<_$SteamGameImpl>(this, _$identity);
}

abstract class _SteamGame implements SteamGame {
  const factory _SteamGame({
    required final int appId,
    required final String name,
    final String? description,
    final String? imageUrl,
    final String? headerImageUrl,
    final List<String> genres,
    final List<String> tags,
    final bool isMultiplayer,
    final int? maxPlayers,
    final List<String> platforms,
    final DateTime? releaseDate,
    final int? playtimeMinutes,
    final DateTime? lastPlayedAt,
  }) = _$SteamGameImpl;

  @override
  int get appId;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get imageUrl;
  @override
  String? get headerImageUrl;
  @override
  List<String> get genres;
  @override
  List<String> get tags;
  @override
  bool get isMultiplayer;
  @override
  int? get maxPlayers;
  @override
  List<String> get platforms;
  @override
  DateTime? get releaseDate;
  @override
  int? get playtimeMinutes;
  @override
  DateTime? get lastPlayedAt;

  /// Create a copy of SteamGame
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SteamGameImplCopyWith<_$SteamGameImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SteamUserProfile {
  String get steamId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String? get profileUrl => throw _privateConstructorUsedError;
  int get communityVisibilityState => throw _privateConstructorUsedError;
  int get profileState => throw _privateConstructorUsedError;
  DateTime? get lastLogoff => throw _privateConstructorUsedError;
  bool get commentPermission => throw _privateConstructorUsedError;

  /// Create a copy of SteamUserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SteamUserProfileCopyWith<SteamUserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SteamUserProfileCopyWith<$Res> {
  factory $SteamUserProfileCopyWith(
    SteamUserProfile value,
    $Res Function(SteamUserProfile) then,
  ) = _$SteamUserProfileCopyWithImpl<$Res, SteamUserProfile>;
  @useResult
  $Res call({
    String steamId,
    String displayName,
    String? avatarUrl,
    String? profileUrl,
    int communityVisibilityState,
    int profileState,
    DateTime? lastLogoff,
    bool commentPermission,
  });
}

/// @nodoc
class _$SteamUserProfileCopyWithImpl<$Res, $Val extends SteamUserProfile>
    implements $SteamUserProfileCopyWith<$Res> {
  _$SteamUserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SteamUserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? steamId = null,
    Object? displayName = null,
    Object? avatarUrl = freezed,
    Object? profileUrl = freezed,
    Object? communityVisibilityState = null,
    Object? profileState = null,
    Object? lastLogoff = freezed,
    Object? commentPermission = null,
  }) {
    return _then(
      _value.copyWith(
            steamId: null == steamId
                ? _value.steamId
                : steamId // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            profileUrl: freezed == profileUrl
                ? _value.profileUrl
                : profileUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            communityVisibilityState: null == communityVisibilityState
                ? _value.communityVisibilityState
                : communityVisibilityState // ignore: cast_nullable_to_non_nullable
                      as int,
            profileState: null == profileState
                ? _value.profileState
                : profileState // ignore: cast_nullable_to_non_nullable
                      as int,
            lastLogoff: freezed == lastLogoff
                ? _value.lastLogoff
                : lastLogoff // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            commentPermission: null == commentPermission
                ? _value.commentPermission
                : commentPermission // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SteamUserProfileImplCopyWith<$Res>
    implements $SteamUserProfileCopyWith<$Res> {
  factory _$$SteamUserProfileImplCopyWith(
    _$SteamUserProfileImpl value,
    $Res Function(_$SteamUserProfileImpl) then,
  ) = __$$SteamUserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String steamId,
    String displayName,
    String? avatarUrl,
    String? profileUrl,
    int communityVisibilityState,
    int profileState,
    DateTime? lastLogoff,
    bool commentPermission,
  });
}

/// @nodoc
class __$$SteamUserProfileImplCopyWithImpl<$Res>
    extends _$SteamUserProfileCopyWithImpl<$Res, _$SteamUserProfileImpl>
    implements _$$SteamUserProfileImplCopyWith<$Res> {
  __$$SteamUserProfileImplCopyWithImpl(
    _$SteamUserProfileImpl _value,
    $Res Function(_$SteamUserProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SteamUserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? steamId = null,
    Object? displayName = null,
    Object? avatarUrl = freezed,
    Object? profileUrl = freezed,
    Object? communityVisibilityState = null,
    Object? profileState = null,
    Object? lastLogoff = freezed,
    Object? commentPermission = null,
  }) {
    return _then(
      _$SteamUserProfileImpl(
        steamId: null == steamId
            ? _value.steamId
            : steamId // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        profileUrl: freezed == profileUrl
            ? _value.profileUrl
            : profileUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        communityVisibilityState: null == communityVisibilityState
            ? _value.communityVisibilityState
            : communityVisibilityState // ignore: cast_nullable_to_non_nullable
                  as int,
        profileState: null == profileState
            ? _value.profileState
            : profileState // ignore: cast_nullable_to_non_nullable
                  as int,
        lastLogoff: freezed == lastLogoff
            ? _value.lastLogoff
            : lastLogoff // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        commentPermission: null == commentPermission
            ? _value.commentPermission
            : commentPermission // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$SteamUserProfileImpl implements _SteamUserProfile {
  const _$SteamUserProfileImpl({
    required this.steamId,
    required this.displayName,
    this.avatarUrl,
    this.profileUrl,
    this.communityVisibilityState = 0,
    this.profileState = 0,
    this.lastLogoff,
    this.commentPermission = false,
  });

  @override
  final String steamId;
  @override
  final String displayName;
  @override
  final String? avatarUrl;
  @override
  final String? profileUrl;
  @override
  @JsonKey()
  final int communityVisibilityState;
  @override
  @JsonKey()
  final int profileState;
  @override
  final DateTime? lastLogoff;
  @override
  @JsonKey()
  final bool commentPermission;

  @override
  String toString() {
    return 'SteamUserProfile(steamId: $steamId, displayName: $displayName, avatarUrl: $avatarUrl, profileUrl: $profileUrl, communityVisibilityState: $communityVisibilityState, profileState: $profileState, lastLogoff: $lastLogoff, commentPermission: $commentPermission)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SteamUserProfileImpl &&
            (identical(other.steamId, steamId) || other.steamId == steamId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.profileUrl, profileUrl) ||
                other.profileUrl == profileUrl) &&
            (identical(
                  other.communityVisibilityState,
                  communityVisibilityState,
                ) ||
                other.communityVisibilityState == communityVisibilityState) &&
            (identical(other.profileState, profileState) ||
                other.profileState == profileState) &&
            (identical(other.lastLogoff, lastLogoff) ||
                other.lastLogoff == lastLogoff) &&
            (identical(other.commentPermission, commentPermission) ||
                other.commentPermission == commentPermission));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    steamId,
    displayName,
    avatarUrl,
    profileUrl,
    communityVisibilityState,
    profileState,
    lastLogoff,
    commentPermission,
  );

  /// Create a copy of SteamUserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SteamUserProfileImplCopyWith<_$SteamUserProfileImpl> get copyWith =>
      __$$SteamUserProfileImplCopyWithImpl<_$SteamUserProfileImpl>(
        this,
        _$identity,
      );
}

abstract class _SteamUserProfile implements SteamUserProfile {
  const factory _SteamUserProfile({
    required final String steamId,
    required final String displayName,
    final String? avatarUrl,
    final String? profileUrl,
    final int communityVisibilityState,
    final int profileState,
    final DateTime? lastLogoff,
    final bool commentPermission,
  }) = _$SteamUserProfileImpl;

  @override
  String get steamId;
  @override
  String get displayName;
  @override
  String? get avatarUrl;
  @override
  String? get profileUrl;
  @override
  int get communityVisibilityState;
  @override
  int get profileState;
  @override
  DateTime? get lastLogoff;
  @override
  bool get commentPermission;

  /// Create a copy of SteamUserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SteamUserProfileImplCopyWith<_$SteamUserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SteamApiResponse _$SteamApiResponseFromJson(Map<String, dynamic> json) {
  return _SteamApiResponse.fromJson(json);
}

/// @nodoc
mixin _$SteamApiResponse {
  bool get success => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this SteamApiResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SteamApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SteamApiResponseCopyWith<SteamApiResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SteamApiResponseCopyWith<$Res> {
  factory $SteamApiResponseCopyWith(
    SteamApiResponse value,
    $Res Function(SteamApiResponse) then,
  ) = _$SteamApiResponseCopyWithImpl<$Res, SteamApiResponse>;
  @useResult
  $Res call({bool success, String? error});
}

/// @nodoc
class _$SteamApiResponseCopyWithImpl<$Res, $Val extends SteamApiResponse>
    implements $SteamApiResponseCopyWith<$Res> {
  _$SteamApiResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SteamApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? success = null, Object? error = freezed}) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SteamApiResponseImplCopyWith<$Res>
    implements $SteamApiResponseCopyWith<$Res> {
  factory _$$SteamApiResponseImplCopyWith(
    _$SteamApiResponseImpl value,
    $Res Function(_$SteamApiResponseImpl) then,
  ) = __$$SteamApiResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String? error});
}

/// @nodoc
class __$$SteamApiResponseImplCopyWithImpl<$Res>
    extends _$SteamApiResponseCopyWithImpl<$Res, _$SteamApiResponseImpl>
    implements _$$SteamApiResponseImplCopyWith<$Res> {
  __$$SteamApiResponseImplCopyWithImpl(
    _$SteamApiResponseImpl _value,
    $Res Function(_$SteamApiResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SteamApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? success = null, Object? error = freezed}) {
    return _then(
      _$SteamApiResponseImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SteamApiResponseImpl implements _SteamApiResponse {
  const _$SteamApiResponseImpl({required this.success, this.error});

  factory _$SteamApiResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SteamApiResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String? error;

  @override
  String toString() {
    return 'SteamApiResponse(success: $success, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SteamApiResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, error);

  /// Create a copy of SteamApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SteamApiResponseImplCopyWith<_$SteamApiResponseImpl> get copyWith =>
      __$$SteamApiResponseImplCopyWithImpl<_$SteamApiResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SteamApiResponseImplToJson(this);
  }
}

abstract class _SteamApiResponse implements SteamApiResponse {
  const factory _SteamApiResponse({
    required final bool success,
    final String? error,
  }) = _$SteamApiResponseImpl;

  factory _SteamApiResponse.fromJson(Map<String, dynamic> json) =
      _$SteamApiResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String? get error;

  /// Create a copy of SteamApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SteamApiResponseImplCopyWith<_$SteamApiResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
