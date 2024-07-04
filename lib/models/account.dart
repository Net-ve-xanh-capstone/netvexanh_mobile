import 'package:json_annotation/json_annotation.dart';

part 'map/account.g.dart';

@JsonSerializable()
class Account {
    String? username;
    String? avatar;
    DateTime? birthday;
    String? fullName;
    String? email;
    String? address;
    String? phone;
    bool gender;

  Account(this.username, this.avatar, this.birthday, this.fullName, this.email, this.address, this.phone, this.gender);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
