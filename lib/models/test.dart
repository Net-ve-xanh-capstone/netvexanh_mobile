import 'package:json_annotation/json_annotation.dart';
import 'package:netvexanh_mobile/models/painting.dart';

part 'test.g.dart';

@JsonSerializable()
class Test {
  String Id;
  int quantity;
  List<Painting> images;

  Test(this.Id, this.quantity, this.images);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.

  factory Test.fromJson(Map<String, dynamic> json) => _$TestFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$TestToJson(this);
}
