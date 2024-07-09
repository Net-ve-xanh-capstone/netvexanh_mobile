
import 'package:json_annotation/json_annotation.dart';

part 'painting.g.dart';

@JsonSerializable()
class Painting {

    String Id;
    String? Image;
    String? Name;
    String? Description;
    late DateTime SubmitTime;
    String? RoundTopicId;
    String? ScheduleId;
    String? Status;
    String? Code;
    String? OwnerName;

  //Painting(this.Id, this.Image, this.Name, this.Description, this.SubmitTime, this.RoundTopicId, this.ScheduleId, this.Status, this.Code, this.OwnerName);
    Painting({
    required this.Id,
    required this.Image,
    required this.Name,
    required this.Description,
    required this.SubmitTime,
    required this.RoundTopicId,
    required this.ScheduleId,
    required this.Status,
    required this.Code,
    required this.OwnerName,
  });

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.

  factory Painting.fromJson(Map<String, dynamic> json) =>
      _$PaintingFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$PaintingToJson(this);
}
