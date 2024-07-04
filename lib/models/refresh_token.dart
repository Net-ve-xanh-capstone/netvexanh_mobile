import 'package:json_annotation/json_annotation.dart';

part 'map/refresh_token.g.dart';

@JsonSerializable()
class RefreshToken {
    DateTime? current;
    DateTime? createTime;
    DateTime? expired;
    String? token;

  RefreshToken(this.current, this.createTime, this.expired, this.token);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.

  factory RefreshToken.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RefreshTokenToJson(this);
}
