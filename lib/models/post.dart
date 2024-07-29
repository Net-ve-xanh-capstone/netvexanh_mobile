import 'package:json_annotation/json_annotation.dart';
import 'package:netvexanh_mobile/models/image.dart';
part 'map/post.g.dart';

@JsonSerializable()
class Post {
   String? id;
   String? url;
   String? title;
   String? description;
   String? staffId;
   String? categoryId;
   String? categoryName;
   List<Image>? images;

  Post(this.id, this.url, this.title, this.description, this.staffId, this.categoryId, this.categoryName, this.images);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.

  factory Post.fromJson(Map<String, dynamic> json) =>
      _$PostFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
