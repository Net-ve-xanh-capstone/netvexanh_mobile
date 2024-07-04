import 'package:json_annotation/json_annotation.dart';
import 'package:netvexanh_mobile/models/refresh_token.dart';

part 'map/jwt_token.g.dart';

@JsonSerializable()
class JwtToken {
  String? jwToken;
  bool? success;
  String? message;
  RefreshToken refreshToken;

  JwtToken(this.jwToken, this.success, this.message, this.refreshToken);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.

  factory JwtToken.fromJson(Map<String, dynamic> json) =>
      _$JwtTokenFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$JwtTokenToJson(this);
}
