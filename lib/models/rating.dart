import 'package:json_annotation/json_annotation.dart';
import 'package:netvexanh_mobile/models/painting_result.dart';

part 'map/rating.g.dart';

@JsonSerializable()
class Rating {
  String scheduleId;
  List<PaintingResult>? paintings;

  Rating(this.scheduleId, this.paintings);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.

  factory Rating.fromJson(Map<String, dynamic> json) =>
      _$RatingFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RatingToJson(this);
}
