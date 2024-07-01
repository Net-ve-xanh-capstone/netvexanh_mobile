import 'package:json_annotation/json_annotation.dart';

part 'account1.g.dart';

@JsonSerializable()
class Account1 {
  String? email;
  String? thumbnail;

  Account1(this.email, this.thumbnail);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.

  factory Account1.fromJson(Map<String, dynamic> json) =>
      _$Account1FromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$Account1ToJson(this);
}
