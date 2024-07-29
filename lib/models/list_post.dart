import 'package:json_annotation/json_annotation.dart';

part 'map/list_post.g.dart';

@JsonSerializable()
class ListPost {
   String? id;
   String? image;
   String? title;
   String? description;
   String? staffId;
   String? categoryId;
   String? categoryName;


  ListPost(this.id, this.image, this.title, this.description, this.staffId, this.categoryId, this.categoryName);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.

  factory ListPost.fromJson(Map<String, dynamic> json) =>
      _$ListPostFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ListPostToJson(this);
}
