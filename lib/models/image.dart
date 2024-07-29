import 'package:json_annotation/json_annotation.dart';

part 'map/image.g.dart';

@JsonSerializable()
class Image {
  String? id;
  String? url;

  Image(this.id, this.url);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ImageToJson(this);
}
